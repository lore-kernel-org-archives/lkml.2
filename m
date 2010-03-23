Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237Ab0CWXrX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 19:47:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43937 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab0CWXrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 19:47:22 -0400
Date: Tue, 23 Mar 2010 23:47:19 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Nigel Cunningham <ncunningham@crca.org.au>
Cc: Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, chris.mason@oracle.com, hch@lst.de
Subject: Re: [PATCH] Introduce freeze_super and thaw_super for the fsfreeze
 ioctl
Message-ID: <20100323234719.GM30031@ZenIV.linux.org.uk>
References: <20100323142200.GA2381@localhost.localdomain>
 <20100323142843.GG30031@ZenIV.linux.org.uk>
 <20100323143456.GC2381@localhost.localdomain>
 <20100323144828.GH30031@ZenIV.linux.org.uk>
 <20100323150301.GD2381@localhost.localdomain>
 <20100323150923.GI30031@ZenIV.linux.org.uk>
 <4BA94157.6090907@crca.org.au>
 <20100323231802.GL30031@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100323231802.GL30031@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 11:18:03PM +0000, Al Viro wrote:
> [snip the horror]
> 
> 	a) traversing superblock list without any locking whatsoever
> 	b) accessing superblock fields <....>
> 	c) <.........................> without making sure that it's not
> going to disappear
> 	d) calling freeze_bdev() without any warranties that its argument
> is not going to be freed under you
> 	e) layering violations all over the place
> etc.

BTW, superblock can be kept alive by an opened file.  umount -l, for example,
will give that.  So it can get freed whenever the last reference to struct
file can go away (AF_UNIX garbage collection, etc.)
