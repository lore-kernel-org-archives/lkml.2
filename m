Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404Ab2ARKW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 05:22:26 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:54053 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756306Ab2ARKWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 05:22:23 -0500
Date: Wed, 18 Jan 2012 11:22:14 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-kernel@vger.kernel.org
cc: linux-sh@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        "Shimoda, Yoshihiro" <yoshihiro.shimoda.uh@renesas.com>,
        linux-mmc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-serial@vger.kernel.org
Subject: [PATCH 0/7] extract a simple dmaengine library from shdma.c
Message-ID: <Pine.LNX.4.64.1201181025280.28782@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:7z7gTRuwLLxxNIVOZUjcN7DbKUCUuT+Z60oMCZL1nTq
 o/rxRtds1+ir6j/eHBrtneAFKz6pl1iDpod2PpugnJ5tlx6HQg
 VicwP4VdsAVQXFoaKMJ38gTHyHS8E5a55nI4PMh5X30AzbE/UX
 IWAg/D561hxJY97gDWBdis/GI88a6SepYZKXQcwwarhcLGhiNs
 jDzMedBicYipKvqMusfykF2SJ6IM5wymzUdhfvy4nZRLwSy4nw
 QxmrZNW71zyIW+qICGUntKIyOFH3XMnh9DgK4J/YbisHzIv+Us
 GkOoK3VUM5GZ1vXDehh0wYb4WXbrGPWY8iIh2A0kQoBrgDy5Mo
 3sf+GOs57goUhIfvlwGMO55djan4wuINgUrUVSfR8Fhy5Yqv53
 G03Wd1+Lhx6IQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series has been triggered by a recent series by Shimoda-san
http://www.spinics.net/lists/linux-sh/index.html#09895
In a follow up to that thread it has been decided to extract a common 
library from the current shdma driver to be re-used by other dmaengine 
drivers. Primarily this library provides a flexible transfer descriptor 
management for hardware, that does not dupport scatter-gather lists 
natively. In such cases this library can be used to split transfer 
requests into smaller chunks, up to the size, supported by the specific 
hardware, enter them onto a linked list, thack their completion and call 
user callbacks. This is a first shot, aimed to be used by the SUDMAC 
driver. Once it is confirmed, that this version can be conveniently used 
with it, I'll do some cosmetic clean up, notably, add / improve 
documentation:-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

