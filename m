Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab1HBBi5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 21:38:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39527 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753161Ab1HBBiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 21:38:50 -0400
MIME-Version: 1.0
In-Reply-To: <20110802013027.GJ2203@ZenIV.linux.org.uk>
References: <201108020147.01136.rjw@sisk.pl> <201108020217.48952.rjw@sisk.pl>
 <CA+55aFxPAowBwgK7JqN0uH-ytvg+BKdE3yBGF0z_6kNDNcOYcQ@mail.gmail.com> <20110802013027.GJ2203@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 1 Aug 2011 15:38:27 -1000
Message-ID: <CA+55aFzSejw7tyTefSXT_uGz=iESWCH536FwWqaD87=bh2rDUA@mail.gmail.com>
Subject: Re: [Regression] Commit 02c24a82187d5a628c68edfe71ae60dc135cd178
 breaks s2disk
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Josef Bacik <josef@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 1, 2011 at 3:30 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Applied (in file->f_mapping variant; it is equal to bdev->bd_mapping,
> but what's wrong with using ->f_mapping here?)

My only issue was that from a "mindless conversion" standpoint, most
of the other users had been changed to use inode->i_mapping.

I dunno why. I agree that file->f_mapping looks cleaner and is what
the code used to do. But maybe there was some reason why the other
fsync methods had been changed to use

  filemap_write_and_wait_range(inode->i_mapping, start, end);

instead.

           Linus
