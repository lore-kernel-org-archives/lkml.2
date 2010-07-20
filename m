Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab0GTKcF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 06:32:05 -0400
Received: from norkia.v3.sk ([91.210.183.14]:57873 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150Ab0GTKcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 06:32:03 -0400
Subject: Re: [PATCH 2/3] [fs/sysv] V7: Adjust sanity checks for some volumes
From: Lubomir Rintel <lkundrak@v3.sk>
To: Christoph Hellwig <hch@lst.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20100719145457.GC25279@lst.de>
References: <1279559802-19154-1-git-send-email-lkundrak@v3.sk>
	 <1279559802-19154-2-git-send-email-lkundrak@v3.sk>
	 <1279559802-19154-3-git-send-email-lkundrak@v3.sk>
	 <20100719145457.GC25279@lst.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Jul 2010 12:31:33 +0200
Message-ID: <1279621893.18203.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-07-19 at 16:54 +0200, Christoph Hellwig wrote:

> >  	v7i = (struct sysv_inode *)(bh2->b_data + 64);
> >  	if ((fs16_to_cpu(sbi, v7i->i_mode) & ~0777) != S_IFDIR ||
> >  	    (fs32_to_cpu(sbi, v7i->i_size) == 0) ||
> > -	    (fs32_to_cpu(sbi, v7i->i_size) & 017) != 0)
> > +	    (fs32_to_cpu(sbi, v7i->i_size) & 017)
> > +	    (fs32_to_cpu(sbi, v7i->i_size) > V7_NFILES *
> > +	     sizeof (struct sysv_dir_entry))) {
> 
> Maybe I'm missing something, but without and additional || on the
> first line you added this doesn't look like it will compile.

You're right. In fact this hunk is fixed in a commit that followed it, I
probably incorrectly merged the fixups in git (the latter commit also
had an useless comment change and such).

I'll follow up with a fixed commit tomorrow, since I'm unable to test it
now.

Thanks,
Lubo

-- 
Flash is the Web2.0 version of blink and animated gifs.
                                     -- Stephen Smoogen

