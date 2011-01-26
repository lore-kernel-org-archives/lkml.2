Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977Ab1AZK4s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 05:56:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35953 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720Ab1AZK4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 05:56:47 -0500
Date: Wed, 26 Jan 2011 11:56:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: hpa@zytor.com, tglx@linutronix.de, andreas.herrmann3@amd.com,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 4/4] x86, amd: Support L3 Cache Partitioning on AMD
 family 0x15 CPUs
Message-ID: <20110126105637.GA27809@elte.hu>
References: <1295881543-572552-1-git-send-email-hans.rosenfeld@amd.com>
 <1295881543-572552-5-git-send-email-hans.rosenfeld@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1295881543-572552-5-git-send-email-hans.rosenfeld@amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.8 required=5.9 tests=BAYES_00,SUBJECT_FUZZY_TION autolearn=no SpamAssassin version=3.2.5
	0.2 SUBJECT_FUZZY_TION     Attempt to obfuscate words in Subject:
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hans Rosenfeld <hans.rosenfeld@amd.com> wrote:

> L3 Cache Partitioning allows selecting which of the 4 L3 subcaches can
> be used for evictions by the L2 cache of each compute unit. By writing a
> 4-bit hexadecimal mask into the the sysfs file /sys/devices/system/cpu/\
> cpuX/cache/index3/subcaches, the user can set the enabled subcaches for
> a CPU. The settings are directly read from and written to the hardware,
> so there is no way to have contradicting settings for two CPUs belonging
> to the same compute unit. Writing will always overwrite any previous
> setting for a compute unit.
> 
> Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
> ---
>  arch/x86/include/asm/amd_nb.h         |    3 +
>  arch/x86/kernel/amd_nb.c              |   55 +++++++++++++++++++++++++
>  arch/x86/kernel/cpu/intel_cacheinfo.c |   73 +++++++++++++++++++++++++++-----
>  3 files changed, 119 insertions(+), 12 deletions(-)

I have picked up the other 3 patches, but this one causes this build failure:

 arch/x86/kernel/amd_nb.c: In function ‘amd_get_subcaches’:
 arch/x86/kernel/amd_nb.c:129:36: error: ‘struct cpuinfo_x86’ has no member named ‘compute_unit_id’
 arch/x86/kernel/amd_nb.c: In function ‘amd_set_subcaches’:
 arch/x86/kernel/amd_nb.c:154:28: error: ‘struct cpuinfo_x86’ has no member named ‘compute_unit_id’
 arch/x86/kernel/amd_nb.c:155:36: error: ‘struct cpuinfo_x86’ has no member named ‘compute_unit_id’
 arch/x86/kernel/amd_nb.c: In function ‘amd_get_subcaches’:
 arch/x86/kernel/amd_nb.c:130:1: warning: control reaches end of non-void function

Thanks,

	Ingo
