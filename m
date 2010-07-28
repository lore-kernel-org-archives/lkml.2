Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919Ab0G1U0p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 16:26:45 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61001 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659Ab0G1U0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 16:26:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Sb5xcJoL5o1y5cz7bpBNZdL4r/AW8a/SmvlO+yQIWd+sE2pQFA3ilWpAMw0L4IVIP4
         cwhpWrOCjiIWgpVZavFjpWiHScs7gaXOwMH4OCFTsVeFzDV7CFWQf/cG9Az2Ooi2EE0W
         SKVWXEcc0l4pK42vP0tVVuOENmUlbczOr3HKs=
MIME-Version: 1.0
In-Reply-To: <20100727210210.58d3118c@infradead.org>
References: <20100727210210.58d3118c@infradead.org>
Date: Wed, 28 Jul 2010 13:26:39 -0700
X-Google-Sender-Auth: Pyzfzkz-BJxY66-KX4ECairz19w
Message-ID: <AANLkTikZ_RHHv9cudUh8pp9H8MtKO8Rsr+eboupv49xD@mail.gmail.com>
Subject: Re: [patch] Remove the per cpu tick skew
From: john stultz <johnstul@us.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 9:02 PM, Arjan van de Ven <arjan@infradead.org> wrote:
> the following patch is a win for power management on x86....
> ... but since this touches generic code.. are there any
> other architectures that would be negatively affected by this?

It was added to avoid contention when all the cpus grabbed the
xtime_lock (causing latency spikes of timer overhead * number of
cpus). We don't grab the xtime lock everywhere anymore, so that
shouldn't bite us, but I'm curious if there are not other global locks
taken that may see extra contention without this change.

> Subject: [patch] Remove the per cpu tick skew
>
> Historically, Linux has tried to make the regular timer tick on the various
> CPUs not happen at the same time, to avoid contention on xtime_lock.
>
> Nowadays, with the tickless kernel, this contention no longer happens
> since time keeping and updating are done differently. In addition,
> this skew is actually hurting power consumption in a measurable
> way on many-core systems.
>
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

I'll give it a spin against -rt and see if we show any latency jumps.

thanks
-john
