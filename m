Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440Ab2GYKnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 06:43:53 -0400
Received: from osrc3.amd.com ([217.9.48.20]:34568 "EHLO mail.x86-64.org"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755533Ab2GYKnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 06:43:51 -0400
Date: Wed, 25 Jul 2012 12:43:46 +0200
From: Borislav Petkov <bp@amd64.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Andre Przywara <andre.przywara@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Pavel Emelianov <xemul@parallels.com>,
        Konstantin Khorenko <khorenko@parallels.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH 2/2] cpu: intel, amd: mask cleared cpuid features
Message-ID: <20120725104346.GA11152@aftab.osrc.amd.com>
References: <73e09fb43e37de851acda10dc64bc495a5b68357.1342801662.git.vdavydov@parallels.com>
 <dd185bfa60b6478e7eb1bce455c9d082ec884abe.1342801662.git.vdavydov@parallels.com>
 <20120721103715.GA3632@aftab.osrc.amd.com>
 <500E4960.8040307@parallels.com>
 <500E5951.5020900@amd.com>
 <500E5CDF.5000504@parallels.com>
 <20120724101041.GA24739@aftab.osrc.amd.com>
 <500E8280.6050905@parallels.com>
 <500E9664.9030306@amd.com>
 <500FCAFB.4080301@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <500FCAFB.4080301@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 02:31:23PM +0400, Vladimir Davydov wrote:
> So, you prefer adding some filtering of /proc/cpuinfo into the
> mainstream kernel

That's already there right? And your 1/2 patch was making toggling those
bits easier.

> (not now, later, for LXC to work) instead of enabling clearcpuid boot
> option to mask CPUID features? IMO, the latter would look clearer.

Yes, but for reasons noted earlier, you cannot tweak all hardware CPUID
features as you want them.

So, having a software-only layer of tweaking /proc/cpuinfo or something
different you can come up with is the only option you have.

And even in that case, applications running in the container which
execute CPUID might fail in a strange manner when the corresponding
/proc/cpuinfo flag was cleared by you intentionally but the hardware
CPUID flag is there. In such situations, issues like that should
probably be sorted on a case-by-case basis I guess.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
