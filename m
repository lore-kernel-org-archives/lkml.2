Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760138Ab1IKOO3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 10:14:29 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:46321
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754608Ab1IKOO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 10:14:28 -0400
Date: Sun, 11 Sep 2011 10:14:26 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
Cc: Pavel Ivanov <paivanof@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@tuxera.com>
Subject: Re: Kernel 3.1.0-rc4 oops when connecting iPod
Message-ID: <20110911141426.GC23339@infradead.org>
References: <CAG1a4rt5wLihR-ZkUD78WRbHk39xWP0ypJzMe4K5G1O-k12-MQ@mail.gmail.com>
 <1315748768.65310.YahooMailClassic@web29513.mail.ird.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315748768.65310.YahooMailClassic@web29513.mail.ird.yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 11, 2011 at 02:46:08PM +0100, Hin-Tak Leung wrote:
> > +?????* and difference between it
> > and alloc_blksz_shift will be always in
> > +?????* fs_shift.
> > +?????*/
> > +??? err =
> > generic_check_addressable(sb->s_blocksize_bits,
> > +??? ??? ???
> > (u64)sbi->total_blocks << sbi->fs_shift);
> >  ??? if (err) {
> >  ??? ??? printk(KERN_ERR
> > "hfs: filesystem size too large.\n");
> >  ??? ??? goto out_free_vhdr;
> 
> Why is the u64 needed? If it is needed, it probably means sbi->total_blocks should have been u64 in the first place.

No.  When you shift values to the left they obviously become larger.
The total_blocks count on disk 32-bit so there is no need to store
it in a larger variable in the in-core superblock.
