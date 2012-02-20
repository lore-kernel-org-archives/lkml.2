Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469Ab2BTV1Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 16:27:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38106 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753800Ab2BTV1O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 16:27:14 -0500
Subject: Re: Current kernel fails to compile with KVM on PowerPC
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=windows-1252
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <20120220173844.GA2546@alea.gnuu.de>
Date: Mon, 20 Feb 2012 22:27:12 +0100
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm list <kvm@vger.kernel.org>, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <8F6910F4-7F2E-44FE-B0C2-1A2FF95888D2@suse.de>
References: <20111107194838.GA23558@alea.gnuu.de> <20111122200414.GA28205@alea.gnuu.de> <E687C074-57CC-41AD-BA0E-0C957679E900@suse.de> <20120220173844.GA2546@alea.gnuu.de>
To: =?iso-8859-1?Q?J=F6rg_Sommer?= <joerg@alea.gnuu.de>
X-Mailer: Apple Mail (2.1257)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 20.02.2012, at 18:38, Jörg Sommer wrote:

> Hello Alexander,
> 
> Alexander Graf hat am Tue 22. Nov, 22:29 (+0100) geschrieben:
>> On 22.11.2011, at 21:04, Jörg Sommer wrote:
>>> Jörg Sommer hat am Mon 07. Nov, 20:48 (+0100) geschrieben:
>>>> I'm trying to build the kernel with the git commit-id
>>>> 31555213f03bca37d2c02e10946296052f4ecfcd, but it fails
>>>> 
>>>> CHK     include/linux/version.h
>>>> HOSTCC  scripts/mod/modpost.o
>>>> CHK     include/generated/utsrelease.h
>>>> UPD     include/generated/utsrelease.h
>>>> HOSTLD  scripts/mod/modpost
>>>> GEN     include/generated/bounds.h
>>>> CC      arch/powerpc/kernel/asm-offsets.s
>>>> In file included from arch/powerpc/kernel/asm-offsets.c:59:0:
>>>> /home/joerg/git/linux/arch/powerpc/include/asm/kvm_book3s.h: In function ‘compute_tlbie_rb’:
>>>> /home/joerg/git/linux/arch/powerpc/include/asm/kvm_book3s.h:393:10: error: ‘HPTE_V_SECONDARY’ undeclared (first use in this function)
>>>> /home/joerg/git/linux/arch/powerpc/include/asm/kvm_book3s.h:393:10: note: each undeclared identifier is reported only once for each function it appears in
>>>> /home/joerg/git/linux/arch/powerpc/include/asm/kvm_book3s.h:396:12: error: ‘HPTE_V_1TB_SEG’ undeclared (first use in this function)
>>>> /home/joerg/git/linux/arch/powerpc/include/asm/kvm_book3s.h:401:10: error: ‘HPTE_V_LARGE’ undeclared (first use in this function)
>>>> /home/joerg/git/linux/arch/powerpc/include/asm/kvm_book3s.h:415:2: warning: right shift count >= width of type [enabled by default]
>>>> make[3]: *** [arch/powerpc/kernel/asm-offsets.s] Fehler 1
>>>> make[2]: *** [prepare0] Fehler 2
>>>> make[1]: *** [deb-pkg] Fehler 2
>>>> make: *** [deb-pkg] Fehler 2
>>> 
>>> I'm still having this problem. I can' build
>>> 6fe4c6d466e95d31164f14b1ac4aefb51f0f4f82. Are there any patches to
>>> make the kernel builds and do not oops [1] on PowerPC?
>> 
>> The failures above should be fixed by now.
>> 
>>> [1] »kernel BUG at include/linux/kvm_host.h:603!«
>>> http://www.mail-archive.com/kvm@vger.kernel.org/msg61433.html
>> 
>> This is unfortunately still there. It's because of preemption being
>> enabled. Please just use CONFIG_PREEMPT_NONE for the time being
> 
> This doesn't help. I've build with CONFIG_PREEMPT_NONE, but I'm getting
> this Oops, when I start qemu.

Could you please try git://git.kernel.org/pub/scm/virt/kvm/kvm.git? I fixed a bunch of things with preemption since then and it definitely worked for me. If it still fails in that tree, I can try again to reproduce it :).


Alex

