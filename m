Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760012Ab0LNUw1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 15:52:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59824 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759994Ab0LNUw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 15:52:26 -0500
Date: Tue, 14 Dec 2010 12:51:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: stefani@seibold.net
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] cramfs: generate unique inode number for better inode
 cache usage
Message-Id: <20101214125143.0ab00c97.akpm@linux-foundation.org>
In-Reply-To: <1292150923-25586-1-git-send-email-stefani@seibold.net>
References: <1292150923-25586-1-git-send-email-stefani@seibold.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Dec 2010 11:48:42 +0100
stefani@seibold.net wrote:

> This patch generates a unique inode numbers for any entries in the cram file
> system. For files which did not contain data's (device nodes, fifos and
> sockets) the offset of the directory entry inside + 1 will be used as the
> inode number.
> 
> The + 1 for the inode will it make possible to distinguish between
> a file which contains no data and files which has data, the later one has
> a inode value where the lower two bits are always 0.
> 
> It also reimplement the behavoir to set the size and the number of block
> to 0 for special file, which is the right value for devices, fifos and
> sockets.
> 
> As a little benefit it will be also more compatible which older
> mkcramfs, because it will never use the cramfs_inode->offset for
> creating a inode number for special files.

Did you look at using iunique() to generate cramfs inode numbers?
