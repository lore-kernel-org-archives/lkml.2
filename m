Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab1ISWcD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 18:32:03 -0400
Received: from smtp-out.google.com ([216.239.44.51]:12286 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab1ISWcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 18:32:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:in-reply-to:references:
	x-mailer:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=qfjdPDKkiUNPB3ShVACl/lUf1WCY+1EeO43tJxFqDaruBmAsDQRBbz3MVkIP+Zl0q
	6flZGRCwY49yBq+lEZrIA==
Date: Mon, 19 Sep 2011 15:31:49 -0700
From: Andrew Morton <akpm@google.com>
To: Tao Ma <tm@tao.ma>
Cc: linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fs/direct-io.c: Calcuate fs_count correctly in
 get_more_blocks.
Message-Id: <20110919153149.be4ab3ca.akpm@google.com>
In-Reply-To: <1316420739-4734-1-git-send-email-tm@tao.ma>
References: <1316420739-4734-1-git-send-email-tm@tao.ma>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Sep 2011 16:25:39 +0800
Tao Ma <tm@tao.ma> wrote:

> In get_more_blocks, we use dio_count to calcuate fs_count and do some
> tricky things to increase fs_count if dio_count isn't aligned. But
> actually it still has some cornor case that can't be coverd. See the
> following example:
> ./dio_write foo -s 1024 -w 4096(direct write 4096 bytes at offset 1024).
> The same goes if the offset isn't aligned to fs_blocksize.
> 
> In this case, the old calculation counts fs_count to be 1, but actually
> we will write into 2 different blocks(if fs_blocksize=4096). The old code
> just works, since it will call get_block twice(and may have to allocate
> and create extent twice for file systems like ext4). So we'd better call
> get_block just once with the proper fs_count.

Has this been carefully tested with more than just ext4?  If so, which?

Thanks.
