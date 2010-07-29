Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab0G2KRY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 06:17:24 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:34795 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756613Ab0G2KRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 06:17:20 -0400
Date: Thu, 29 Jul 2010 12:16:04 +0200
From: Borislav Petkov <bp@amd64.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Vasiliy Kulikov <segooon@gmail.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/10] x86: mce: fix error handling
Message-ID: <20100729101604.GA26495@aftab>
References: <1280335185-23265-1-git-send-email-segooon@gmail.com>
 <4C5063D4.4070108@linux.intel.com>
 <20100728171327.GA24149@albatros>
 <4C5066CB.7010009@linux.intel.com>
 <20100729093511.GB7143@albatros>
 <4C514F04.80603@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C514F04.80603@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>
Date: Thu, Jul 29, 2010 at 05:51:00AM -0400

> 
> > IMO memmory allocation fails are dangerous in kernel mode. As it is
> > probably not exploitable because of boot time, it can destroy some
> > sensitive data like dirty disk caches those are going to be written on
> > disk.
> 
> It's true for runtime, but not for normal boot time.
> 
> Anyways if it happens on boot time the only thing you can do is panic, 
> but someone else
> will likely panic anyways for you. Just ignoring it like your patch 
> effectively does
> (because nothing will ever look at the ENOMEMs for an initcall)

Not true, initcall_debug will at least dump the -ENOMEM or the other
-E's if enabled on the cmdline. So even only for that case does the
patch make sense.

It's a whole different question whether it actually is prudent to turn
on error reporting of failed initcalls unconditionally.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
