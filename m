Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab1BAR4L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 12:56:11 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52723 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab1BAR4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 12:56:09 -0500
Date: Tue, 1 Feb 2011 12:56:08 -0500
From: Christoph Hellwig <hch@infradead.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Amerigo Wang <amwang@redhat.com>,
        linux-kernel@vger.kernel.org,
        Stephen Hemminger <shemminger@vyatta.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Jamie Lokier <jamie@shareable.org>, Thomas Weber <swirl@gmx.li>,
        Ben Hutchings <ben@decadent.org.uk>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Andy Fleming <afleming@freescale.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFC Patch] virtio: export model and type in /sys
Message-ID: <20110201175608.GA28913@infradead.org>
References: <1296442381-21652-1-git-send-email-amwang@redhat.com>
 <20110201173738.GA18526@infradead.org>
 <20110201174607.GA24924@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110201174607.GA24924@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 07:46:07PM +0200, Michael S. Tsirkin wrote:
> ide seems to export these too.
> 
> $ cat /sys/class/block/sr0/device/model 
> DVDRAM GSA-U20N 
> 
> and I am pretty sure my dvd isn't scsi ...

And I'm pretty sure it is, not just in one but two different ways.
For one all ATA attached CDROMS are ATAPI, which just means a SCSI
command set (MMC in this case) tunneled over an ATA transport.  Second
libata always is a scsi low level driver, even when talking to ATA
disk, it just responds to the SCSI commands by translating them to
equivalent ATA commands or faking them up.

