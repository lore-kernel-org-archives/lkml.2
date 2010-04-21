Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab0DUGDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 02:03:11 -0400
Received: from mail-pz0-f186.google.com ([209.85.222.186]:53392 "EHLO
	mail-pz0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab0DUGDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 02:03:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=xsoTMvowVoxKc3+npIsyZGMyIdFiyZny6MOdrD/6Y2P9iSSFWpUnr6KwmFajJ9DAxN
         b8gWzzHMJHLwha7GRwW1/wzfM/7ezVIUuFY9XeTifIGGuS1y5BK3tORyZINLM22wSIox
         S+ZB+GnJLoEOEuKGEO7o1XdULYvBn5nulFa94=
Date: Wed, 21 Apr 2010 14:06:51 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Jeff Dike <jdike@addtoit.com>, Amerigo Wang <xiyou.wangcong@gmail.com>,
       trivial@kernel.org, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 3/5] uml: Fix warning due to missing task_struct
 declaration
Message-ID: <20100421060651.GB4467@cr0.nay.redhat.com>
References: <cover.1271713955.git.jan.kiszka@web.de>
 <1d97cd7761a1eae73923b1adda4c6915a0647bb3.1271713955.git.jan.kiszka@web.de>
 <20100420100949.GB5317@cr0.nay.redhat.com>
 <20100420143016.GB30011@c-98-229-117-200.hsd1.ma.comcast.net>
 <4BCDDFBB.40805@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4BCDDFBB.40805@web.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 07:09:15PM +0200, Jan Kiszka wrote:
>Jeff Dike wrote:
>> On Tue, Apr 20, 2010 at 06:09:49PM +0800, Amerigo Wang wrote:
>>> On Mon, Apr 19, 2010 at 11:53:06PM +0200, Jan Kiszka wrote:
>>>> We can't pull in linux/sched.h, so just declare the struct.
>>>>
>>> Did you meet any build error? If yes, please include it.
>> 
>> What does this patch fix, aside from being a bit cleaner?
>
>  CC      arch/um/sys-i386/elfcore.o
>In file included from /data/linux-2.6/include/linux/elf.h:8,
>                 from /data/linux-2.6/arch/um/sys-i386/elfcore.c:2:
>/data/linux-2.6/arch/um/sys-i386/asm/elf.h:78: warning: ‘struct task_struct’ declared inside parameter list
>/data/linux-2.6/arch/um/sys-i386/asm/elf.h:78: warning: its scope is only this definition or declaration, which is probably not what you want
>
>I guess not many people build against i386 hosts anymore, so this
>remained widely unnoticed.
>
>> 
>> If it built before, without having a task_struct declaration, I think
>> that means that the elf_core_copy_fpregs was never used.  The
>> task_struct * in the declaration would become a private task_struct,
>> known only to the declaration.  If the implementation or callers have
>> the regular task_struct, it will be a different one, and the
>> prototypes will conflict due to the different types of the first
>> parameter.
>
>This is just a forward declaration (that many arch elf header include),
>so no such problem exists.
>
>BTW, to answer the other question in this thread: We have a circular
>dependency that prevents including sched.h.
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This is the right reason to do this. Ok then, thanks.

But it looks like x86_64 needs this too.


BTW, I don't think compile warning fixes are trivial enough to go
to trivial@kernel.org.
