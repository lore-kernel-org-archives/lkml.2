Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117Ab1FVO0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 10:26:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54579 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582Ab1FVO0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 10:26:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH 14/19] OpenRISC: Module support
Date: Wed, 22 Jun 2011 16:26:11 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Jonas Bonn <jonas@southpole.se>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
References: <1308483825-6023-1-git-send-email-jonas@southpole.se> <1308483825-6023-15-git-send-email-jonas@southpole.se> <31626.1308686616@turing-police.cc.vt.edu>
In-Reply-To: <31626.1308686616@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106221626.12023.arnd@arndb.de>
X-Provags-ID: V02:K0:M4I5uEjDp4pXOB4AvqIeE0AOc/NPbWexyA0ItXbxDcm
 37RtYr5u23spehNXPXoTkYJs2oJP/Q2pHs9La9MudfH9PCyd9S
 i8xEKAuYjlFfxRkRLF0ue4fvnFoZyj4Bfwif4Xb4pgLNdKvrb7
 7wsRgjN/8R8yGBgc9z9VHmeYybCTz7Jt88WLP7rRxw2g9SE1Q5
 MaeCnh0EP/dqNwgXrOt8A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 June 2011, Valdis.Kletnieks@vt.edu wrote:
> On Sun, 19 Jun 2011 13:43:40 +0200, Jonas Bonn said:

> > diff --git a/arch/openrisc/kernel/module.c b/arch/openrisc/kernel/module.c
> > new file mode 100644
> > index 0000000..952b129
> > --- /dev/null
> > +++ b/arch/openrisc/kernel/module.c
> > @@ -0,0 +1,126 @@
> > +/*
> > + * OpenRISC module.c
> 
> Lose the filenames in the headers - you do this in multiple files.

Good point.
 
> Also, do you even *need* a module.c? There isn't much in here, will the main
> kernel/module.c do the work needed?  Or did you end up with one because the
> arch you cloned had one?

Right now you need a module.c in each architecture defining all these
functions. However, I think it would be cool if we didn't need this
all of them. In case of openrisc, the architecture should only have
to define a apply_relocate_add() function.

Jonas, could you add a default implementation for each of the functions
for include/linux/moduleloader.h, so that you only have to provide the
one function?

I think that an easy way to do that would be to add to kernel/module.c
code like:

#ifndef module_alloc
void *module_alloc(unsigned long size)
{
	return vmalloc(size);
}
#endif

Then each architecture that needs a special version can do
#define module_alloc(size) module_alloc(size)
in their respective asm/module.h

	Arnd
