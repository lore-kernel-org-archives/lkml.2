Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab0J0Er4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 00:47:56 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60053 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab0J0Erv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 00:47:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=sA61dMhiTNOcNEcvOuFrAjTVQkwzLc5IkEzUNDyEVnL3d4PrFXANoPtTYCzZRgzz5B
         EOsURw+Oylo3KsPnQW+yX2i4kTypbStRNwD5QNfpjjaw9Pir39J3KqoocYYYX4JSrNT+
         6F6p9Ck5rI0PFvcI3xaMZ926BBIxCUS2NV4MY=
Subject: Re: [PATCH 4/4] fs: remove inode_lock from iput_final and
 prune_icache
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101027044038.GE19804@ZenIV.linux.org.uk>
References: <1288153384-8878-1-git-send-email-david@fromorbit.com>
	 <1288153384-8878-5-git-send-email-david@fromorbit.com>
	 <20101027044038.GE19804@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Oct 2010 06:47:46 +0200
Message-ID: <1288154866.2652.84.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 27 octobre 2010 à 05:40 +0100, Al Viro a écrit :
> On Wed, Oct 27, 2010 at 03:23:04PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Now that inode state changes are protected by the inode->i_lock and
> > the inode LRU manipulations by the inode_lru_lock, we can remove the
> > inode_lock from prune_icache and the initial part of iput_final().
> > 
> > instead of using the inode_lock to protect the inode during
> > iput_final, use the inode->i_lock instead. This protects the inode
> > against new references being taken while we change the inode state
> > to I_FREEING, as well as preventing prune_icache from grabbing the
> > inode while we are manipulating it. Hence we no longer need the
> > i???ode_lock in iput_final prior to setting I_FREEING on the inode.
>   ^^^^^^^^^^^^
> 
> ... the hell?  There's more such damage elsewhere in the thread; what's
> going on?
> --

Maybe its on your side, no problem here on my copy.


