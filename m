Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab0JDR2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 13:28:48 -0400
Received: from smtp-out.google.com ([74.125.121.35]:5580 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508Ab0JDR2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 13:28:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=fmLXp7fBgiVA1Hf2u7VYE1IsmhSOyAmQ7NI+sgIQevtsTNUt58ZPeDhpYCt/BCQiug
         wEa2+k2U0dmEea9uggIA==
MIME-Version: 1.0
In-Reply-To: <20101004090728.GC20013@basil.fritz.box>
References: <20100929170924.GR13563@erda.amd.com>
	<20100929181207.GW26290@redhat.com>
	<AANLkTimp=+1GzBOYaUZWtDF6teGt6FZe+RTpb9fAyOyd@mail.gmail.com>
	<20100930091246.GV13563@erda.amd.com>
	<20100930194451.GI26290@redhat.com>
	<20101001071750.GB13563@erda.amd.com>
	<AANLkTimUyLaVaBigjm0-CwRsdh4UXWDiss2ffX53S+k_@mail.gmail.com>
	<AANLkTik4KmzqeHTGXZAcQtg80YkBRPDqegLOaMvTvDAQ@mail.gmail.com>
	<20101002093524.GJ13563@erda.amd.com>
	<AANLkTi=YNhc0g+Cwcwg=DdoYJUxO7sb6GZSAEC-qvEU+@mail.gmail.com>
	<20101004090728.GC20013@basil.fritz.box>
Date: Mon, 4 Oct 2010 19:28:42 +0200
Message-ID: <AANLkTikPpE+ewz5NUVRV5ASdGv+a=ZxHnckfUaWs-KCD@mail.gmail.com>
Subject: Re: [tip:perf/urgent] perf, x86: Catch spurious interrupts after
 disabling counters
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Robert Richter <robert.richter@amd.com>, Huang Ying <ying.huang@intel.com>,
        Don Zickus <dzickus@redhat.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

On Mon, Oct 4, 2010 at 11:07 AM, Andi Kleen <andi@firstfloor.org> wrote:
>> I haven't seen Andi's suggestion. But I am guessing he is suggesting
>> adding a new chain that would be called first and where there would
>> ONLY be the perf_event subsystem. To handle the spurious PMU
>
> I was thinking of a separate NMI chain
>

You mean separate callbacks which rely on getting an NMI interrupt
from those which don't? If so, I definitively agree with you on that.


> (and longer term really splitting the die chains into separate chains,
> that would solve other problems e.g. with page fault performance
> too)
>
> Possibly that NMI chain could be split up too, but not sure
> this is really needed.
>
You need to split to enforce more explicit priority scheme than what
you  have today with an ordered list per chain.
