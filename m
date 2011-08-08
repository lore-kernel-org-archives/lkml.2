Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251Ab1HHSnp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 14:43:45 -0400
Received: from mail.candelatech.com ([208.74.158.172]:44748 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063Ab1HHSno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 14:43:44 -0400
Message-ID: <4E402E5F.5010600@candelatech.com>
Date: Mon, 08 Aug 2011 11:43:43 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc13 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: 3.0.1 compile error on Fedora 15
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[greearb@t60-ben linux-3.0.p4s]$ make
make -C /home/greearb/git/linux-3.0.dev.y O=/home/greearb/kernel/2.6/linux-3.0.p4s/.
   Using /home/greearb/git/linux-3.0.dev.y as source for kernel
   GEN     /home/greearb/kernel/2.6/linux-3.0.p4s/Makefile
   CHK     include/linux/version.h
   CHK     include/generated/utsrelease.h
   CALL    /home/greearb/git/linux-3.0.dev.y/scripts/checksyscalls.sh
   CHK     include/generated/compile.h
   CC      fs/binfmt_misc.o
In file included from /home/greearb/git/linux-3.0.dev.y/arch/x86/include/asm/uaccess.h:570:0,
                  from /home/greearb/git/linux-3.0.dev.y/include/linux/uaccess.h:5,
                  from /home/greearb/git/linux-3.0.dev.y/include/linux/highmem.h:7,
                  from /home/greearb/git/linux-3.0.dev.y/include/linux/pagemap.h:10,
                  from /home/greearb/git/linux-3.0.dev.y/fs/binfmt_misc.c:26:
/home/greearb/git/linux-3.0.dev.y/arch/x86/include/asm/uaccess_32.h: In function ‘parse_command.part.0’:
/home/greearb/git/linux-3.0.dev.y/arch/x86/include/asm/uaccess_32.h:211:26: error: call to ‘copy_from_user_overflow’ declared with attribute error: 
copy_from_user() buffer size is not provably correct
make[3]: *** [fs/binfmt_misc.o] Error 1
make[2]: *** [fs] Error 2
make[1]: *** [sub-make] Error 2
make: *** [all] Error 2
[greearb@t60-ben linux-3.0.p4s]$


The code in question is below.  Is this missing an assignment to n
in the else branch?

static inline unsigned long __must_check copy_from_user(void *to,
                                           const void __user *from,
                                           unsigned long n)
{
         int sz = __compiletime_object_size(to);

         if (likely(sz == -1 || sz >= n))
                 n = _copy_from_user(to, from, n);
         else
                 copy_from_user_overflow();

         return n;
}


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
