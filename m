Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759058Ab1FARXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 13:23:25 -0400
Received: from smtp-out.google.com ([74.125.121.67]:31759 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756771Ab1FARXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 13:23:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=fuVuReR5/g1+XV2zbf6gJm/VrD+RWpyWWFwmNL0zZoZYe20OYDgqAzOLSJZGJiJoNU
         VedzLWO8Vk1+Kmpphhmg==
Date: Wed, 1 Jun 2011 10:23:15 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Make GFP_DMA allocations w/o ZONE_DMA emit a warning
 instead of failing
In-Reply-To: <BANLkTikrRRzGLbMD47_xJz+xpgftCm1C2A@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1106011017260.13089@chino.kir.corp.google.com>
References: <1306922672-9012-1-git-send-email-dbaryshkov@gmail.com> <BANLkTinBkdVd90g3-uiQP41z1S1sXUdRmQ@mail.gmail.com> <BANLkTikrRRzGLbMD47_xJz+xpgftCm1C2A@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jun 2011, Dmitry Eremin-Solenikov wrote:

> I've hit this with IrDA driver on PXA. Also I've seen the report regarding
> other ARM platform (ep-something). Thus I've included Russell in the cc.
> 

So you want to continue to allow the page allocator to return pages from 
anywhere, even when GFP_DMA is specified, just as though it was lowmem?

Why don't you actually address the problem with the driver you're 
complaining about with the patch below, which I already posted to you a 
few days ago?

If this arm driver is going to be using GFP_DMA unconditionally, it better 
require CONFIG_ZONE_DMA for it to actually be meaningful until such time 
as it can be removed if it's truly not needed or generalized to only 
specific pieces of hardware.
---
 drivers/net/irda/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/irda/Kconfig b/drivers/net/irda/Kconfig
--- a/drivers/net/irda/Kconfig
+++ b/drivers/net/irda/Kconfig
@@ -374,6 +374,7 @@ config VIA_FIR
 config PXA_FICP
 	tristate "Intel PXA2xx Internal FICP"
 	depends on ARCH_PXA && IRDA
+	select ZONE_DMA
 	help
 	  Say Y or M here if you want to build support for the PXA2xx
 	  built-in IRDA interface which can support both SIR and FIR.
