Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710Ab2GMUwM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 16:52:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755751Ab2GMUwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 16:52:09 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        "Steven J. Magnani" <steve@digidescorp.com>,
        Stevie Trujillo <stevie.trujillo@gmail.com>,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: mount -o loop with truncated dosdisk.img uses 100% cpu and can't be killed
References: <20120712162828.3f561315@localhost>
	<1342106206.2156.2.camel@iscandar.digidescorp.com>
	<87k3y8yed3.fsf@devron.myhome.or.jp>
	<20120713154354.GD28715@quack.suse.cz>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 13 Jul 2012 16:51:55 -0400
In-Reply-To: <20120713154354.GD28715@quack.suse.cz> (Jan Kara's message of
	"Fri, 13 Jul 2012 17:43:54 +0200")
Message-ID: <x49y5mn1j10.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

>> It looks like the bug of __getblk_slow(). If requested block was beyond
>> end of device, __find_get_block() will find buffer_mapped()'s buffer,
>> but block >= end_block is unmapped. So, it can be loop.
>> 
>> The following patch fixes it? If it fix, there are some options to check
>> it.
>> 
>> a) Check it like this patch and warn.
>> b) (a), but without warn.
>> c) Check it in init_page_buffers() and return -EIO or such
>> 
>> Well, anyway, Cc to Jens.
>> 
>> Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>   I think Jeff Moyer has sent a similar fix recently. It may even be
> already queued in Jens' tree. Jeff?

A fix for this has now been committed in Linus' tree:
  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=91f68c89d8f35fe98ea04159b9a3b42d0149478f

Cheers,
Jeff
