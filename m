Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932910Ab2FVMdp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 08:33:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932823Ab2FVMdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 08:33:44 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: Torsten Hilbrich <torsten.hilbrich@secunet.com>,
        linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>, Nick Piggin <npiggin@kernel.dk>
Subject: Re: Kernel 3.3.8 breaks accidental ext3 mount of extended partition
References: <4FDEC3C2.4060909@secunet.com>
	<x49fw9smohy.fsf@segfault.boston.devel.redhat.com>
	<4FE0155A.6010404@secunet.com>
	<x49ehpbjiyp.fsf@segfault.boston.devel.redhat.com>
	<20120622001202.GG11645@quack.suse.cz>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 22 Jun 2012 08:33:30 -0400
In-Reply-To: <20120622001202.GG11645@quack.suse.cz> (Jan Kara's message of
	"Fri, 22 Jun 2012 02:12:02 +0200")
Message-ID: <x498vffmspx.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

>   I think it can have something to do with the fact that the partition size
> is not a multiple of 4k (i.e. expected block size)?

Ahh, yes.  Except that ext3 sets the blocksize to 1k by default.
However, I still can't explain why we don't get an error attempting to
access beyond the end of the device.  I'll keep digging on that.

>   BTW: blkdev_max_block() is a terrible name for something that intends to
> return size in blocks...

Fully agreed here, and I'll fix that up when I get my head completely
wrapped around this one.

Thanks for taking a look, Jan!

-Jeff
