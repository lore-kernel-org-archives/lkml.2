Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab0EYM2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 08:28:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48196 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756500Ab0EYM2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 08:28:33 -0400
Date: Tue, 25 May 2010 08:28:27 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Eric Paris <eparis@redhat.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Kay Sievers <kay.sievers@suse.de>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: udev loops eating 100 % CPU [mmotm 2010-05-21-16-05]
Message-ID: <20100525122827.GA21596@infradead.org>
References: <4BFBBEB7.4070107@gmail.com> <1274790132.2810.65.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274790132.2810.65.camel@localhost>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 08:22:12AM -0400, Eric Paris wrote:
> On Tue, 2010-05-25 at 14:12 +0200, Jiri Slaby wrote:
> 
> thanks for the report, it's a known problem:
> 
> http://lkml.org/lkml/2010/5/22/150
> 
> Not sure yet how we are going to fix it.  You can either just revert or
> you could run this patch which I am using on my box.  Not sure which Al
> is going to want to do......
> 
> commit 6e066d6c0c70e2032b5fd2b5c6375e66a0f547f9
> Author: Eric Paris <eparis@redhat.com>
> Date:   Tue May 25 07:55:46 2010 -0400
> 
>     anon_inode/ioctl: push FIONREAD for anon_inode to the file handler
>     
>     FIONREAD for all S_IFREG files is handled by file_ioctl but the
>     anon_inode_inode is a magic special beast since the inode is shared between
>     lots of users.  Thus ioctl calls on anon_inode_inode needs to go through
>     vfs_inode() instead of trying to shortcut some calls through file_ioctl().
>     
>     Signed-off-by: Eric Paris <eparis@redhat.com>

This one is defintively far too disgusting.

