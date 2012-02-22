Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab2BVGkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 01:40:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48598 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629Ab2BVGkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 01:40:39 -0500
Message-ID: <4F448DBD.6030300@zytor.com>
Date: Tue, 21 Feb 2012 22:39:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Kevin Winchester <kjwinchester@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Randy Dunlap <rdunlap@xenotime.net>,
        Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] x86: Move per cpu cpu_llc_shared_map to a field
 in struct cpuinfo_x86
References: <20120221153935.GE2486@x1.osrc.amd.com> <1329875144-560-1-git-send-email-kjwinchester@gmail.com> <1329875144-560-2-git-send-email-kjwinchester@gmail.com>
In-Reply-To: <1329875144-560-2-git-send-email-kjwinchester@gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2012 05:45 PM, Kevin Winchester wrote:
> Commit 141168c36cde ("x86: Simplify code by removing a !SMP #ifdefs from
> 'struct cpuinfo_x86'") caused the compilation error:
> 
> mce_amd.c:(.cpuinit.text+0x4723): undefined reference to 'cpu_llc_shared_map'
> 
> by removing an #ifdef CONFIG_SMP around a block containing a reference
> to cpu_llc_shared_map.  Rather than replace the #ifdef, move
> cpu_llc_shared_map to be a new cpumask_t field llc_shared_map in
> struct cpuinfo_x86 and adjust all references to cpu_llc_shared_map.
> 

I'm not comfortable with a patch this large after we are already at
-rc4.  Please send a minimal patch to fix the failure for v3.3, and then
a patch on top of that which we can queue up with the rest of the
patchset to for v3.4.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

