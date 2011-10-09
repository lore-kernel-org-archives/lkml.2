Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425Ab1JINWK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 09:22:10 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:44917
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750744Ab1JINWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 09:22:06 -0400
Date: Sun, 9 Oct 2011 09:21:55 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Sage Weil <sage@newdream.net>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        viro@ZenIV.linux.org.uk, ceph-devel@vger.kernel.org,
        rwheeler@redhat.com, linux-kernel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] vfs: add d_prune dentry operation
Message-ID: <20111009132155.GA5920@infradead.org>
References: <1317875170-9349-1-git-send-email-sage@newdream.net>
 <1317875170-9349-2-git-send-email-sage@newdream.net>
 <20111006212118.GA24109@infradead.org>
 <Pine.LNX.4.64.1110061507550.29500@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1110061507550.29500@cobra.newdream.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 06, 2011 at 03:20:37PM -0700, Sage Weil wrote:
> > It also seem like it basically should not be be opencoded but in a
> > wrapper around dentry_lru_del for all cases but the lazy removal from
> > LRU in case that is referenced, with some comments explaining the whole
> > thing.
> 
> Yeah, that's a bit better.  There are four dentry_lru_del() callers, two 
> where we there is a reference, and two where we want to ->d_prune too.
> 
> How does the below look?

This looks much better.

It will clash a bit with Dave's dcache series that were part of his
shrinker/lru series, which I really hope he is going to resumit for
3.2 (at least the dcache cleanup parts).

Al, any progress on getting the current VFS queue up somewhere for
review?
