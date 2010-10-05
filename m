Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568Ab0JEJXX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 05:23:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:58500 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932314Ab0JEJXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 05:23:22 -0400
Message-ID: <4CAAEF08.2090101@kernel.org>
Date: Tue, 05 Oct 2010 11:25:28 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Build failure on CONFIG_DEBUG_FORCE_WEAK_PER_CPU?
References: <874od1w1ao.fsf@gmail.com>
In-Reply-To: <874od1w1ao.fsf@gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 05 Oct 2010 09:23:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2010 09:23 AM, Namhyung Kim wrote:
> The following message is a courtesy copy of an article
> that has been posted to gmane.linux.kernel as well.
> 
> Hello,
> 
> When I tried to build 2.6.36-rc6 on x86_64 allyesconfig,
> I got following messages and the build was broken:
> 
>   LD      vmlinux.o
>   MODPOST vmlinux.o
>   GEN     .version
>   CHK     include/generated/compile.h
>   UPD     include/generated/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> ld: arch/x86/kernel/init_task.o:(.debug_info+0xeee): error: undefined reference to '__pcpu_scope_init_tss'
> ld: arch/x86/kernel/init_task.o:(.debug_info+0x1558): error: undefined reference to '__pcpu_unique_init_tss'
> ld: arch/x86/built-in.o:(.debug_info+0x2bed2): error: undefined reference to '__pcpu_unique_shared_msrs'
> ld: arch/x86/built-in.o:(.debug_info+0x2c037): error: undefined reference to '__pcpu_unique_cpu_tsc_khz'
> ld: arch/x86/built-in.o:(.debug_info+0x2c0ab): error: undefined reference to '__pcpu_unique_current_vcpu'
> ld: arch/x86/built-in.o:(.debug_info+0x5801a): error: undefined reference to '__pcpu_unique_vmxarea'
> ld: arch/x86/built-in.o:(.debug_info+0x58046): error: undefined reference to '__pcpu_unique_current_vmcs'
> ld: arch/x86/built-in.o:(.debug_info+0x58072): error: undefined reference to '__pcpu_unique_vcpus_on_cpu'
> ld: arch/x86/built-in.o:(.debug_info+0x5809e): error: undefined reference to '__pcpu_unique_host_gdt'
> ld: arch/x86/built-in.o:(.debug_info+0x6086f): error: undefined reference to '__pcpu_unique_svm_data'
> ld: arch/x86/built-in.o:(.debug_info+0x659ff): error: undefined reference to '__pcpu_scope_xen_vcpu'
> ld: arch/x86/built-in.o:(.debug_info+0x65a41): error: undefined reference to '__pcpu_scope_xen_vcpu_info'
> ld: arch/x86/built-in.o:(.debug_info+0x65b2c): error: undefined reference to '__pcpu_unique_xen_vcpu'
> ld: arch/x86/built-in.o:(.debug_info+0x65b42): error: undefined reference to '__pcpu_unique_xen_vcpu_info'
> ld: arch/x86/built-in.o:(.debug_info+0x65b96): error: undefined reference to '__pcpu_unique_idt_desc'
> ... (snipped)
> make[2]: *** [.tmp_vmlinux1] Error 1
> make[1]: *** [sub-make] Error 2
> make: *** [all] Error 2
> 
> After reading comments on CONFIG_DEBUG_FORCE_WEAK_PER_CPU, I am
> not sure whether it is intended or not. I think it's not, but
> I can't find any report about this though the change was made
> last year by 7c756e6e19e71f0327760d8955f7077118ebb2b1. Or Am I
> missing something?
> 
> Anyway, the breakage was due to conflict between
> CONFIG_DEBUG_FORCE_WEAK_PER_CPU and CONFIG_DEBUG_INFO. I think a
> kconfig dependency has to be set between them something like:

Weird, I just did an allyesconfig build (sans CONFIG_GCOV_KERNEL for
parallel build) and it worked just fine.  Which toolchain versions are
you using?  Can you create a minimal .config which reproduces the
build failure?

Thanks.

-- 
tejun
