Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555Ab1GDIwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 04:52:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753995Ab1GDIwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 04:52:54 -0400
Subject: Re: [PATCH] fs: push i_mutex and filemap_write_and_wait down into
 ->fsync() handlers
From: Steven Whitehouse <swhiteho@redhat.com>
To: Josef Bacik <josef@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@ZenIV.linux.org.uk, hch@infradead.org
In-Reply-To: <1309275310-10987-1-git-send-email-josef@redhat.com>
References: <1309275310-10987-1-git-send-email-josef@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Mon, 04 Jul 2011 09:54:44 +0100
Message-ID: <1309769684.2704.0.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 2011-06-28 at 11:35 -0400, Josef Bacik wrote:
> Btrfs needs to be able to control how filemap_write_and_wait_range() is called
> in fsync to make it less of a painful operation, so push down taking i_mutex and
> the calling of filemap_write_and_wait() down into the ->fsync() handlers.  Some
> file systems can drop taking the i_mutex altogether it seems, like ext3 and
> ocfs2.  For correctness sake I just pushed everything down in all cases to make
> sure that we keep the current behavior the same for everybody, and then each
> individual fs maintainer can make up their mind about what to do from there.
> Thanks,
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>

The GFS2 bit looks ok to me...
Acked-by: Steven Whitehouse <swhiteho@redhat.com>

Steve.


