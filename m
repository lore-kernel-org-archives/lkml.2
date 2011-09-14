Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230Ab1INRm4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 13:42:56 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:55668
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757104Ab1INRmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 13:42:55 -0400
Date: Wed, 14 Sep 2011 13:42:50 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Ivanov <paivanof@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Hin-Tak Leung <hintak_leung@yahoo.co.uk>,
        linux-fsdevel@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@tuxera.com>
Subject: Re: Kernel 3.1.0-rc4 oops when connecting iPod
Message-ID: <20110914174250.GA30240@infradead.org>
References: <CAG1a4ruG8bL9j01RgSXuK2w9FV0izp8vdoQMLEZzc=qZfCNpzA@mail.gmail.com>
 <1315285921.46647.YahooMailClassic@web29519.mail.ird.yahoo.com>
 <CAG1a4rttHKgp=nAjQ=7zUu=bURq9x7DdhL2fTAZKimicpfdYsw@mail.gmail.com>
 <CAG1a4rt5wLihR-ZkUD78WRbHk39xWP0ypJzMe4K5G1O-k12-MQ@mail.gmail.com>
 <20110912143452.GA31539@infradead.org>
 <CAG1a4rsuYVehnSCM3KxeYQ+g94nrivG1vfss=y8275E4D24qTg@mail.gmail.com>
 <20110912153129.GA10625@infradead.org>
 <CAG1a4rsKQexL8vhAAoJDtnEvqH0rDvPQCiBGM74EH-+pZ9+WPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG1a4rsKQexL8vhAAoJDtnEvqH0rDvPQCiBGM74EH-+pZ9+WPg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 12, 2011 at 10:20:01PM -0400, Pavel Ivanov wrote:
> This patch works for me.
> 
> And could you comment on my PAGE_SIZE question?
> 
> >> Also I have a little concern about consistency in using
> >> PAGE_CACHE_SHIFT and PAGE_SHIFT. hfsplus_read_wrapper() limits visible
> >> block size to PAGE_SIZE, not PAGE_CACHE_SIZE. And although now they
> >> are equal comment in linux/pagemap.h clearly says that PAGE_CACHE_SIZE
> >> can be bigger than PAGE_SIZE. Is it something that should be fixed in
> >> hfsplus_read_wrapper() ?

The two are and always have been the same.  There were plans to allow
for a larger PAGE_CACHE_SIZE long time ago, but it never happened.

I'll switch everything to PAGE_SIZE in the patch for consistency.
