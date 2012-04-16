Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693Ab2DPHoL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 03:44:11 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:51020 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab2DPHoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 03:44:10 -0400
Date: Mon, 16 Apr 2012 09:43:55 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Lubos Lunak <l.lunak@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RESEND] do not redefine userspace's NULL #define
Message-ID: <20120416094355.53309edb@de.ibm.com>
In-Reply-To: <201204132102.14873.arnd@arndb.de>
References: <201204132124.21294.l.lunak@suse.cz>
	<CA+55aFxCrVtwCd9bjHLt82Uwisp8OtKP9c+raPYMqCTXqVfxGw@mail.gmail.com>
	<201204132102.14873.arnd@arndb.de>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12041607-5024-0000-0000-00000244863D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2012 21:02:14 +0000
Arnd Bergmann <arnd@arndb.de> wrote:

> On Friday 13 April 2012, Linus Torvalds wrote:
> > There's no way user should ever include the linux internal stddef.h.
> > 
> > And quite frankly, kernel-external definitions of NULL have
> > traditionally been pure sh*t (ie plain "0" without the cast to a
> > pointer), so I'm not entirely convinced about this patch.
> > 
> > So what is the actual thing this helps with?
> 
> I think it used to get included implictly though other exported
> kernel headers, but I found only one instance where this is still
> true, in the s390 version of asm/ptrace.h.
> 
> Martin, does this work for you?
> 
> 8<-----
> headers: do not export linux/stddef.h
> 
> There is no reason to export linux/stddef.h and users should never
> include it because the header conflicts with the standard stddef.h.
> 
> The only other exported header file that actually includes linux/stddef.h
> is the s390 asm/ptrace.h, but there is no reason for it to do so, so
> we can remove both the export and the inclusion.
> When the file is no longer exported, we can also remove the extra lines
> that attempt to make it safe for inclusion
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Kernel compiles and boots. After protecting the stddef.h #include in
include/linux/posix_types.h with #ifdef __KERNEL__ gdb and strace
could be build as well.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

