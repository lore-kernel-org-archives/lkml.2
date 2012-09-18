Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795Ab2IRLuo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 07:50:44 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:38096 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932710Ab2IRLun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 07:50:43 -0400
Date: Tue, 18 Sep 2012 20:50:38 +0900
From: Simon Horman <horms@verge.net.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>, Magnus Damm <magnus.damm@gmail.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org
Subject: Re: [PATCH 01/24] ARM: shmobile: use __iomem pointers for MMIO
Message-ID: <20120918115038.GB3198@verge.net.au>
References: <1347658492-11608-1-git-send-email-arnd@arndb.de>
 <1347658492-11608-2-git-send-email-arnd@arndb.de>
 <20120918071131.GB31953@verge.net.au>
 <201209180831.06572.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201209180831.06572.arnd@arndb.de>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 08:31:06AM +0000, Arnd Bergmann wrote:
> On Tuesday 18 September 2012, Simon Horman wrote:
> > On Fri, Sep 14, 2012 at 11:34:29PM +0200, Arnd Bergmann wrote:
> > > ARM is moving to stricter checks on readl/write functions,
> > > so we need to use the correct types everywhere.
> > > 
> > > This patch is a bit ugly for shmobile, which is the only platform
> > > that just uses integer literals all over the place, but I can't
> > > see a better way to do this.
> > > 
> > > Cc: Magnus Damm <magnus.damm@gmail.com>
> > > Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> > > Cc: Simon Horman <horms@verge.net.au>
> > > Cc: Paul Mundt <lethal@linux-sh.org>
> > > Cc: linux-sh@vger.kernel.org
> > > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > 
> > Wow, thats a lot of chrun, but if we must
> > 
> > Acked-by: Simon Horman <horms@verge.net.au>
> > 
> 
> I agree it's not nice to have to do this, but this is largely because
> of shmobile doing things differently from all other ARM platforms, on
> which the respective patches tend to clean up things and reduce the
> number of type casts.
> 
> The only alternative I can see is for shmobile to introduce its own
> mach/io.h file with the relaxed type checking, but that would only
> defer the problem until the point where you want shmobile to be part
> of the common multiplatform kernel binary.

If it is needed in the long term, then I'm happy with it going in now.
Could you remove the portion that Paul objected to?
