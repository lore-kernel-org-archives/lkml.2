Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531Ab1H2M4G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 08:56:06 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52717 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab1H2M4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 08:56:01 -0400
MIME-Version: 1.0
X-Originating-IP: [93.173.174.182]
In-Reply-To: <20110829122516.GB9730@amd.com>
References: <1314364839-28492-1-git-send-email-joerg.roedel@amd.com>
 <CAK=WgbaiNxo_226Zp9BZpgUjYFajnvgPPCjCOYP2Tj4pkWTwVA@mail.gmail.com>
 <20110829101550.GT1923@amd.com> <CADMYwHwZPiH12HxOP952-Znm_+uMXKpj2M6ew8W-frZ7R8EcWg@mail.gmail.com>
 <20110829122516.GB9730@amd.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 29 Aug 2011 15:55:40 +0300
Message-ID: <CAK=WgbbqCL60uf9gWhLYbkJo44Sva3BwQuZk2R--ER4M+yDV2w@mail.gmail.com>
Subject: Re: [PATCH] iommu: Remove stub functions for !CONFIG_IOMMU_API
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Brown <davidb@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 3:25 PM, Roedel, Joerg <Joerg.Roedel@amd.com> wrote:
> Right, when the system has an iommu then the iommu-api is the right
> choice to do that. But how to you handle this on systems without an
> iommu?

On iommu-less systems this is completely moot, as the remote processor
can access the bus directly, and thus doesn't need any iommu
configuration to take place before it boots.

So in case there is an iommu - we configure it appropriately, and if
there isn't, we just skip that part.
