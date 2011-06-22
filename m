Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758497Ab1FVRx1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 13:53:27 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:16112 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758486Ab1FVRxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 13:53:24 -0400
X-SpamScore: -6
X-BigFish: VS-6(z4b1ekz1432N98dKzz1202hzz8275dhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 22 Jun 2011 12:53:20 -0500
From: Scott Wood <scottwood@freescale.com>
To: Kumar Gala <galak@kernel.crashing.org>
CC: Greg KH <greg@kroah.com>, <linuxppc-dev@ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] powerpc: Dont require a dma_ops struct to set dma
 mask
Message-ID: <20110622125320.79b97a9c@schlenkerla.am.freescale.net>
In-Reply-To: <1308744176-24491-3-git-send-email-galak@kernel.crashing.org>
References: <1308744176-24491-1-git-send-email-galak@kernel.crashing.org>
	<1308744176-24491-2-git-send-email-galak@kernel.crashing.org>
	<1308744176-24491-3-git-send-email-galak@kernel.crashing.org>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jun 2011 07:02:56 -0500
Kumar Gala <galak@kernel.crashing.org> wrote:

> The only reason to require a dma_ops struct is to see if it has
> implemented set_dma_mask.  If not we can fall back to setting the mask
> directly.
> 
> This resolves an issue with how to sequence the setting of a DMA mask
> for platform devices.  Before we had an issue in that we have no way of
> setting the DMA mask before the various low level bus notifiers get
> called that might check it (swiotlb).
> 
> So now we can do:
> 
> 	pdev = platform_device_alloc("foobar", 0);
> 	dma_set_mask(&pdev->dev, DMA_BIT_MASK(37));
> 	platform_device_register(pdev);

Despite what Documentation/driver-model/platform.txt says, it looks like
platform_device_add() is what you want after platform_device_alloc().
Otherwise device_initialize() gets called twice, as would a call to the
archdata hook if one is added to platform_device_register().

-Scott

