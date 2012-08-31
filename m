Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab2HaR3I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 13:29:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34288 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224Ab2HaR3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 13:29:06 -0400
Date: Fri, 31 Aug 2012 18:29:00 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: Re: [PATCH] fat: remove redundent call to fat_detach in vfat_unlink
Message-ID: <20120831172900.GC23464@ZenIV.linux.org.uk>
References: <1346431688-3544-1-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346431688-3544-1-git-send-email-linkinjeon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 12:48:07PM -0400, Namjae Jeon wrote:
> As after file is removed fat_evict_inode will be called and fat_detach will be called from that place. So, fat_detach can be removed from vfat_unlink

NAK.  Please, realize that unlink and destruction of file are separate
operations.  ->evict_inode() may be called long after ->unlink(); moreover,
during that time you might have another file created, getting the
same directory entry our file used to have.

This is Unix, damnit.  You *can* open file, then unlink it and that file
will keep existing (i.e. you can write to that descriptor, read, etc.)
until it's closed.
