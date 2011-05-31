Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305Ab1EaRe1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 13:34:27 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51204 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757547Ab1EaRe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 13:34:26 -0400
Date: Tue, 31 May 2011 18:33:48 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sage Weil <sage@newdream.net>
Cc: Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [git pull] dentry_unhash() breakage
Message-ID: <20110531173348.GL11521@ZenIV.linux.org.uk>
References: <20110530020604.GC561@dastard>
 <20110530034741.GD561@dastard>
 <Pine.LNX.4.64.1105292057570.9134@cobra.newdream.net>
 <20110530055601.GK11521@ZenIV.linux.org.uk>
 <20110530085922.GA11336@infradead.org>
 <Pine.LNX.4.64.1105310924040.25709@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1105310924040.25709@cobra.newdream.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 09:26:52AM -0700, Sage Weil wrote:
> On Mon, 30 May 2011, Christoph Hellwig wrote:
> > On Mon, May 30, 2011 at 06:56:01AM +0100, Al Viro wrote:
> > > A couple of dentry_unhash fallout fixes
> > 
> > Shouldn't we do the shrink_dcache_parent only after a successfull
> > rmdir or rename?
> 
> Yeah, that makes more sense to me...

No, it doesn't.  Let's keep changes to minimum.  I *really* don't want
to audit autofs and hell knows how many other places for more or less
subtle breakage caused by that.  It's bad enough as it is...
