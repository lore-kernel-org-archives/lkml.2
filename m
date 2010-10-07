Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab0JGUZe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 16:25:34 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:49279 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286Ab0JGUZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 16:25:33 -0400
X-Originating-Ip: 216.16.235.2
Date: Thu, 7 Oct 2010 16:23:39 -0400
From: Chris Frey <cdfrey@foursquare.net>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Tejun Heo <htejun@gmail.com>, Richard Weinberger <richard@nod.at>,
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
Message-ID: <20101007202339.GA8338@foursquare.net>
References: <20100928225202.GA30352@foursquare.net> <4CA275CE.6060401@fusionio.com> <20100929012945.GA3324@foursquare.net> <4CA2CCC3.8010307@fusionio.com> <20100929063452.GA13290@foursquare.net> <4CAA02D0.7040901@gmail.com> <20101004195152.GA31583@foursquare.net> <4CAAE077.9010500@gmail.com> <20101005203137.GA594@foursquare.net> <4CAD7D98.7080808@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CAD7D98.7080808@fusionio.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 07, 2010 at 09:58:16AM +0200, Jens Axboe wrote:
> So how about this? Note that I haven't even compiled this. The request
> handling logic really should be fixed in there, it's horribly
> inefficient.

Thanks.  I fixed the compile error with:

> +	.rq_offset		0, \

to

> +	.rq_offset =		0, \

But after testing, I still got the same errors:

EXT3-fs error (device ubda): ext3_lookup: deleted inode referenced: 964816
EXT3-fs error (device ubda): ext3_lookup: deleted inode referenced: 964862
EXT3-fs error (device ubda): ext3_lookup: deleted inode referenced: 964786
EXT3-fs error (device ubda): ext3_lookup: deleted inode referenced: 964815
...

- Chris

