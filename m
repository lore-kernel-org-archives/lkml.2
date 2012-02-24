Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937Ab2BXLrq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 06:47:46 -0500
Received: from mail.skyhub.de ([78.46.96.112]:55647 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753204Ab2BXLro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 06:47:44 -0500
Date: Fri, 24 Feb 2012 12:47:51 +0100
From: Borislav Petkov <bp@alien8.de>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/5] x86: Cleanup and simplify cpu-specific data
Message-ID: <20120224114751.GA9510@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Kevin Winchester <kjwinchester@gmail.com>,
	Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Nick Bowler <nbowler@elliptictech.com>,
	linux-kernel@vger.kernel.org
References: <1330041476-719-1-git-send-email-kjwinchester@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1330041476-719-1-git-send-email-kjwinchester@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 07:57:51PM -0400, Kevin Winchester wrote:
> Various per-cpu fields are define in arch/x86/kernel/smpboot.c that are
> basically equivalent to the cpu-specific data in struct cpuinfo_x86.
> By moving these fields into the structure, a number of codepaths can be
> simplified since they no longer need to care about those fields not
> existing on !SMP builds.
> 
> The size effects on allno (UP) and allyes (MAX_SMP) kernels are as
> follows:
> 
>    text	   	data	    	bss	    	dec	    	hex	filename
> 1586721	 	304864	 	506208		2397793	 	249661	vmlinux.allno
> 1588517	 	304928	 	505920		2399365	 	249c85	vmlinux.allno.after
> 84706053	13212311	42434560	140352924	85d9d9c	vmlinux.allyes
> 84705333	13213799	42434560	140353692	85da09c	vmlinux.allyes.afte
> 
> As can be seen, the kernels get slighly larger, but the code reduction/
> simplification should be enough to compensate for it.

Just a hint for the future: when you're sending multiple versions of
a patchset, it would be really helpful to have changelog in the 0/n
message so that the reviewer can know what happened in each version.
I.e.,

v4:
	Rediff changes against -rc4

v3:
	Small cleanups, integrate comments.

etc.

Otherwise, we have to go look at the older patches and compare what
changed.

HTH.

-- 
Regards/Gruss,
Boris.
