Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab1F3NMq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 09:12:46 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:33998
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751963Ab1F3NMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 09:12:41 -0400
Date: Thu, 30 Jun 2011 09:12:38 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Christoph Hellwig <hch@infradead.org>,
        Anton Salikhmetov <alexo@tuxera.com>, linux-kernel@vger.kernel.org
Subject: Re: hfsplus mount regression in 2.6.38
Message-ID: <20110630131238.GA9478@infradead.org>
References: <20110525142521.GA32511@thinkpad-t410>
 <20110527092522.GA11600@infradead.org>
 <20110527132356.GA13908@thinkpad-t410>
 <20110527182406.GB13908@thinkpad-t410>
 <20110602215821.GA13099@thinkpad-t410>
 <20110630113520.GA6744@infradead.org>
 <20110630131012.GA19309@thinkpad-t410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110630131012.GA19309@thinkpad-t410>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 02:10:12PM +0100, Seth Forshee wrote:
> > I'm be rather surprised if we actually need the read modify write
> > cycles.  I've not seen any filesystem that doesn't align it's metadata
> > to the sector size yet.
> 
> I agree. What I was more concerned about was that if you had e.g. a 2 KB
> sector device, metadata could possibly end up in the filesystem cache
> along with some file data in an adjacent block, and that as a result you
> could overwrite that data structure with stale data.

Given that all other metadata in hfsplus is part of an inode with it's
own address space we would have done that already before.
