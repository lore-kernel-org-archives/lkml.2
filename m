Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab1BARhq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 12:37:46 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52784 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab1BARhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 12:37:45 -0500
Date: Tue, 1 Feb 2011 12:37:38 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Stephen Hemminger <shemminger@vyatta.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Jamie Lokier <jamie@shareable.org>, Thomas Weber <swirl@gmx.li>,
        Ben Hutchings <ben@decadent.org.uk>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Andy Fleming <afleming@freescale.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFC Patch] virtio: export model and type in /sys
Message-ID: <20110201173738.GA18526@infradead.org>
References: <1296442381-21652-1-git-send-email-amwang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296442381-21652-1-git-send-email-amwang@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 10:53:00AM +0800, Amerigo Wang wrote:
> Our kdump script needs /sys/block/X/device/{vendor, model, type},
> but virtio devices don't have {model, type}, this patch adds them.
> Actually, I don't know how to fill the model field, other block devices
> seem read it from SCSI. Any comments?

It does not make any sense to fill this at all in virtio.  The
attributes are simply exporting the SCSI INQUIRY data, and do not make
any sense at all outside a SCSI context.  In fact the type field even
contains numbers from the scsi protocol spec that just don't make sense.

