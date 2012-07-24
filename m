Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab2GXHsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 03:48:18 -0400
Received: from osrc3.amd.com ([217.9.48.20]:57120 "EHLO mail.x86-64.org"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755084Ab2GXHsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 03:48:17 -0400
Date: Tue, 24 Jul 2012 09:48:12 +0200
From: Borislav Petkov <bp@amd64.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?iso-8859-1?Q?Andr=E9?= Przywara <andre.przywara@amd.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 2/2] cpu: intel, amd: mask cleared cpuid features
Message-ID: <20120724074812.GA23541@aftab.osrc.amd.com>
References: <73e09fb43e37de851acda10dc64bc495a5b68357.1342801662.git.vdavydov@parallels.com>
 <dd185bfa60b6478e7eb1bce455c9d082ec884abe.1342801662.git.vdavydov@parallels.com>
 <20120721103715.GA3632@aftab.osrc.amd.com>
 <500E4960.8040307@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <500E4960.8040307@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 11:06:08AM +0400, Vladimir Davydov wrote:
> If msr-tools are used for cpuid masking, we will either get
> inconsistency between /proc/cpuinfo:flags and the output of the cpuid
> instruction or have to "synchronize" the clearcpuid boot option and
> the userspace app using msr-tools, which seems to be inconvenient.

Right, so IMO what you want to do is not very kosher as a generic kernel
feature for reasons described earlier.

And yes, "synchronizing" /proc/cpuinfo's flags and CPUID output is a lot
less pain compared to having a generic abusable feature.

And also much better suited for your niche use case than opening this up
as a generic functionality to the wide public which will most definitely
find productive ways to abuse this.

Simply ask yourself this: is this something which the majority of
x86 linux users will benefit from or is it only something which is
nice-to-have solely for our single use case?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
