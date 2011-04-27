Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758951Ab1D0MTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 08:19:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42804 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756202Ab1D0MS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 08:18:59 -0400
Date: Wed, 27 Apr 2011 08:18:56 -0400
From: Christoph Hellwig <hch@infradead.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: Christoph Hellwig <hch@infradead.org>, Greg KH <greg@kroah.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: Re: [PATCH 00/25] Staging: hv: Cleanup vmbus driver code
Message-ID: <20110427121856.GA20633@infradead.org>
References: <1303834785-4981-1-git-send-email-kys@microsoft.com>
 <20110426232843.GA31184@kroah.com>
 <6E21E5352C11B742B20C142EB499E0481DD185@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110427064550.GA597@infradead.org>
 <6E21E5352C11B742B20C142EB499E0481DD266@TK5EX14MBXC124.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481DD266@TK5EX14MBXC124.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 11:47:03AM +0000, KY Srinivasan wrote:
> On the host side, Windows emulates the  standard PC hardware
> to permit hosting of fully virtualized operating systems.
> To enhance disk I/O performance, we support a virtual block driver.
> This block driver currently handles disks that have been setup as IDE
> disks for the guest - as specified in the guest configuration.
> 
> On the SCSI side, we emulate a SCSI HBA. Devices configured
> under the SCSI controller for the guest are handled via this
> emulated HBA (SCSI front-end). So, SCSI disks configured for
> the guest are handled through native SCSI upper-level drivers.
> If this SCSI front-end driver is not loaded, currently, the guest
> cannot see devices that have been configured as SCSI devices.
> So, while the virtual block driver described earlier could potentially
> handle all block devices, the implementation choices made on the host
> will not permit it. Also, the only SCSI device that can be currently configured
> for the guest is a disk device.
> 
> Both the block device driver (hv_blkvsc) and the SCSI front-end
> driver (hv_storvsc) communicate with the host via unique channels 
> that are implemented as bi-directional ring buffers. Each (storage) 
> channel carries with it enough state to uniquely identify the device on
> the host side. Microsoft has chosen to use SCSI verbs for this storage channel 
> communication. 

This doesn't really explain much at all.  The only important piece
of information I can read from this statement is that both blkvsc
and storvsc only support disks, but not any other kind of device,
and that chosing either one is an arbitrary seletin when setting up
a VM configuration.

But this still isn't an excuse to implement a block layer driver for
a SCSI protocol, and it doesn't not explain in what way the two
protocols actually differ.  You really should implement blksvs as a SCSI
LLDD, too - and from the looks of it it doesn't even have to be a
separate one, but just adding the ids to storvsc would do the work.
