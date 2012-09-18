Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599Ab2IRIwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 04:52:12 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:65175 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757531Ab2IRIvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 04:51:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH 01/24] ARM: shmobile: use __iomem pointers for MMIO
Date: Tue, 18 Sep 2012 08:31:06 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>, Magnus Damm <magnus.damm@gmail.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org
References: <1347658492-11608-1-git-send-email-arnd@arndb.de> <1347658492-11608-2-git-send-email-arnd@arndb.de> <20120918071131.GB31953@verge.net.au>
In-Reply-To: <20120918071131.GB31953@verge.net.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209180831.06572.arnd@arndb.de>
X-Provags-ID: V02:K0:juSuJn3nNai9Y5tVGuGMDugAJABAiQG/VZiYTBmxUb4
 9VjlAehHvDYxH6n8e895mYmq6iLZj/lE6kE/XzuoK2h4j02ltH
 nBcqu3y/EFMV9jLnPynBnKcIBvTXl/jLxDyDye4PUVmEWb0rSU
 xQnnHE60qbQ1HxTlT+iCnhI9FlGQnJ+RIIpaPe+Oa+lCFXqrVW
 xx5VOGvdIJNfa2r32YH4DHpG7NcwOYB9yOWq9F8+Gf44pjEXLo
 /ZU8BnWK8amw3xhO3NIAyG3DoUrxtndhw1wMv9dB/gnskAxDts
 2w3hnmvIHM/l4244b2VBbrIwiwgk3+NUFddnAP08zx+dcTmsst
 CwoREGb0Q9j38L077MQQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 September 2012, Simon Horman wrote:
> On Fri, Sep 14, 2012 at 11:34:29PM +0200, Arnd Bergmann wrote:
> > ARM is moving to stricter checks on readl/write functions,
> > so we need to use the correct types everywhere.
> > 
> > This patch is a bit ugly for shmobile, which is the only platform
> > that just uses integer literals all over the place, but I can't
> > see a better way to do this.
> > 
> > Cc: Magnus Damm <magnus.damm@gmail.com>
> > Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> > Cc: Simon Horman <horms@verge.net.au>
> > Cc: Paul Mundt <lethal@linux-sh.org>
> > Cc: linux-sh@vger.kernel.org
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> Wow, thats a lot of chrun, but if we must
> 
> Acked-by: Simon Horman <horms@verge.net.au>
> 

I agree it's not nice to have to do this, but this is largely because
of shmobile doing things differently from all other ARM platforms, on
which the respective patches tend to clean up things and reduce the
number of type casts.

The only alternative I can see is for shmobile to introduce its own
mach/io.h file with the relaxed type checking, but that would only
defer the problem until the point where you want shmobile to be part
of the common multiplatform kernel binary.

	Arnd

