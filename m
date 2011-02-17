Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab1BQMst (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 07:48:49 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43965 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682Ab1BQMsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 07:48:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=W1Qi1qc3lzt2EFPVfMbn4ZIt4ijb73MeFS+kNm3GM/b735fecR0s6kvP8CDIZnB7dp
         ybFNQefLvjXdh/FMycHOAO/TneM46NaybeaCMfHcoM4DVDxliTUrcVlRdqO6LQpLPVW/
         KzuWg7G2Tl0+467EISvSRVbbyIcrv6Q9F0v34=
Date: Thu, 17 Feb 2011 13:48:38 +0100
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, hpa@linux.intel.com, ankita@in.ibm.com
Subject: Re: [boot crash] Re: [PATCHSET x86/numa] x86-64, NUMA: bring
 sanity to NUMA config/emulation
Message-ID: <20110217124838.GT19830@htj.dyndns.org>
References: <1297858867-25981-1-git-send-email-tj@kernel.org>
 <20110216125249.GA18113@elte.hu>
 <20110216141757.GG19830@htj.dyndns.org>
 <20110216155314.GA22855@elte.hu>
 <20110216162329.GI19830@htj.dyndns.org>
 <20110216172954.GA28054@elte.hu>
 <20110217123511.GA26685@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110217123511.GA26685@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 01:35:11PM +0100, Ingo Molnar wrote:
> 
> FYI, -tip testing has found the follow boot crash:
> 
> [    0.000000] init_memory_mapping: 0000000000000000-000000003fff0000
> [    0.000000]  0000000000 - 003fff0000 page 4k
> [    0.000000] kernel direct mapping tables up to 3fff0000 @ 3fdee000-3fff0000
> PANIC: early exception 06 rip 10:ffffffff8102f069 error 0 cr2 f06f53
> [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.38-rc5-tip+ #94135
> [    0.000000] Call Trace:
> [    0.000000]  [<ffffffff8199019e>] ? early_idt_handler+0x5e/0x71
> [    0.000000]  [<ffffffff8102f069>] ? __phys_addr+0x69/0x70
> [    0.000000]  [<ffffffff8102f009>] ? __phys_addr+0x9/0x70
> [    0.000000]  [<ffffffff819a0156>] ? initmem_init+0xf0/0xa0d
> [    0.000000]  [<ffffffff819a4cc2>] ? parse_crashkernel+0x40/0x2a1
> [    0.000000]  [<ffffffff810303e0>] ? dummy_numa_init+0x0/0x70
> [    0.000000]  [<ffffffff810284a9>] ? is_vsmp_box+0x9/0x50
> [    0.000000]  [<ffffffff81992f4a>] ? setup_arch+0x9f9/0xaec
> [    0.000000]  [<ffffffff813c585c>] ? printk+0x41/0x45
> [    0.000000]  [<ffffffff81990999>] ? start_kernel+0x9d/0x3b5
> [    0.000000]  [<ffffffff8199032b>] ? x86_64_start_reservations+0x132/0x136
> [    0.000000]  [<ffffffff8199047d>] ? x86_64_start_kernel+0x14e/0x15d
> 
> Full crashlog attached below, config attached as well.
> 
> Testbox is a standard dual-core Athlon64 whitebox PC, with no particular 
> weirdnesses. The box boots fine with x86/mm removed from tip:master.
> 
> I've excluded x86/mm from tip:master for the time being. This was with the 
> e23bba604433 x86/mm tree.

Does the following patch from Yinghai fix the problem?

 http://thread.gmane.org/gmane.linux.kernel/1101528/focus=1101598

Thanks.

-- 
tejun
