Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab1HHPFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 11:05:25 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37688 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab1HHPFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 11:05:24 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Johannes Weiner <jweiner@redhat.com>, fuse-devel@lists.sourceforge.net,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] fuse: delete dead .write_begin and .write_end aops
References: <1311626135-14279-1-git-send-email-jweiner@redhat.com>
	<20110725204942.GA12183@infradead.org>
Date: Mon, 08 Aug 2011 17:05:20 +0200
In-Reply-To: <20110725204942.GA12183@infradead.org> (Christoph Hellwig's
	message of "Mon, 25 Jul 2011 16:49:42 -0400")
Message-ID: <87aabkeyfj.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Mon, Jul 25, 2011 at 10:35:34PM +0200, Johannes Weiner wrote:
>> Ever since 'ea9b990 fuse: implement perform_write', the .write_begin
>> and .write_end aops have been dead code.
>> 
>> Their task - acquiring a page from the page cache, sending out a write
>> request and releasing the page again - is now done batch-wise to
>> maximize the number of pages send per userspace request.
>
> The loop code still calls them uncondtionally.  This actually is a big
> as write_begin and write_end require filesystems specific locking,
> and might require code in the filesystem to e.g. update the ctime
> properly.  I'll let Miklos chime in if leaving them in was intentional,
> and if it was a comment is probably justified.

Loop checks for ->write_begin() and falls back to ->write if the former
isn't defined.

So I think the patch is fine.  I tested loop over fuse, and it still
works after the patch.

Added to for-next.

Thanks,
Miklos
