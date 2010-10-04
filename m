Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891Ab0JDTx0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 15:53:26 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:60488 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919Ab0JDTxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 15:53:25 -0400
X-Originating-Ip: 216.16.235.2
Date: Mon, 4 Oct 2010 15:51:52 -0400
From: Chris Frey <cdfrey@foursquare.net>
To: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, Richard Weinberger <richard@nod.at>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jdike@addtoit.com" <jdike@addtoit.com>,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
        "user-mode-linux-user@lists.sourceforge.net" 
	<user-mode-linux-user@lists.sourceforge.net>,
        "janjaap@bos.nl" <janjaap@bos.nl>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "adobriyan@gmail.com" <adobriyan@gmail.com>,
        "syzop@vulnscan.org" <syzop@vulnscan.org>
Subject: Re: [PATCH 1/1] um: ubd: Fix data corruption
Message-ID: <20101004195152.GA31583@foursquare.net>
References: <1285710456-4435-1-git-send-email-richard@nod.at> <20100928150000.f007f43e.akpm@linux-foundation.org> <201009290013.11332.richard@nod.at> <20100928225202.GA30352@foursquare.net> <4CA275CE.6060401@fusionio.com> <20100929012945.GA3324@foursquare.net> <4CA2CCC3.8010307@fusionio.com> <20100929063452.GA13290@foursquare.net> <4CAA02D0.7040901@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CAA02D0.7040901@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 04, 2010 at 06:37:36PM +0200, Tejun Heo wrote:
> Hello, sorry about chiming in later.  I was off last week.

No problem, I'm eager to test patches to fix this.


> I think we're on the right track.  The problem with Jens' patch was
> that it didn't consider the fact that blk_end_request() now internally
> updates the current position of the request, so if restart happens
> after some of part of the request is complete it will end up adding
> the offsets multiple times.  I think slightly modifying it to track
> the current position instead of offset should do it.  Chris, can you
> please try the following patch and see whether the problem goes away?

Unfortunately, this patch does not fix it for me.  I applied your patch
to kernel 2.6.35.5, and got the usual error:

EXT3-fs error (device ubda): ext3_lookup: deleted inode referenced: 566188

Lots of them, actually.

- Chris

