Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932837Ab1CWNBj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 09:01:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58075 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932811Ab1CWNBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 09:01:38 -0400
Date: Wed, 23 Mar 2011 09:01:37 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: merging discard request in the block layer
Message-ID: <20110323130137.GA10455@infradead.org>
References: <20110322194755.GA20122@infradead.org>
 <4D88FE5E.1010204@fusionio.com>
 <4D890EBD.1090103@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D890EBD.1090103@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 10:03:57PM +0100, Jens Axboe wrote:
> > That would seem to indicate a bug in the merging logic instead.
> 
> What kind of max discard size does you device have? If the max discard
> size is smaller than the regular request size, this could help.

It's a SCSI device, so the max discard size is a lot larger:

# cat /sys/block/sda/queue/max_sectors_kb
512
# cat /sys/block/sda/queue/max_hw_sectors_kb 
32767
# cat /sys/block/sda/queue/discard_max_bytes 
4294966784

