Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965Ab1FXKFl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 06:05:41 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:50828 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140Ab1FXKFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 06:05:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Bonn <jonas@southpole.se>
Subject: Re: [PATCH 14/19] OpenRISC: Module support
Date: Fri, 24 Jun 2011 12:05:31 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
References: <1308483825-6023-1-git-send-email-jonas@southpole.se> <201106221626.12023.arnd@arndb.de> <1308905525.6699.23.camel@localhost>
In-Reply-To: <1308905525.6699.23.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106241205.32037.arnd@arndb.de>
X-Provags-ID: V02:K0:DXE0tmyVxCx4NU+kLCFK6mrFKHqNyUXUkmfqD558iJ+
 DlM2021iz5smGCsYN/cw6HhZU6YdwhpFqi5Pzfj8yAJ/mlEvmT
 UhpR3OHAi5k65m2C87r/rtx0b4Af9HJ76snTBzX289hcyRsX2r
 hno03HepF546SXYPkdMW9Qw2pHY2ttyaBmAXio4lJF+Vx7GgNE
 Qu3wpy7Y7HRBhGnbX/ziQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 June 2011, Jonas Bonn wrote:
> On Wed, 2011-06-22 at 16:26 +0200, Arnd Bergmann wrote:
> > I think that an easy way to do that would be to add to kernel/module.c
> > code like:
> > 
> > #ifndef module_alloc
> > void *module_alloc(unsigned long size)
> > {
> >       return vmalloc(size);
> > }
> > #endif
> > 
> 
> I noticed that kernel/module.c already has this:
> 
> unsigned int __weak arch_mod_section_prepend(struct module *mod,
>                                              unsigned int section)
> 
>
> Is using a __weak attribute on the default (generic) implementations a
> better approach?

I normally don't like using __weak, because it more easily confuses
readers about which version is actually used.

> > Then each architecture that needs a special version can do
> > #define module_alloc(size) module_alloc(size)
> > in their respective asm/module.h
> 
> With the __weak variant this wouldn't be necessary...

Correct. I certainly wouldn't want to see both methods mixed in the
same file. Rusty is maintaining the module loader, maybe he has
a preference.

Rusty, we were discussing the fact that most module loader files
are providing very similar (mostly empty) functions, and that it would
be nice if the new openrisc architecture would only have to provide
apply_relocate_add(), which is actually arch specific, while it could
be changed to use the defaults for everything else.

	Arnd
