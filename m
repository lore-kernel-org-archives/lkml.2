Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab0KGVbb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 16:31:31 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58709 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991Ab0KGVb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 16:31:29 -0500
From: Andi Kleen <andi@firstfloor.org>
To: Jim <jim876@xs4all.nl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, gcc@gcc.gnu.org
Subject: Re: gcc 4.5.1 / as 2.20.51.0.11 miscompiling  drivers/char/i8k.c ?
References: <4CD538CA.8010901@xs4all.nl>
Date: Sun, 07 Nov 2010 22:31:24 +0100
In-Reply-To: <4CD538CA.8010901@xs4all.nl> (Jim's message of "Sat, 06 Nov 2010
	12:15:22 +0100")
Message-ID: <87wroostw3.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jim <jim876@xs4all.nl> writes:

> After upgrading my Dell laptop, both OS+kernel the i8k interface was giving
> nonsensical output. As it turned out it's not the kernel but compiler
> upgrade which broke this.
>
> Guys at Archlinux have found the underlying cause (but don't seem to have
> submitted a patch yet):
>   https://bbs.archlinux.org/viewtopic.php?pid=780692#p780692
> gcc seems to optimize the assembly statements away.
>
> And indeed, applying this patch makes the i8k interface work again,
> i.e. replacing the asm(..) construct by  asm volatile(..)

The compiler really should not optimize the asm away, because
it has both input and output arguments which are later used.
"asm volatile" normally just means "don't move significantly"

I tested it with gcc version 4.5.0 20100604 [gcc-4_5-branch revision
160292] (SUSE Linux) 
and the asm statement is there for both 32bit and 64bit
(with an allmodconfig, with both -O2 and -Os)

If gcc 4.5.1 broke that over 4.5.0 you should really file a bug report
for the compiler, it seems like a serious regression in 4.5.1

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
