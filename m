Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818Ab1EAUrx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 16:47:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47458 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755360Ab1EAUrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 16:47:52 -0400
Date: Sun, 1 May 2011 16:47:48 -0400
From: Christoph Hellwig <hch@infradead.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: Greg KH <greg@kroah.com>, Christoph Hellwig <hch@infradead.org>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: Re: [PATCH 00/25] Staging: hv: Cleanup vmbus driver code
Message-ID: <20110501204748.GB1017@infradead.org>
References: <1303834785-4981-1-git-send-email-kys@microsoft.com>
 <20110426232843.GA31184@kroah.com>
 <6E21E5352C11B742B20C142EB499E0481DD185@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110427064550.GA597@infradead.org>
 <6E21E5352C11B742B20C142EB499E0481DD266@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110427121856.GA20633@infradead.org>
 <6E21E5352C11B742B20C142EB499E0481DD676@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110501153920.GA15210@infradead.org>
 <20110501154751.GA14040@kroah.com>
 <6E21E5352C11B742B20C142EB499E0481DF2C9@TK5EX14MBXC124.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481DF2C9@TK5EX14MBXC124.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 01, 2011 at 06:56:58PM +0000, KY Srinivasan wrote:
> > Yeah, it seems to me that no matter how the user specifies the disk
> > "type" for the guest configuration, we should use the same Linux driver,
> > with the same naming scheme for both ways.
> > 
> > As Christoph points out, it's just a matter of hooking the device up to
> > the scsi subsystem.  We do that today for ide, usb, scsi, and loads of
> > other types of devices all with the common goal of making it easier for
> > userspace to handle the devices in a standard manner.
> 
> This is not what is being done in Xen and KVM - they both have a PV front-end
> block drivers that is not managed by the scsi stack. The Hyper-V block driver is
> equivalent to what we have in Xen and KVM in this respect.

Xen also has a PV SCSI driver, although that isn't used very much.
For virtio we think it was a mistake to not speak SCSI these days,
and ponder introducing a virtio-scsi to replace virtio-blk.

But that's not the point here at all.  The point is that blockvsc
speaks a SCSI protocol over the wire, so it should be implemented
as a SCSI LLDD unless you have a good reason not to do it.  This
is especially important to get advanced features like block level
cache flush and FUA support, device topology, discard support, for
free.  Cache flush and FUA are good example for something that blkvsc
currently gets wrong, btw.

