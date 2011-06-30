Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904Ab1F3Lf3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 07:35:29 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:40808
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750917Ab1F3LfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 07:35:22 -0400
Date: Thu, 30 Jun 2011 07:35:20 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Christoph Hellwig <hch@infradead.org>,
        Anton Salikhmetov <alexo@tuxera.com>, linux-kernel@vger.kernel.org
Subject: Re: hfsplus mount regression in 2.6.38
Message-ID: <20110630113520.GA6744@infradead.org>
References: <20110525142521.GA32511@thinkpad-t410>
 <20110527092522.GA11600@infradead.org>
 <20110527132356.GA13908@thinkpad-t410>
 <20110527182406.GB13908@thinkpad-t410>
 <20110602215821.GA13099@thinkpad-t410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110602215821.GA13099@thinkpad-t410>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 02, 2011 at 04:58:21PM -0500, Seth Forshee wrote:
> I took a crack at converting the users of direct bio to use
> bdev_logical_block_size instead of HFSPLUS_SECTOR_SIZE. sb->s_blocksize
> doesn't turn out to work because it may change after reading the
> volume header. The patch is below; feedback is appreciated.
> 
> So far I've only done light testing, and no testing with large-sector
> devices since I don't have any to test with. I'm still concerned about
> duplicating data also in the page cache with this approach. Any thoughts
> on whether or not this is something to be worried about?

Did you manage to test it on a large sector device?

I'm be rather surprised if we actually need the read modify write
cycles.  I've not seen any filesystem that doesn't align it's metadata
to the sector size yet.

