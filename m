Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935739Ab2JYOIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 10:08:09 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:52464 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757110Ab2JYOIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 10:08:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Bonn <jonas@southpole.se>
Subject: Re: [PATCH] asm-generic/io.h: remove asm/cacheflush.h include
Date: Thu, 25 Oct 2012 14:07:26 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: James Hogan <james.hogan@imgtec.com>, linux-arch@vger.kernel.org,
        linux@openrisc.net, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-xtensa@linux-xtensa.org,
        Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Chen Liqin <liqin.chen@sunplusct.com>, Lennox Wu <lennox.wu@gmail.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>
References: <1350984117-17369-1-git-send-email-james.hogan@imgtec.com> <1351172416.6232.70.camel@jerome.southpole.se>
In-Reply-To: <1351172416.6232.70.camel@jerome.southpole.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201210251407.27145.arnd@arndb.de>
X-Provags-ID: V02:K0:QqnfVtKQBVyx/9W4ifzQcoj4xwans4LQdNB3h20jTu/
 uH+oNLlQS70Y7dYPV4GBnQekQwAkaT5JpvIny3HM4zqNvl4RUV
 NDZLcQzhVcBGr0bEI4s/Kr5OFb3g1V/tWCDErdZfGLzNBmnxVz
 TbI+b+eziCgtPIi59jKh9HesOcvcLE8xakWFDgsrGUx8N6ztTj
 cBiO0ctLYOvvkOEyQaSi/edr0WUKcHmVqprPnhcs4uSC6YY+kt
 z8EyUZe+P/dVlyS8wpJ3xKFSlRsnq6wpyXSn343ivQbwEZRRTF
 b12B5Du1b4RBOcM919tdV2BEGymus3YaemZ4oQpqfyCFLy1/Rk
 tSM54QbHk8OWwRAgb1rw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 October 2012, Jonas Bonn wrote:
> On Tue, 2012-10-23 at 10:21 +0100, James Hogan wrote:
> > Including <asm/cacheflush.h> from <asm-generic/io.h> prevents
> > cacheflush.h being able to use I/O functions like readl and writel due
> > to circular include dependencies. It doesn't appear as if anything from
> > cacheflush.h is actually used by the generic io.h, so remove the
> > include.
> > 
> > I've compile tested a defconfig compilation of blackfin, openrisc (which
> > needed <asm/pgtable.h> including from it's <asm/io.h> to get the PAGE_*
> > definitions), and xtensa.
> > 
> > Other architectures which use asm-generic/io.h are score and unicore32,
> > and looking at their io.h I don't see any obvious problems.
> 
> Acked-by: Jonas Bonn <jonas@southpole.se> for OpenRISC
> 
> Who's tree should this go via.  I can take it via the openrisc tree, but
> it would be good to get some Ack's that this isn't going to break things
> for the other arch's (in particular score and unicore32, since they are
> untested).

I've put it into the asm-generic tree, now that I have set it up again
for the 3.7 merge window.

	Arnd
