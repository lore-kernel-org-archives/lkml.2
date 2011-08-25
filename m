Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab1HYSS2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 14:18:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754474Ab1HYSS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 14:18:26 -0400
Date: Thu, 25 Aug 2011 21:19:12 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Brian King <brking@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Matthew Wilcox <matthew@wil.cx>
Subject: Re: Broken pci_block_user_cfg_access interface
Message-ID: <20110825181912.GB27183@redhat.com>
References: <4E54D5D7.8050807@siemens.com>
 <4E551298.2000302@linux.vnet.ibm.com>
 <4E5613BA.5070101@siemens.com>
 <4E5647DA.1060901@linux.vnet.ibm.com>
 <4E5648B9.7050106@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E5648B9.7050106@siemens.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 03:06:01PM +0200, Jan Kiszka wrote:
> > I took a look at the sysfs triggered pci reset function and don't see any way
> > that the controlling device driver ever gets to be involved in this reset.
> > If code outside the ipr driver were to reset the adapter, the adapter firmware
> > would be left in an uninitialized state and until scsi core starts timing
> > out ops and driving EH, the card would be unusable. I can't imagine the
> > ipr driver is unique in this.
> 
> Right, that's why a PCI core service is needed for coordination.
> 
> Jan

But why do we want to trigger reset through sysfs while the
driver runs?

> -- 
> Siemens AG, Corporate Technology, CT T DE IT 1
> Corporate Competence Center Embedded Linux
