Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498Ab2HNO1X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 10:27:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655Ab2HNO1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 10:27:19 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <87a9xys53h.fsf@rustcorp.com.au>
References: <87a9xys53h.fsf@rustcorp.com.au> <20120726150419.0de645e8750e3a15fa0f1aaa@canb.auug.org.au> <50115FCF.4060708@xenotime.net> <502932A0.3060001@xenotime.net>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: dhowells@redhat.com, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: linux-next: Tree for July 26 (uml)
Date: Tue, 14 Aug 2012 15:26:53 +0100
Message-ID: <15532.1344954413@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Rusty Russell <rusty@rustcorp.com.au> wrote:

> > >   CC      arch/x86/um/../kernel/module.o
> > > arch/x86/um/../kernel/module.c:96:5: error: redefinition of 'apply_relocate_add'
> > > include/linux/moduleloader.h:64:19: note: previous definition of 'apply_relocate_add' was here
> > > make[2]: *** [arch/x86/um/../kernel/module.o] Error 1

Hmmm...  I'm not sure how to deal with this.  The problem is that UML doesn't
draw the:

	select MODULES_USE_ELF_REL if X86_32
	select MODULES_USE_ELF_RELA if X86_64

definitions from arch/foo/Kconfig that tell it what modules will look like.

Should I just enable both REL and RELA in UML, or is there a better way to do
this?

David
