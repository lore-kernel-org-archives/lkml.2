Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab0JPJJV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 05:09:21 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50832 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab0JPJJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 05:09:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ZVJM0tK22z2RKKnbNgTHCSjZpGu6Ha/Lt0dj343eFJIt8/oypyXVOKrGc4U6gffVJ8
         46Hw+Ih4F8RvZkOjUffRl4BPZ/CoboI0Sq43CJz0+u4vrhO6HYBmD4QF9HVbqzanuHCr
         06aQgWCl8adLm9EGODRXGBytLOOjUK0xsjf5Y=
Subject: Re: [PATCH 19/19] fs: do not assign default i_ino in new_inode
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1287216853-17634-20-git-send-email-david@fromorbit.com>
References: <1287216853-17634-1-git-send-email-david@fromorbit.com>
	 <1287216853-17634-20-git-send-email-david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 16 Oct 2010 11:09:13 +0200
Message-ID: <1287220153.2799.101.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 16 octobre 2010 à 19:14 +1100, Dave Chinner a écrit :
> From: Christoph Hellwig <hch@lst.de>
> 
> Instead of always assigning an increasing inode number in new_inode
> move the call to assign it into those callers that actually need it.
> For now callers that need it is estimated conservatively, that is
> the call is added to all filesystems that do not assign an i_ino
> by themselves.  For a few more filesystems we can avoid assigning
> any inode number given that they aren't user visible, and for others
> it could be done lazily when an inode number is actually needed,
> but that's left for later patches.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

I wonder if adding a flag in super_block to explicitely say :

"I dont need new_inode() allocates a i_ino for my new inode, because
I'll take care of this myself later"

would be safer, permiting each fs maintainer to assert the flag instead
of a single patch.



