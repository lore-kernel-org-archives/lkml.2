Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab1AZRFn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 12:05:43 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:42706 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab1AZRFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 12:05:42 -0500
X-SpamScore: -11
X-BigFish: VPS-11(zz1432N98dNzz1202hzz8275bhz32i637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LFN3HA-01-09K-02
X-M-MSG: 
Date: Wed, 26 Jan 2011 18:05:32 +0100
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "hpa@zytor.com" <hpa@zytor.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 4/4] x86, amd: Support L3 Cache Partitioning on AMD
 family 0x15 CPUs
Message-ID: <20110126170532.GG877@escobedo.osrc.amd.com>
References: <1295881543-572552-1-git-send-email-hans.rosenfeld@amd.com>
 <1295881543-572552-5-git-send-email-hans.rosenfeld@amd.com>
 <20110126105637.GA27809@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110126105637.GA27809@elte.hu>
Organization: Advanced Micro Devices GmbH, Einsteinring 24, 85609 Dornach b.
 Muenchen; Geschaeftsfuehrer: Andrew Bowd, Alberto Bozzo; Sitz: Dornach,
 Gemeinde Aschheim, Landkreis Muenchen; Registergericht Muenchen, HRB Nr.
 43632
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 05:56:37AM -0500, Ingo Molnar wrote:
> 
> * Hans Rosenfeld <hans.rosenfeld@amd.com> wrote:
> 
> > L3 Cache Partitioning allows selecting which of the 4 L3 subcaches can
> > be used for evictions by the L2 cache of each compute unit. By writing a
> > 4-bit hexadecimal mask into the the sysfs file /sys/devices/system/cpu/\
> > cpuX/cache/index3/subcaches, the user can set the enabled subcaches for
> > a CPU. The settings are directly read from and written to the hardware,
> > so there is no way to have contradicting settings for two CPUs belonging
> > to the same compute unit. Writing will always overwrite any previous
> > setting for a compute unit.
> > 
> > Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
> > ---
> >  arch/x86/include/asm/amd_nb.h         |    3 +
> >  arch/x86/kernel/amd_nb.c              |   55 +++++++++++++++++++++++++
> >  arch/x86/kernel/cpu/intel_cacheinfo.c |   73 +++++++++++++++++++++++++++-----
> >  3 files changed, 119 insertions(+), 12 deletions(-)
> 
> I have picked up the other 3 patches, but this one causes this build failure:
> 
>  arch/x86/kernel/amd_nb.c: In function ?amd_get_subcaches?:
>  arch/x86/kernel/amd_nb.c:129:36: error: ?struct cpuinfo_x86? has no member named ?compute_unit_id?
>  arch/x86/kernel/amd_nb.c: In function ?amd_set_subcaches?:
>  arch/x86/kernel/amd_nb.c:154:28: error: ?struct cpuinfo_x86? has no member named ?compute_unit_id?
>  arch/x86/kernel/amd_nb.c:155:36: error: ?struct cpuinfo_x86? has no member named ?compute_unit_id?
>  arch/x86/kernel/amd_nb.c: In function ?amd_get_subcaches?:
>  arch/x86/kernel/amd_nb.c:130:1: warning: control reaches end of non-void function

Hrmpf. CONFIG_SMP.

Sorry for the noise, fixed patch will follow shortly.


Hans


-- 
%SYSTEM-F-ANARCHISM, The operating system has been overthrown

