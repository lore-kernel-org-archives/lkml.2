Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769Ab2AROkT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 09:40:19 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:57132 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757736Ab2AROkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 09:40:17 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Ilija Hadzic <ihadzic@research.bell-labs.com>
Subject: Re: [PATCH] dma-buf: Use EXPORT_SYMBOL
Date: Wed, 18 Jan 2012 14:39:59 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc7; KDE/4.3.2; x86_64; ; )
Cc: Dave Airlie <airlied@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Robert Morell <rmorell@nvidia.com>, sumit.semwal@linaro.org
References: <alpine.DEB.2.00.1201061458020.18430@skynet.skynet.ie> <CAPM=9txEgGgbim5Gtz5=Cr5Mf3NrQCx0D=0dQu25gtPTzjSM7Q@mail.gmail.com> <Pine.GSO.4.62.1201180733450.26200@umail>
In-Reply-To: <Pine.GSO.4.62.1201180733450.26200@umail>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201181439.59338.arnd@arndb.de>
X-Provags-ID: V02:K0:+Q9Kr6DAPO49ZchDwFOEvjsjoEW32Y8e+sUHh3w8T31
 rW1U6rjDV/zle4MUCiwTnrvzSST49Jw5/2L0Kj2JswuH39GkCz
 0kARSHns6xrSvDi7ppvD05EYqvcHV1HlR3HbjxyAEek0h0K9zx
 de8AxLl8tCBxctSy04RMOitItTB41zei5SzZk86DMFAtPdBc6k
 3Lm82HprLtkoEeOXpp8BQ8w9H6m+tQKXb+r8xJA6NFoq3loi47
 10WZKzf7zCQ3dByxRA1KDsTGwyRi8oV1C7gq03ITimyBCSvqj5
 4cYVbBxuK+PG+1+4nqt5ZaLss7zK1OgwjJrKWjHE2C8E+lq6/Z
 6z2C4/WcuGfpb4FBOsIY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 January 2012, Ilija Hadzic wrote:
> On Wed, 18 Jan 2012, Dave Airlie wrote:
> 
> >
> > The problem is the x86 nvidia binary driver does sit outside of
> > subsystems, and I forsee wanting to share buffers with it from the
> > Intel driver in light of the optimus hardware. Although nouveau exists
> > and I'd much rather nvidia get behind that wrt the kernel stuff, I
> > don't forsee that happening.
> >

A lot of good stuff is coming out of nvidia these days regarding for
their tegra ARM socs. I wouldn't be surprised to see them in the same
boat as Intel and AMD regarding their support for free drivers in
the near future and I think it's worth supporting the people inside
of nvidia that are fighting for that instead of the others that are
against it.

Having more interesting features in nouveau that are not in the
proprietary driver would probably help on that front, too.

> Frankly, I never understood this "low-level interface" argument that is 
> kicked around when EXPORT_SYMBOL_GPL topic is brought up. My view to 
> EXPORT_SYMBOL vs. EXPORT_SYMBOL_GPL is that it really boils down to 
> license controversy about binary/proprietary modules in Linux kernel. To 
> me it's about whether the authors of certain code (for mostly 
> phylosophical reasons) agree that their (GPL) code is OK or not OK to link 
> against non-GPL module.

The controversy is about whether a module is a derived work of the kernel
when you link it in. Traditionally, some modules were not considered
derived works by a lot of people arguing that we have a public module
interface that acts as a barrier for the license in the same way that
the syscall interface lets you run proprietary applications.

The EXPORT_SYMBOL_GPL is all about symbols that are too low-level
to be considered part of that public module API (assuming that this
API exists). The argument is that symbols which are not meant to be
used in third-party modules can never be a license barrier and
anything using them is a derived work even if you consider other
modules not to be a derived work of the kernel. Note that this
argument can still hold for low-level symbols that are marked as
EXPORT_SYMBOL, using EXPORT_SYMBOL_GPL just makes it explicit.

	Arnd
