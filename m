Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120Ab1I3Ndd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 09:33:33 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:35890
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754333Ab1I3Ndb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 09:33:31 -0400
Date: Fri, 30 Sep 2011 09:33:23 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        "Asai Thambi Samymuthu Pattrayasamy (asamymuthupa) [CONTRACTOR]" 
	<asamymuthupa@micron.com>
Subject: Re: [PATCH v4] drivers/block/mtip32xx: Adding new driver mtip32xx
Message-ID: <20110930133323.GA2730@infradead.org>
References: <22A973199D2C2F46933448F6E7990A3002C80026@ntxboimbx31.micron.com>
 <4E44E782.7090309@fusionio.com>
 <2A9BE4FF6209B644B6F8EB62DE6AEA1E07663ED4@ntxfrembx01.micron.com>
 <20110909085433.GA9593@infradead.org>
 <4E69D519.8070802@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E69D519.8070802@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 09, 2011 at 10:58:01AM +0200, Jens Axboe wrote:
> >  - handling of REQ_FUA / REQ_FLUSH requests is completely broken.
> >    There is a weird barrier flag to mtip_hw_submit_io which set the
> >    hwardware FUA bit if the FLUSH bit is set on a request.
> >    Please take a look at how this should be handled, the
> >    Documentation/block/writeback_cache_control.txt file is the canonical
> >    resource.  Implementing your driver at the make_request layer
> >    unfortunately means you will have to do all the hard work yourself.
> 
> I noticed both of these flush/fua problems too and have fixed them up.

I sitll can't find anything doing that in your tree while all kinds of
other patches are in.  In fact I can't find a place that sends
ATA_CMD_FLUSH/ATA_CMD_FLUSH_EXT commands, not the required queue
draining for it.

And this stuff really makes me nervous - we get a driver for a new,
expensive high end device and there seems absolutely no concern for
data integrity, or testing of it.

Or does the device not even have a volatile cache at all, and we could
just remove the FUA code?  In this case it should be clearly documented
in the driver.
