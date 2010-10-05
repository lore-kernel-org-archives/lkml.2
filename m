Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757685Ab0JEUcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 16:32:53 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:35021 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199Ab0JEUcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 16:32:52 -0400
X-Originating-Ip: 216.16.235.2
Date: Tue, 5 Oct 2010 16:31:37 -0400
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
Message-ID: <20101005203137.GA594@foursquare.net>
References: <20100928150000.f007f43e.akpm@linux-foundation.org> <201009290013.11332.richard@nod.at> <20100928225202.GA30352@foursquare.net> <4CA275CE.6060401@fusionio.com> <20100929012945.GA3324@foursquare.net> <4CA2CCC3.8010307@fusionio.com> <20100929063452.GA13290@foursquare.net> <4CAA02D0.7040901@gmail.com> <20101004195152.GA31583@foursquare.net> <4CAAE077.9010500@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CAAE077.9010500@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 05, 2010 at 10:23:19AM +0200, Tejun Heo wrote:
> Hmmmm, can you please give a shot at the following one?  Thank you.

I applied this patch on top of stock 2.6.35.5 as usual (no other patches)
and tested on my maverick image as before.  I ran a fsck.ext3 on the
filesystem image from the host before my test, just to make sure, and
there were no errors.

Unfortunately, this patch does not fix the issue either.  I get errors
in the guest like the following:

EXT3-fs error (device ubda): htree_dirblock_to_tree: bad entry in directory #1137497: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
EXT3-fs (ubda): warning: empty_dir: bad directory (dir #1137497) - no `.' or `..'
EXT3-fs error (device ubda): htree_dirblock_to_tree: bad entry in directory #1137587: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
EXT3-fs (ubda): warning: empty_dir: bad directory (dir #1137587) - no `.' or `..'
EXT3-fs error (device ubda): htree_dirblock_to_tree: bad entry in directory #1137619: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
EXT3-fs (ubda): warning: empty_dir: bad directory (dir #1137619) - no `.' or `..'
EXT3-fs error (device ubda): htree_dirblock_to_tree: bad entry in directory #1137532: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
EXT3-fs (ubda): warning: empty_dir: bad directory (dir #1137532) - no `.' or `..'
EXT3-fs (ubda): warning: ext3_rmdir: empty directory has nlink!=2 (6)
EXT3-fs (ubda): warning: ext3_rmdir: empty directory has nlink!=2 (3)


And later on:

EXT3-fs error (device ubda): ext3_lookup: deleted inode referenced: 867196
EXT3-fs error (device ubda): ext3_lookup: deleted inode referenced: 484932
EXT3-fs error (device ubda): ext3_lookup: deleted inode referenced: 484932


- Chris

