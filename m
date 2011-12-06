Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab1LFT4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:56:38 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:50008 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab1LFT4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:56:37 -0500
Date: Tue, 6 Dec 2011 20:56:30 +0100
From: Borislav Petkov <bp@amd64.org>
To: Tony Luck <tony.luck@intel.com>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>, H Peter Anvin <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Brown, Len" <len.brown@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH] x86/mcheck/therm_throt.c: Don't log power limit and
 package level thermal throttle event in mce log
Message-ID: <20111206195630.GH20445@aftab>
References: <1321305082-31310-1-git-send-email-fenghua.yu@intel.com>
 <20111205131825.GA31275@gere.osrc.amd.com>
 <0207C53569FE594381A4F2EB66570B2A018EE61884@orsmsx508.amr.corp.intel.com>
 <20111206153108.GD28735@gere.osrc.amd.com>
 <43F901BD926A4E43B106BF17856F075501A22B5365@orsmsx508.amr.corp.intel.com>
 <20111206190648.GB20445@aftab>
 <CA+8MBb+v_HJ=odHMTZUP_LuNkAj=dHPC28i3HWAkemW7CN=hMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+8MBb+v_HJ=odHMTZUP_LuNkAj=dHPC28i3HWAkemW7CN=hMw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 11:26:03AM -0800, Tony Luck wrote:
> On Tue, Dec 6, 2011 at 11:06 AM, Borislav Petkov <bp@amd64.org> wrote:
> > I can see all that. Still, I'm questioning the need for those printks. A
> > user application polling the counters is a much better solution, IMHO,
> > than spamming the logs. IOW, is there a strong reason to have this -
> > even ratelimited - information in the logs and unnerve users, or, would
> > it be better to collect this info somewhere queitly and present it only
> > when something requests it?
> 
> Striking the right balance here is hard - if one has a BIOS that set the
> thresholds at "interesting" values - then you certainly don't want to the
> console to be spammed with a lot of useless junk.
> 
> But if there is a real problem - then having someone tell you later that
> you should have been checking some obscure file in /sys to see that
> some thermal/power limit events were being seen may not go over very
> well.

Agreed.

> When we have some comprehensive system health monitoring daemon that
> does check these files, and can be configured to raise suitable
> alerts, then the printks can go away.

Ok, that makes sense, actually. A follow-up: what recovery handling are
you thinking of here, maybe force-suspend the box or disable boosting or
whatever?

All I'm saying is, how does one take care of the real problem you
mention above? I hope you're seeing my point here: I'm simply
questioning the fact whether printk's are optimal here.

But, before we completely drift off, to answer your original question:
I'm fine with the patch, it is Intel-only anyway so if you guys feel it
is a step in the right direction, you can have my ACK.

The printks story sounds like something we'll not be solving today
anyway, so... :-)

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
