Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab1FBXJB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 19:09:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16090 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755131Ab1FBXI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 19:08:58 -0400
Message-ID: <4DE817CC.80404@redhat.com>
Date: Thu, 02 Jun 2011 19:07:56 -0400
From: Eric Paris <eparis@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>
CC: Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, monstr@monstr.eu, ralf@linux-mips.org,
        benh@kernel.crashing.org, paulus@samba.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, linux390@de.ibm.com, lethal@linux-sh.org,
        davem@davemloft.net, jdike@addtoit.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        viro@zeniv.linux.org.uk, oleg@redhat.com, akpm@linux-foundation.org,
        linux-ia64@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au,
        linux-mips@linux-mips.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        sparclinux@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH] Audit: push audit success and retcode into arch ptrace.h
References: <20110602210458.23613.24076.stgit@paris.rdu.redhat.com>	<201106030032.17398.richard@nod.at> <BANLkTik9kCs_06=7HKo44cWqpS0zB9fr+A@mail.gmail.com>
In-Reply-To: <BANLkTik9kCs_06=7HKo44cWqpS0zB9fr+A@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2011 07:00 PM, Tony Luck wrote:
>> But there seems to be another problem.
>> Why is pt_regs of type void *?
>>
>> gcc complains:
>> In file included from include/linux/fsnotify.h:15:0,
>>                 from include/linux/security.h:26,
>>                 from init/main.c:32:
>> include/linux/audit.h: In function ‘audit_syscall_exit’:
>> include/linux/audit.h:440:17: warning: dereferencing ‘void *’ pointer
>> include/linux/audit.h:440:3: error: invalid use of void expression
>> include/linux/audit.h:441:21: warning: dereferencing ‘void *’ pointer
>> include/linux/audit.h:441:21: error: void value not ignored as it ought to be
> 
> Perhaps same issue on ia64 - but symptoms are different:
> 
>   CC      crypto/cipher.o
> In file included from include/linux/fsnotify.h:15,
>                  from include/linux/security.h:26,
>                  from init/do_mounts.c:8:
> include/linux/audit.h: In function ‘audit_syscall_exit’:
> include/linux/audit.h:440: warning: dereferencing ‘void *’ pointer
> include/linux/audit.h:440: error: request for member ‘r10’ in
> something not a structure or union
> include/linux/audit.h:441: error: request for member ‘r10’ in
> something not a structure or union
> include/linux/audit.h:441: error: request for member ‘r8’ in something
> not a structure or union
> include/linux/audit.h:441: error: request for member ‘r8’ in something
> not a structure or union
> include/linux/audit.h:441: error: expected ‘;’ before ‘}’ token
> include/linux/audit.h:441: error: void value not ignored as it ought to be

I think it is the same problem.  I'll redo the patch with typed static
inlines instead of #defines and all of this should hopefully work out.

-Eric
