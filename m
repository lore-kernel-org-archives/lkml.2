Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725Ab0KVEdf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 23:33:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34234 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756575Ab0KVEde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 23:33:34 -0500
MIME-Version: 1.0
In-Reply-To: <20101121181655.4996cdde.randy.dunlap@oracle.com>
References: <AANLkTi=Di4UQMYyJ_wpZ6N=NZt1+3EeXL7FUsBX004YL@mail.gmail.com> <20101121181655.4996cdde.randy.dunlap@oracle.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 21 Nov 2010 20:33:07 -0800
Message-ID: <AANLkTi=4scuTeRyr1WuGbzk2jKdU_Ugu61ABoXPuXnVK@mail.gmail.com>
Subject: Re: Linux 2.6.37-rc3 (fixmap build error)
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 21, 2010 at 6:16 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>
> I thought that I saw a patch for this one, but I can't find it now.
>
> on i386:
> arch/x86/built-in.o: In function `fix_to_virt':
> /usr/builds/linux-2.6.37-rc3/arch/x86/include/asm/fixmap.h:207: undefined reference to `__this_fixmap_does_not_exist'

Hmm. Does it help to mark __set_fixmap_offset() as "__always_inline"
rather than just "inline"?

Every single "fix_to_virt()" user _should_ use a constant index and
that thing should be inlined and the __this_fixmap_does_not_exist case
should be trivially optimized away.

But if __set_fixmap_offset() doesn't get inlined...

                Linus
