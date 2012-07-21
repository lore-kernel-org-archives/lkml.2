Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752Ab2GUKrB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 06:47:01 -0400
Received: from osrc3.amd.com ([217.9.48.20]:48620 "EHLO mail.x86-64.org"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751431Ab2GUKrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 06:47:00 -0400
X-Greylist: delayed 582 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Jul 2012 06:47:00 EDT
Date: Sat, 21 Jul 2012 12:37:15 +0200
From: Borislav Petkov <bp@amd64.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Borislav Petkov <borislav.petkov@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?Andr=E9?= Przywara <andre.przywara@amd.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 2/2] cpu: intel, amd: mask cleared cpuid features
Message-ID: <20120721103715.GA3632@aftab.osrc.amd.com>
References: <73e09fb43e37de851acda10dc64bc495a5b68357.1342801662.git.vdavydov@parallels.com>
 <dd185bfa60b6478e7eb1bce455c9d082ec884abe.1342801662.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd185bfa60b6478e7eb1bce455c9d082ec884abe.1342801662.git.vdavydov@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(+ Andre who's been doing some cross vendor stuff)

On Fri, Jul 20, 2012 at 08:37:33PM +0400, Vladimir Davydov wrote:
> If 'clearcpuid=N' is specified in boot options, CPU feature #N won't be
> reported in /proc/cpuinfo and used by the kernel. However, if a
> userpsace process checks CPU features directly using the cpuid
> instruction, it will be reported about all features supported by the CPU
> irrespective of what features are cleared.
> 
> The patch makes the clearcpuid boot option not only clear CPU features
> in kernel but also mask them in hardware for Intel and AMD CPUs that
> support it so that the features cleared won't be reported even by the
> cpuid instruction.
> 
> This can be useful for migration of virtual machines managed by
> hypervisors that do not support/use Intel VT/AMD-V hardware-assisted
> virtualization technology.

As they say in Star Wars: "I have a bad feeling about this."

So opening the floodgates to people fiddling with this (not only
migrators) makes me feel pretty uneasy. And I won't wonder if all of
a sudden strange failures start to appear because code is querying
cpuid features but some funny distro has disabled it in its kernel boot
options.

Or some other obscure case where the culprit is hidden in kernel command
line options.

If it were only needed for migration, then I'd say you guys can use
msr-tools and run a script as root on the target machine to which you
want to migrate to and toggle the feature bits you want.

I don't think cross vendor migration alone justifies having a generic
kernel feature like that.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
