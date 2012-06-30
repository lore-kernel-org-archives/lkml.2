Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab2F3RpN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 13:45:13 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:60824 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797Ab2F3RpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 13:45:10 -0400
Date: Sat, 30 Jun 2012 19:45:03 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Cc: X86-ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH -v2 0/2] x86, microcode: Reload ucode only per-system
Message-ID: <20120630174503.GA24854@aftab.osrc.amd.com>
References: <1340280437-7718-1-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340280437-7718-1-git-send-email-bp@amd64.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assuming there are no more objections to those, can we get them into,
say, tip:x86/microcode for a wider, linux-next testing?

Peter's stuff could go there too or through the perf tree - it's kinda
arbitrary though.

Thanks.

On Thu, Jun 21, 2012 at 02:07:15PM +0200, Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Ok, here's the second version with all review comments addressed. I've
> dropped the stable tag since this has been that way (and b0rked) since
> forever so stable rules don't apply.
> 
> We can probably do single backports if distros want it.
> 
> 
> 
> Changelog:
> 
> -v1:
> 
> Once upon a time there was this microcode reloading interface
> /sys/devices/system/cpu/cpuX/microcode/reload, where X is an online
> cpu on the system, which allowed the loading of microcode in a per-cpu
> manner.
> 
> This had problems like having different ucode revisions on an otherwise
> homogeneous system and needed O(n^2) overhead when tracking minimum
> microcode revision per-core.
> 
> So make this interface per-system so that it does microcode reloading on
> the whole system only.
> 
> Single commit messages have more info too.
> 
> The first patch has a stable tag which I'd like to see in stable but
> since it is not fixing a direct regression, I'd like to not push it
> upstream now but have it get tested in linux-next and go upstream during
> the next merge window from where it can trickle slowly to stable.
> 
> Patches have been tested on all AMD families, it wouldn't hurt if it saw
> some Intel testing too, although it should just work.
> 
> Holler if you see regressions/problems with it.
> 
> Thanks.
> 

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
