Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056Ab1CVS6X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 14:58:23 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:45059 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab1CVS6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 14:58:21 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: viro@zeniv.linux.org.uk, miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        apw@canonical.com, nbd@openwrt.org, neilb@suse.de
In-reply-to: <AANLkTinU-F+fHaG9u7c4Tf0GNx5BJvHg7BGOAFGaiDn1@mail.gmail.com>
	(message from Linus Torvalds on Tue, 22 Mar 2011 11:48:11 -0700)
Subject: Re: [PATCH 0/6 v7] overlay filesystem - request for inclusion
References: <20110322152602.053930811@szeredi.hu> <AANLkTinxD2rZnso3zfX0=-HQ9m7=zAjEtUepFO=uMe2Q@mail.gmail.com>
 <20110322183919.GV22723@ZenIV.linux.org.uk> <AANLkTinU-F+fHaG9u7c4Tf0GNx5BJvHg7BGOAFGaiDn1@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <E1Q26mX-0001Tt-Jq@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 22 Mar 2011 19:58:17 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Mar 2011, Linus Torvalds wrote:
> On Tue, Mar 22, 2011 at 11:39 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Locking analysis would be really nice; AFAICS, it violates locking order
> > when called from e.g. ->setattr()

Locking order is always:

-> overlayfs locks
   -> upper fs locks
   -> lower fs locks

So it's really pretty simple and easy to validate.

> >  and its protection against renames is
> > nowhere near enough.  I might be missing something subtle, but...

Protection is exactly as for userspace callers.  AFAICT.

> Miklos - have you tried using this with lockdep (together with the
> same filesystems mounted natively too)? I'd expect that that should
> show any bad lock usage..

Ah, lockdep.  I have tried, but there seems to be always something
that triggers it at boot time on my laptop, which makes it useless.  I
could find some other machine to test this on, though.

Thanks,
Miklos
