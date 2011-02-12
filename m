Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960Ab1BLHRX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 02:17:23 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42030 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab1BLHRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 02:17:17 -0500
Date: Sat, 12 Feb 2011 02:17:11 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Cong Wang <amwang@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        Stephen Hemminger <shemminger@vyatta.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Jamie Lokier <jamie@shareable.org>, Thomas Weber <swirl@gmx.li>,
        Ben Hutchings <ben@decadent.org.uk>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Andy Fleming <afleming@freescale.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFC Patch] virtio: export model and type in /sys
Message-ID: <20110212071711.GB18475@infradead.org>
References: <1296442381-21652-1-git-send-email-amwang@redhat.com>
 <20110201173738.GA18526@infradead.org>
 <4D4B9CE3.7080505@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D4B9CE3.7080505@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 04, 2011 at 02:29:55PM +0800, Cong Wang wrote:
> >It does not make any sense to fill this at all in virtio.  The
> >attributes are simply exporting the SCSI INQUIRY data, and do not make
> >any sense at all outside a SCSI context.  In fact the type field even
> >contains numbers from the scsi protocol spec that just don't make sense.
> >
> 
> Hmm, so other non-SCSI devices don't have these neither?
> Do you have any suggestions to find another way to identify a disk?

Many modern disks have uuid strings identifying them, e.g. virtio-blk
has a serial attribute for it.  For SCSI and ATA they are retreived
by issuing the commands to get them through the pass through ioctls
right now, but I'd love to see the serial sysfs attribute implemented
there as well.

