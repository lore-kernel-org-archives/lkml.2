Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964791Ab2AEWQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 17:16:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43461 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932954Ab2AEWQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 17:16:07 -0500
Date: Thu, 5 Jan 2012 14:16:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        Edward Shishkin <edward@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 0/3] Stop clearing uptodate flag on write IO error
Message-Id: <20120105141606.5e19a08b.akpm@linux-foundation.org>
In-Reply-To: <1325774407-28531-1-git-send-email-jack@suse.cz>
References: <1325774407-28531-1-git-send-email-jack@suse.cz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  5 Jan 2012 15:40:04 +0100
Jan Kara <jack@suse.cz> wrote:

> 
>   Hello,
> 
>   for mostly historical reasons we still clear buffer_uptodate flag on write
> IO errors.

I have long and strong memories of never being able to understand why
we did that.

> This is not only semantically wrong (buffer still has correct data
> in it) but it also triggers warnings in mark_buffer_dirty when buffer is
> written again which scares lots of users (as they tend to unplug USB sticks
> too early). This patch series is an attempt to start solving the problem
> by allowing filesystem to tell whether it wishes buffer_uptodate flag cleared
> on write IO error. Ext2 is converted to use this as an example. Eventually
> when all filesystems are converted, we can remove the condition.
> 
> Do people think this is a desirable way to go?
> 

Linus might have some thoughts.
