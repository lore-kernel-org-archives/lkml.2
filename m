Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758756Ab0FVBeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 21:34:16 -0400
Received: from kaylee.flamingspork.com ([74.207.245.61]:48518 "EHLO
	kaylee.flamingspork.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab0FVBeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 21:34:14 -0400
X-Greylist: delayed 476 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Jun 2010 21:34:14 EDT
From: Stewart Smith <stewart@flamingspork.com>
To: David Pottage <david@electric-spoon.com>,
       Nikanth Karthikesan <knikanth@novell.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@lst.de>, Chris Mason <chris.mason@oracle.com>,
       linux-btrfs@vger.kernel.org
Subject: Re: [PATCH][RFC] Complex filesystem operations: split and join
In-Reply-To: <e4ea1892f15eaac945c151ea14a5d2d9.squirrel@www.chrestomanci.org>
References: <201006092035.46481.knikanth@novell.com> <87aaqzp39a.fsf@devron.myhome.or.jp> <201006151611.36443.knikanth@novell.com> <e4ea1892f15eaac945c151ea14a5d2d9.squirrel@www.chrestomanci.org>
User-Agent: Notmuch/0.3.1-54-g42e146a (http://notmuchmail.org) Emacs/23.1.1 (x86_64-pc-linux-gnu)
Date: Tue, 22 Jun 2010 09:26:16 +0800
Message-ID: <87fx0fuabr.fsf@willster.local.flamingspork.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jun 2010 16:16:06 +0100, "David Pottage" <david@electric-spoon.com> wrote:
> On the other hand, perhaps databases such as SQLite or MySQL would
> benifit from this feature for improving their backend storage, especaly
> if large amounts of BLOB data is inserted or deleted?

unlikely.

1) these operations aren't available everywhere
2) kind of incompatible with how things are stored now
3) no doubt incredibly fun with high concurrency (readers streaming out
BLOBs from later in the file while you go and change everything)
4) a background thread that goes around repacking things if you need to
trim the end off the file just isn't that bad.
   (sure, a nice api call to 'instantly' copy/swap parts of a file could
   be fun... but then it's relying on the OS and file system to get this
   right... which is almost always a bad idea)

cheers,

Stewart "spending way too much time inside databases to maintain sanity" Smith
