Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700Ab0KJUxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 15:53:16 -0500
Received: from smtp-out.google.com ([74.125.121.35]:12210 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769Ab0KJUxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 15:53:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=VCsmIGuKZICHiaI5xL5pdnDOEzELNi2d+fBE+EOqO2R7NmZtY/DvarRVa4pll7EmsM
         fcuwNYHXEdcalrxWkItw==
MIME-Version: 1.0
In-Reply-To: <1289421164.2084.56.camel@laptop>
References: <1289339119.2191.92.camel@laptop>
	<AANLkTi=ojOnLyRO4hTgYdCCXLsN0wUeTcme=5h8-mjdz@mail.gmail.com>
	<1289398207.2191.117.camel@laptop>
	<1289398763.2191.121.camel@laptop>
	<AANLkTimQ7w38wzrYT4MgjHFr6LCVj2M5fB11-n3XCD2w@mail.gmail.com>
	<1289421164.2084.56.camel@laptop>
Date: Wed, 10 Nov 2010 21:53:10 +0100
Message-ID: <AANLkTiku7UsVoYv_+6r79rvGPJU7OU=VGDiaYo0H=82y@mail.gmail.com>
Subject: Re: [RFC][PATCH] perf: sysfs type id
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Lin Ming <ming.m.lin@intel.com>,
        "robert.richter" <robert.richter@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        fweisbec <fweisbec@gmail.com>, paulus <paulus@samba.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 9:32 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-11-10 at 21:08 +0100, Stephane Eranian wrote:
>> Would that be by passing the full filename to the tool?
>
> possible, or something like <pmu-name>:<event-name>, cpu:cycles would
> map to /sys/class/pmu/cpu/events/cycles (given the previous patch).
>
>
Ok, but I think you're proposal is missing one bit. You are addressing
the class (or type) of PMU, but you are not addressing the naming of
an instance.

Let's take an example, suppose you have counters on a graphic card.
Your system has two such graphic cards. In your scheme you would
end up with a sys/class/pmu/gfx/.....

But now, suppose I want to count cycles on the first graphic card.
Seems to me you need to expose the instances as well. The instance
number needs to be passed in the attr struct somehow.

You can either create multiple subdir under gfx, or have this info somewhere
else in the sysfs tree, if people really care about class vs. instance.

I can see users doing:
$ perf stat -e gfx@1::cycles ...  -> sys/class/gfx/1/event/cycles

The reason I am using :: here is because libpfm4 is already using
this as a separator for PMU type vs. event.
