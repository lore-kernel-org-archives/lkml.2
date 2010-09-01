Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355Ab0IANEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 09:04:50 -0400
Received: from smtp-out.google.com ([74.125.121.35]:7526 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab0IANEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 09:04:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=J1bxfB8MoW4eaNtFcGDGrgcO4VPkIV/av3xLDXs3qXAMfhCRs0bdeLBwLaP2qEetWC
         VXSWK+p99qMAwnKEJq4w==
MIME-Version: 1.0
Date: Wed, 1 Sep 2010 15:04:45 +0200
Message-ID: <AANLkTimA-AZWJugaLR3VPGVhBaJid=t=a1rPVNUE_8Dh@mail.gmail.com>
Subject: Re: [PATCH 4/4] [x86] perf: fix accidentally ack'ing a second event
 on intel perf counter
From: Stephane Eranian <eranian@google.com>
To: Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don,

Found your patch on LKML (I am not on it).

In your changelog you said:

> During testing of a patch to stop having the perf subsytem swallow nmis,
> it was uncovered that Nehalem boxes were randomly getting unknown nmis
> when using the perf tool.
>
> Moving the ack'ing of the PMI closer to when we get the status allows
> the hardware to properly re-set the PMU bit signaling another PMI was
> triggered during the processing of the first PMI.  This allows the new
> logic for dealing with the shortcomings of multiple PMIs to handle the
> extra NMI by 'eat'ing it later.

> Now one can wonder why are we getting a second PMI when we disable all
> the PMUs in the beginning of the NMI handler to prevent such a case, for
> that I do not know.  But I know the fix below helps deal with this quirk.
>

I am assuming you're talking about back-to-back NMIs here, not nested NMIs.
I don't quite understand the scenario here. Is it the case that you handled 1
overflow, and then right as you return from the interrupt, you get a second
PMI with a ovfl_status=0 ?

What events did you measure? Which counters did you use?
Did you have HT turned on?

> Tested on multiple Nehalems where the problem was occuring.  With the
> patch, the code now loops a second time to handle the second PMI (whereas
> before it was not).
