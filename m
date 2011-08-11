Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab1HKWqi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 18:46:38 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:58930
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753490Ab1HKWqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 18:46:37 -0400
Date: Thu, 11 Aug 2011 18:46:29 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "Asai Thambi Samymuthu Pattrayasamy (asamymuthupa) [CONTRACTOR]" 
	<asamymuthupa@micron.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Moyer <jmoyer@redhat.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Garzik <jgarzik@pobox.com>, Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH v3 1/3] drivers/block/mtip32xx: Adding header file and
 source for pci and block related operation
Message-ID: <20110811224629.GA10182@infradead.org>
References: <22A973199D2C2F46933448F6E7990A3002C80025@ntxboimbx31.micron.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22A973199D2C2F46933448F6E7990A3002C80025@ntxboimbx31.micron.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 12:52:43PM -0600, Asai Thambi Samymuthu Pattrayasamy (asamymuthupa) [CONTRACTOR] wrote:
> This is the first part of the new block driver,mtip32xx, for Micron
> PCIe SSD, which contains the header file and source for pci and
> block related operations.

There should be not split between pci/block and hardware related
functions, as there is no logical split either.  Please remove that
layering and merge the files into one.  Also given that the hardware
really just is AHCI with extensions please use the constants from
include/linux/ata.h and drivers/ata/ahci.h instead of redefining them.
The latter might need to be move to include/linux before merging the
driver for that, but for the next iteration a hacky relative include
might be enough.

Also please get rid of the MTIP_USE_TASKLET, if it really is worth it
it needs to be seletable at runtime.

I can't see any point of the CONFIG_PCI_MSI ifdefs - all the functions
called under it are properly stubbed out if it's not enabled.

