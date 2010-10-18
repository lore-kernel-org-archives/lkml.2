Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab0JRJLq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 05:11:46 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59002 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab0JRJLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 05:11:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=RQL6C0hnDtMQdnqyxIuk1dJ9/PLymKS+uMuHpHUrn4mdynuVRYmaPkGdLmC6aG2PMj
         MBm+bGO3ZqmBq5iCCopeGq4oI3T5FOFk7kihshZ/a3tItKE+V3xR+fX9aPcwaah+tWFr
         fkB5KpNbA5UAT4BLP59giavRVbAqKl39IM+wI=
Subject: Re: [PATCH 19/19] fs: do not assign default i_ino in new_inode
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101016163517.GF20086@infradead.org>
References: <1287216853-17634-1-git-send-email-david@fromorbit.com>
	 <1287216853-17634-20-git-send-email-david@fromorbit.com>
	 <1287220153.2799.101.camel@edumazet-laptop>
	 <20101016163517.GF20086@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Oct 2010 11:11:39 +0200
Message-ID: <1287393099.2409.8.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 16 octobre 2010 à 12:35 -0400, Christoph Hellwig a écrit :

> What's the point, really?  Assigning i_ino in new_inode always has been
> an utterly stupid idea to start with.  I fixed the few filesystem that
> need it to do it explicitly.  There's nothing unsafe about it - checking
> callers of new_inode for manual i_ino assignment was trivial.
> 
> Conditional code like the one you suggested is simply evil - it
> complicates things instead of simplifying them.

This is what we call code factorization. I wont call it evil.

If we want to change get_next_ino(void) implementation to 
get_next_ino(struct inode *), or even get_next_inode(struct inode
*inode, struct super_block *sb)
 then we must go through all fs after your patch to add the new
parameter.

I proposed an implementation on get_next_ino() on 32bit arches, with no
per_cpu and shared counter, assuming we know the inode pointer. With
your patch, it become very difficult to implement such an idea.



