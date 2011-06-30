Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840Ab1F3NKU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 09:10:20 -0400
Received: from adelie.canonical.com ([91.189.90.139]:50997 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab1F3NKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 09:10:16 -0400
Date: Thu, 30 Jun 2011 14:10:12 +0100
From: Seth Forshee <seth.forshee@canonical.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Anton Salikhmetov <alexo@tuxera.com>, linux-kernel@vger.kernel.org
Subject: Re: hfsplus mount regression in 2.6.38
Message-ID: <20110630131012.GA19309@thinkpad-t410>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Anton Salikhmetov <alexo@tuxera.com>, linux-kernel@vger.kernel.org
References: <20110525142521.GA32511@thinkpad-t410>
 <20110527092522.GA11600@infradead.org>
 <20110527132356.GA13908@thinkpad-t410>
 <20110527182406.GB13908@thinkpad-t410>
 <20110602215821.GA13099@thinkpad-t410>
 <20110630113520.GA6744@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110630113520.GA6744@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 07:35:20AM -0400, Christoph Hellwig wrote:
> On Thu, Jun 02, 2011 at 04:58:21PM -0500, Seth Forshee wrote:
> > I took a crack at converting the users of direct bio to use
> > bdev_logical_block_size instead of HFSPLUS_SECTOR_SIZE. sb->s_blocksize
> > doesn't turn out to work because it may change after reading the
> > volume header. The patch is below; feedback is appreciated.
> > 
> > So far I've only done light testing, and no testing with large-sector
> > devices since I don't have any to test with. I'm still concerned about
> > duplicating data also in the page cache with this approach. Any thoughts
> > on whether or not this is something to be worried about?
> 
> Did you manage to test it on a large sector device?

I've gotten some test results back, but the results are mixed. I haven't
had much time yet to try to find out what's going wrong, but I hope to
do so soon.

> I'm be rather surprised if we actually need the read modify write
> cycles.  I've not seen any filesystem that doesn't align it's metadata
> to the sector size yet.

I agree. What I was more concerned about was that if you had e.g. a 2 KB
sector device, metadata could possibly end up in the filesystem cache
along with some file data in an adjacent block, and that as a result you
could overwrite that data structure with stale data.
