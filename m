Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150Ab0ERL1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 07:27:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:40207 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757136Ab0ERL1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 07:27:15 -0400
Subject: Re: [PATCH v5] mtd: Do not corrupt backing device of device node
 inode
From: David Woodhouse <dwmw2@infradead.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
       David Howells <dhowells@redhat.com>,
       Alexander Shishkin <virtuoso@slind.org>,
       Artem Bityutskiy <dedekind1@gmail.com>, linux-mtd@lists.infradead.org,
       linux-fsdevel@vger.kernel.org, stable@kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1274105441.6930.6920.camel@macbook.infradead.org>
References: <AANLkTimB1DsCd8HuMDc9jgVOnOAE_PVd2ktssp3TIwxc@mail.gmail.com>
	 <1274105441.6930.6920.camel@macbook.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 May 2010 12:27:03 +0100
Message-ID: <1274182023.6930.7023.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-17 at 15:10 +0100, David Woodhouse wrote:
> Now you're just reimplementing iget().
> 
> Can we just use iget_locked() to get the appropriate inode (using the
> mtd device number as the inode number)? Then we don't need to bother
> storing it in mtd->inode at all, and we can iput() the last refcount on
> it when the chardevice is closed -- we don't need it to stick around
> until the MTD device is destroyed. 

... and we don't _want_ it to stick around until the MTD device is
destroyed, either. We may actually unload the mtdchar module and its
inodes will be destroyed when we unregister the fs type; we don't want
stale pointers to them hanging around to be reused if/when we reload the
mtdchar module later.

I've committed a version which keeps it entirely within the mtdchar
code: http://git.infradead.org/mtd-2.6.git/commitdiff/cd874237

Thanks.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

