Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab1I1OoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 10:44:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57329 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754503Ab1I1OoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 10:44:19 -0400
Subject: Re: [PATCH v3 07/24] C6X: devicetree support
From: Mark Salter <msalter@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 28 Sep 2011 10:44:10 -0400
In-Reply-To: <201109281531.36792.arnd@arndb.de>
References: <1317155405-26235-1-git-send-email-msalter@redhat.com>
	 <1317155405-26235-8-git-send-email-msalter@redhat.com>
	 <201109281531.36792.arnd@arndb.de>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1317221051.2580.76.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-28 at 15:31 +0200, Arnd Bergmann wrote:
> On Tuesday 27 September 2011, Mark Salter wrote:
> > diff --git a/arch/c6x/boot/install-dtb.c b/arch/c6x/boot/install-dtb.c
> > new file mode 100644
> > index 0000000..fa979ce
> > --- /dev/null
> > +++ b/arch/c6x/boot/install-dtb.c
> > @@ -0,0 +1,333 @@
> > +/*
> > + * Program to hack in a DTB to an ELF file having a placeholder
> > + * section named __fst_blob.
> > + *
> > + * This allows for building multiple images with builtin DTBs
> > + * using a single vmlinux image. This is only necessary until
> > + * bootloader support exists.
> > + *
> > + * Copyright 2011 Texas Instruments Incorporated
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License
> > + * as published by the Free Software Foundation; either version
> > + * 2 of the License, or (at your option) any later version.
> > + *
> > + * Usage: install-dtb <image.dtb> <kernel.elf>
> > + */
> 
> Other architectures allow simply appending the device tree to the
> kernel image file, which is more convenient for users and does
> not require much kernel support. Have you tried this?

Well, I considered it. My main reason for doing it this way was one of
debugging convenience. The debugger loads an ELF file and while I was
making lots of device tree changes in the tree and in the code, it was
more convenient to have one ELF file to deal with rather than an ELF
file and a dtb. And the thought was to get rid of it altogether once
bootloader support comes along. Maybe the thing to do would be to just
rip it out of the kernel. It can almost as easily be post-processing
step outside the kernel.

--Mark


