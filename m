Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab1HVViv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 17:38:51 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:45921 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668Ab1HVVir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 17:38:47 -0400
Message-ID: <4E52CC63.5070201@nod.at>
Date: Mon, 22 Aug 2011 23:38:43 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: x86@kernel.org, rostedt@goodmis.org, jbaron@redhat.com,
        akpm@linux-foundation.org, rusty@rustcorp.com.au, vapier@gentoo.org,
        user-mode-linux-devel@lists.sourceforge.net
Subject: [RFC] UML/x86_64 module loader
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

UserModeLinux is using the arch specific module functions from 
arch/x86/kernel/module.c.
On i386 this works perfectly fine but on x86_64 it causes problems.

apply_relocate_add() assumes modules compiled with -mcmodel=kernel 
because the kernel lives in the negative 2GiB of the address space.
This assumption is not true for UML.
On an UML instance with more than 512MiB of memory no modules can be 
loaded because vmalloc() locates the module near the 2GiB limit and the
ELF relocations causes an overflow. (Detected by "if ((s64)val != *(s32 
*)loc)" in apply_relocate_add()).

Now I'm not sure how to fix this.
Mostly because I'm not a module loader nor an ELF expert. 8-)

Is there an easy way to adjust the current x86_64 module loader to deal 
with UML "positive" relocations?

Thanks,
//richard

P.s: Just removing the overflow-check does not fix the problem. ;-)
