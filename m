Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761561Ab0J1UGV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 16:06:21 -0400
Received: from thunk.org ([69.25.196.29]:43415 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757707Ab0J1UFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 16:05:52 -0400
Date: Thu, 28 Oct 2010 16:05:48 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: sedat.dilek@gmail.com
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
        sfr@canb.auug.org.au, Arnd Bergmann <arnd@arndb.de>,
        Avinash Kurup <kurup.avinash@gmail.com>
Subject: Re: [next-20101038] Call trace in ext4
Message-ID: <20101028200548.GC28126@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, sedat.dilek@gmail.com,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	sfr@canb.auug.org.au, Arnd Bergmann <arnd@arndb.de>,
	Avinash Kurup <kurup.avinash@gmail.com>
References: <AANLkTi=E_uMj_ndGU86DCjX4aDwjHqg3dkwxjQRSJtq6@mail.gmail.com>
 <20101028175221.GA1578@arch.trippelsdorf.de>
 <20101028180118.GC6814@thunk.org>
 <20101028193211.GA28126@thunk.org>
 <AANLkTimHJe9bA-X+JWkspgjb4AZkkgbEFWQiwzO-gx-h@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimHJe9bA-X+JWkspgjb4AZkkgbEFWQiwzO-gx-h@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 09:54:23PM +0200, Sedat Dilek wrote:
> 
> Hm, unfortunately NO (see logs).
> 
> I have compiled via M=fs/ext4 in an already compiled build-tree with
> these 3 patches.

Ok, stupid question.  You did make sure the new ext4 module was
loaded, right?

> [  100.884524] ------------[ cut here ]------------
> [  100.884718] kernel BUG at /home/sd/src/linux-2.6/linux-2.6.36/debian/build/source_i386_none/fs/ext4/inode.c:2721!

OK, so after the patch, line 2721: changed from page_buffers() to:

    if (!page_has_buffers(page))

page_has_buffers() expands to:

#define page_has_buffers(page)	PagePrivate(page)

which expands to test_bit() call to see if PG_private1 is set in
page->flags.  There is no BUG_ON anywhere there as far as I can tell.

Line 2721 in the older kernel was page_has_buffers() which does have a
BUG_ON check.

					- Ted
