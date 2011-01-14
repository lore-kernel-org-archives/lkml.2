Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555Ab1ANDi6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 22:38:58 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:38252 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375Ab1ANDiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 22:38:51 -0500
Date: Fri, 14 Jan 2011 03:38:46 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Nick Piggin <npiggin@gmail.com>
Cc: "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: vfs-scale, d_revalidate from nfsd
Message-ID: <20110114033846.GX19804@ZenIV.linux.org.uk>
References: <8855.1294927436@jrobl>
 <AANLkTik1bj=Z9xFv8JfYrxqefFL1owmH=Rctj=XnH4Mp@mail.gmail.com>
 <20110114030325.GU19804@ZenIV.linux.org.uk>
 <AANLkTi=H7Zhe4VMsh_tdrd7Atb9FX8j4AdiMNepXGsj9@mail.gmail.com>
 <20110114032052.GV19804@ZenIV.linux.org.uk>
 <AANLkTi=NJE-rXgFZ44BU4U2KrDg0657ucpupT+RGC4sj@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=NJE-rXgFZ44BU4U2KrDg0657ucpupT+RGC4sj@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 02:29:11PM +1100, Nick Piggin wrote:
> > ? ? ? ?if (nd->flags & LOOKUP_RCU)
> > ? ? ? ? ? ? ? ?return -ECHILD;
> > ? ? ? ?return -EPERM;
> > }
> > when the sole intent of that sucker is to have dentry of /.xattr (pinned
> > in dcache and hashed all along) rejected on lookups from root? ?IOW, WTF
> > bother with -ECHILD here at all?
> 
> That's true. I guess I always have a weakness for doing "just one
> little easy optimisation/simplification" folded into patch that is supposed
> to be more mechanical changes :) I did have exactly that in the patch
> initially, but I decided it's better just to do everything with -ECHILD first.
> 
> That also gives the -ECHILD paths a bit more workout before
> fs conversions are done, too.

Not unless your test loads include trying to access pathnames like
/.xattr/whatever on reiserfs and watching those attempts fail...
