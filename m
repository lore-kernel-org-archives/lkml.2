Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759432Ab1CDNtN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 08:49:13 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41847 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758521Ab1CDNtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 08:49:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SRMMfXQmi1jcncJKjzlwGObalp/4QKEmra7xoWZ1GhbdA71vlcRKu/CU0RK8tCUa/i
         neHcgvqcnQL63hHo2SwQbsbbCCwnM1IaOtPDg/Wk0Y/juE6pFIsqv76X74mwxZJ6T9gK
         tvQziilvas7Y2BD4AhvBC4ViPZiYoKmhY0ZBg=
Date: Fri, 4 Mar 2011 14:47:36 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH for.38] x86, numa: Fix numa_emulation code with node0
 without RAM
Message-ID: <20110304134736.GN20499@htj.dyndns.org>
References: <4D6ECF72.5010308@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6ECF72.5010308@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 03:14:58PM -0800, Yinghai Lu wrote:
> 
> On one system that does not have RAM on node0.
> 
> when numa_emulation is compiled in, and
> 1. boot system without numa=fake...
> 2. or boot system with numa=fake=128 to make emulation fail
> 
> will get:
> 
> [    0.076025] ------------[ cut here ]------------
> [    0.080004] kernel BUG at arch/x86/mm/numa_64.c:788!
> [    0.080004] invalid opcode: 0000 [#1] SMP 
> [    0.080004] last sysfs file: 
> [    0.080004] CPU 0 
> [    0.080004] Modules linked in:
> [    0.080004] 
> [    0.080004] Pid: 0, comm: swapper Not tainted 2.6.38-rc6-yh-00212-g3e1f235 #1 Sun Microsystems     Sun Fire X4240/Sun Fire X4240
> [    0.080004] RIP: 0010:[<ffffffff81cd1d8c>]  [<ffffffff81cd1d8c>] numa_add_cpu+0x8a/0x156
> ...
> [    0.080004] Call Trace:
> [    0.080004]  [<ffffffff81ccd1cd>] identify_cpu+0x2d7/0x2df
> [    0.080004]  [<ffffffff827e13e9>] identify_boot_cpu+0x10/0x30
> [    0.080004]  [<ffffffff827e15f3>] check_bugs+0x9/0x2d
> [    0.080004]  [<ffffffff827d9bcb>] start_kernel+0x3bf/0x3d9
> [    0.080004]  [<ffffffff827d92a6>] x86_64_start_reservations+0xb6/0xba
> [    0.080004]  [<ffffffff827d93a1>] x86_64_start_kernel+0xf7/0xfe
> [    0.080004] Code: 74 06 48 8d 04 90 eb 0f 48 c7 c0 10 d9 00 00 48 03 04 d5 50 e1 5f 82 8b 00 83 f8 ff 74 0d 0f a3 05 7a f9 92 00 19 d2 85 d2 75 02 <0f> 0b 48 98 31 db 48 8b 04 c5 d0 ec 5f 82 48 8b 90 90 af 00 00 
> 
> need to used early_cpu_to_node directly, because cpu_to_apicid and apicid_to_node
>  will return node0 that is not onlined.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
