Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757087Ab0HDJTh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 05:19:37 -0400
Received: from web27008.mail.ukl.yahoo.com ([217.146.177.8]:47406 "HELO
	web27008.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756207Ab0HDJTe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 05:19:34 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Aug 2010 05:19:34 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=KaIr1XKBwHVIjQm5/DegFsPUelXvYQsnbe/n2GIyuopAy7LKWtXS5OFkpbaQXdF7SYIo6lGmTzZEf3FXXD1oRNZORzMiIgCJIfEMZiFlXhiBH7q6cY9IUxRpgsgHWWCdGV4z5kmEeJmQGHa6Y4htrbggL+Td4GJyvwdf+V7R3ek=;
Message-ID: <646233.80914.qm@web27008.mail.ukl.yahoo.com>
X-YMail-OSG: GCV8IrYVM1mqnVPIGanTCHdWbw6abt5jrsdQ7T9JbMSnBUc
 XrnBWOq6a3axjHTEcdg6xEzoQjA2NKVUCwt2hm.uRak7e7vyBtv_17qrObMa
 xkfrF75paVbwiEq7Lk_DR_Ij61UVAsuTqwCUnSYEUWLo3hJwP7HzL8luYSqb
 jQfp6AT6y9tBoZHx.k.zXqznnCo46u1EueZWRJKIhs6MB8PfjnrN0pA.7R7j
 JrG_cste0fdeQy267LR715qWQdP8TewWU7FwPHb9A1JwkmpCk4VyKOexIkCT
 h7070U2vlUuxkD_NqC0U8ngA2b2E0vZI1DshPbOg-
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Wed, 4 Aug 2010 09:12:52 +0000 (GMT)
From: bifferos <bifferos@yahoo.co.uk>
Subject: Re: [tip:x86/cpu] x86, cpu: RDC doesn't have CPUID, which is what c_ident is
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        florian@openwrt.org, mark@bifferos.com, tglx@linutronix.de,
        hpa@linux.intel.com, Ingo Molnar <mingo@elte.hu>
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <20100803192557.GA13595@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I couldn't reproduce this with 2.6.35 (without Peter's change),
I was trying on VirtualBox.  If the detection code is causing a 
problem we can just skip it if the CPU has cpuid.

Incidentally if you need some hardware to test the RDC port on I can
arrange that.

regards,
Mark

--- On Tue, 3/8/10, Ingo Molnar <mingo@elte.hu> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Subject: Re: [tip:x86/cpu] x86, cpu: RDC doesn't have CPUID, which is what c_ident is
> To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org, florian@openwrt.org, mark@bifferos.com, tglx@linutronix.de, hpa@linux.intel.com
> Cc: linux-tip-commits@vger.kernel.org
> Date: Tuesday, 3 August, 2010, 20:25
> 
> * tip-bot for H. Peter Anvin <hpa@linux.intel.com>
> wrote:
> 
> > Commit-ID: 
> c0366f5f5c1615c4f70b1bd646149ba9233830b9
> > Gitweb:     http://git.kernel.org/tip/c0366f5f5c1615c4f70b1bd646149ba9233830b9
> > Author:     H. Peter Anvin <hpa@linux.intel.com>
> > AuthorDate: Tue, 3 Aug 2010 10:09:56 -0700
> > Committer:  H. Peter Anvin <hpa@linux.intel.com>
> > CommitDate: Tue, 3 Aug 2010 10:09:56 -0700
> > 
> > x86, cpu: RDC doesn't have CPUID, which is what
> c_ident is
> > 
> > c_ident is supposed to be a CPUID identifier, and RDC
> doesn't have
> > that.
> 
> -tip testing found that these RDC patches cause a boot
> crash if a 
> X86_RDC321X=y kernel is booted on a regular PC:
> 
> [    0.015999] Pid: 0, comm: swapper Not tainted
> 2.6.35-tip+ #23896 A8N-E/System Product Name 
>    
> [    0.015999] EIP: 0060:[<c1267d14>]
> EFLAGS: 00010282 CPU: 0         
>                
>            
> [    0.015999] EIP is at strcmp+0xf/0x22 
>                
>                
>                
>         
> [    0.015999] EAX: c1a81541 EBX: 00000004 ECX:
> 0000000f EDX: 00000000         
>                
>   
> [    0.015999] ESI: c1a81571 EDI: 00000000 EBP:
> c19ccf78 ESP: c19ccf70         
>                
>   
> [    0.015999]  DS: 007b ES: 007b FS: 00d8
> GS: 00e0 SS: 0068           
>                
>           
> [    0.015999] Process swapper (pid: 0,
> ti=c19cc000 task=c1a07e60 task.ti=c19cc000)   
>            
> [    0.015999] Stack:       
>                
>                
>                
>                
>      
> [    0.015999]  c1a81530 c1a81570 c19ccf8c
> c16d9b7f c1ac8538 c1a81530 c1a81570 c19ccfac   
>        
> [    0.015999] <0> c16d9dcb c104dc9f
> c1a15210 c1a81548 c1ac8538 00099800 c19ce000 c19ccfb4 
>       
> [    0.015999] <0> c1a89a4f c19ccfc0
> c1a89d2d c1a96147 c19ccfe0 c1a84953 431d9715 00000006 
>       
> [    0.015999] Call Trace:     
>                
>                
>                
>                
>   
> [    0.015999]  [<c16d9b7f>] ?
> get_cpu_vendor+0x22/0x8f         
>                
>              
>    
> [    0.015999]  [<c16d9dcb>] ?
> identify_cpu+0xc5/0x2e0         
>                
>                
>   
> [    0.015999]  [<c104dc9f>] ?
> sub_preempt_count+0x9/0x39         
>                
>            
>    
> [    0.015999]  [<c1a89a4f>] ?
> identify_boot_cpu+0xd/0x23         
>                
>            
>    
> [    0.015999]  [<c1a89d2d>] ?
> check_bugs+0xb/0xaf           
>                
>                
>     
> [    0.015999]  [<c1a96147>] ?
> cpuset_init+0x65/0x77         
>                
>                
>     
> [    0.015999]  [<c1a84953>] ?
> start_kernel+0x37e/0x392         
>                
>              
>    
> [    0.015999]  [<c1a840c9>] ?
> i386_start_kernel+0xc9/0xd0       
>                
>                 
> [    0.015999] Code: c0 83 c9 ff f2 ae 4f 89 d1
> 49 78 06 ac aa 84 c0 75 f7 31 c0 aa 89 d8 5b 5e 5 
> [    0.015999] EIP: [<c1267d14>]
> strcmp+0xf/0x22 SS:ESP 0068:c19ccf70     
>                
>        
> 
> mercury:~> cat /proc/cpuinfo 
> processor    : 0
> vendor_id    : AuthenticAMD
> cpu family    : 15
> model        : 35
> model name    : AMD Athlon(tm) 64 X2 Dual
> Core Processor 3800+
> stepping    : 2
> cpu MHz        : 2010.301
> cache size    : 512 KB
> physical id    : 0
> siblings    : 2
> core id        : 0
> cpu cores    : 2
> fpu        : yes
> fpu_exception    : yes
> cpuid level    : 1
> wp        : yes
> flags        : fpu vme de pse
> tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36
> clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt lm
> 3dnowext 3dnow rep_good pni lahf_lm cmp_legacy
> bogomips    : 4021.85
> TLB size    : 1024 4K pages
> clflush size    : 64
> cache_alignment    : 64
> address sizes    : 40 bits physical, 48 bits
> virtual
> power management: ts fid vid ttp
> 
> config attached.
> 
> Thanks,
> 
>     Ingo
> 


      
