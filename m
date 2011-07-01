Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608Ab1GANiH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 09:38:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:55239 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756537Ab1GANiD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 09:38:03 -0400
Subject: Re: [tip:perf/core] perf: Ignore non-sampling overflows
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Robert Richter <robert.richter@amd.com>
Cc: Francis Moreau <francis.moro@gmail.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>
In-Reply-To: <20110630124752.GS4590@erda.amd.com>
References: <tip-963988262c3c8f4234f64a0dde59446a295e07bb@git.kernel.org>
	 <20110628105335.GA17199@erda.amd.com> <1309259105.6701.210.camel@twins>
	 <BANLkTimcxGWasWqgem=5EYDKGAM+dq26xQ@mail.gmail.com>
	 <20110629103714.GM4590@erda.amd.com> <1309344655.6701.1054.camel@twins>
	 <20110629141056.GN4590@erda.amd.com> <1309358386.6701.1307.camel@twins>
	 <20110630124752.GS4590@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 01 Jul 2011 15:36:56 +0200
Message-ID: <1309527416.12449.729.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-30 at 14:47 +0200, Robert Richter wrote:
> 
> It covers the case there the sampling period may be specified in the
> raw config register (line 286). I know, this is not the preferred way,
> but this way you can directly set the config value in perf without
> bypassing some bits through event->attr. As IBS events are sampling
> events I will change the code so that it writes back the specified
> period to event->attr.sample_period/event->hw.sample_period. Something
> like:
> 
>         if (event->hw.sample_period) {
>                 ...
>         } else {
>                 max_cnt = event->attr.config & map->cnt_mask;
>                 event->attr.sample_period = max_cnt << 4;
>                 event->hw.sample_period = event->attr.sample_period;
>         }
> 
> This will then proper identify IBS samples as samling event.

Ah, being a naught boy then ;-), yeah passing stuff through like that
will confuse bits and the fixup you propose will indeed work around
that.

But why complicate things like this? You just add extra code to the init
path since you need to support attr.sample_period input as well.
