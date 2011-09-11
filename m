Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760123Ab1IKOMh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 10:12:37 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:44554
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754608Ab1IKOMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 10:12:36 -0400
Date: Sun, 11 Sep 2011 10:12:34 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Ivanov <paivanof@gmail.com>
Cc: Hin-Tak Leung <hintak_leung@yahoo.co.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@tuxera.com>
Subject: Re: Kernel 3.1.0-rc4 oops when connecting iPod
Message-ID: <20110911141234.GB23339@infradead.org>
References: <CAG1a4ruG8bL9j01RgSXuK2w9FV0izp8vdoQMLEZzc=qZfCNpzA@mail.gmail.com>
 <1315285921.46647.YahooMailClassic@web29519.mail.ird.yahoo.com>
 <CAG1a4rttHKgp=nAjQ=7zUu=bURq9x7DdhL2fTAZKimicpfdYsw@mail.gmail.com>
 <CAG1a4rt5wLihR-ZkUD78WRbHk39xWP0ypJzMe4K5G1O-k12-MQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG1a4rt5wLihR-ZkUD78WRbHk39xWP0ypJzMe4K5G1O-k12-MQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 10, 2011 at 11:52:55PM -0400, Pavel Ivanov wrote:
> > Agreed. It was more of a quick hack to prove the correctness of such
> > change direction. I'll think how to do it better.
> 
> Hin-Tak,
> 
> How about the following patch?
> 
> 
> Subject: [PATCH] hfsplus: Allow to mount filesystem with block size
> greater than PAGE_SIZE
> 
> Commit c6d5f5fa (hfsplus: lift the 2TB size limit) added call to
> generic_check_addressable() but used the system's internal block size
> which can be larger than PAGE_SIZE and will cause
> generic_check_addressable() to return -EINVAL in this case. This
> results in impossibility to mount file systems with such block sizes.
> To fix it we have to use block size understandable by
> generic_check_addressable() and adjust number of blocks accordingly.

Given that a large part of the checks are related to the actual
block size I think that we're better off just opencoding it.

