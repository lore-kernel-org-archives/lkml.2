Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab2D2Xhm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 19:37:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55644 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754532Ab2D2Xhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 19:37:41 -0400
Message-ID: <4F9DD0A2.7010104@zytor.com>
Date: Sun, 29 Apr 2012 16:37:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Kevin Winchester <kjwinchester@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Randy Dunlap <rdunlap@xenotime.net>,
        Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 1/5] x86: Move per cpu cpu_llc_shared_map to a field
 in struct cpuinfo_x86
References: <1a0aaa16-df06-40bf-88c7-28180455e6b9@email.android.com> <1335742410-11569-1-git-send-email-kjwinchester@gmail.com> <1335742410-11569-2-git-send-email-kjwinchester@gmail.com>
In-Reply-To: <1335742410-11569-2-git-send-email-kjwinchester@gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2012 04:33 PM, Kevin Winchester wrote:
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

Okay...  I must not get this.

Why is this better than just moving the DEFINE_PER_CPU to a place which
isn't dependent on SMP?

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

