Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935930Ab1JGIvh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 04:51:37 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48694 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759610Ab1JGIvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 04:51:36 -0400
Date: Fri, 7 Oct 2011 09:51:14 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Subject: Re: [PATCH 13/26] ARM: pxa: use correct __iomem annotations
Message-ID: <20111007085114.GE21464@n2100.arm.linux.org.uk>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de> <1317499438-14058-14-git-send-email-arnd@arndb.de> <CAMPhdO_CGvoc8GZQS3TWpv0gqOXhmHyEbamcQr28K5iLgOBnuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMPhdO_CGvoc8GZQS3TWpv0gqOXhmHyEbamcQr28K5iLgOBnuw@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 07, 2011 at 04:11:01PM +0800, Eric Miao wrote:
> To be honest, I'd really like to keep the *_VIRT_BASE definitions to be
> type independent.
> 
> And have the actual register definitions to be casted to void __iomem *
> when being defined, e.g.
> 
> #define APBC_REG(x)	IOMEM(APBC_VIRT_BASE + (x))
> 
> #define APBC_UART1	APBC_REG(0x000)
> 
> Arnd, do we have some standard guidelines on this for all SoCs
> to follow? As I know, it's currently still being a mess.

It makes much more sense for the base address to be correctly typed (even
though it does mean a cast in the map_desc tables).  It avoids type
problems if someone does readl(APBC_VIRT_BASE + reg) somewhere, and
also avoids type problems should someone decide to pass the base address
around.
