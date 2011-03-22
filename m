Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124Ab1CVTiM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 15:38:12 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41205 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822Ab1CVTiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 15:38:10 -0400
Date: Tue, 22 Mar 2011 19:38:07 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de
Subject: Re: [PATCH 0/6 v7] overlay filesystem - request for inclusion
Message-ID: <20110322193807.GX22723@ZenIV.linux.org.uk>
References: <20110322152602.053930811@szeredi.hu>
 <AANLkTinxD2rZnso3zfX0=-HQ9m7=zAjEtUepFO=uMe2Q@mail.gmail.com>
 <20110322183919.GV22723@ZenIV.linux.org.uk>
 <AANLkTinU-F+fHaG9u7c4Tf0GNx5BJvHg7BGOAFGaiDn1@mail.gmail.com>
 <E1Q26mX-0001Tt-Jq@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Q26mX-0001Tt-Jq@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 07:58:17PM +0100, Miklos Szeredi wrote:

> > >  and its protection against renames is
> > > nowhere near enough. ??I might be missing something subtle, but...
> 
> Protection is exactly as for userspace callers.  AFAICT.

BTW, what filesystems can act as upper layers and how are you going to
prevent modifications of upper layer in normal way?  It is mounted,
after all, or you would be unable to find it when mounting overlayfs.
And it might be mounted in any number of places, not all even visible to
you...  I realize that you have it listed as a problem, but do you have
any ideas on how to deal with that?

If you allow NFS as upper layer, you really have a problem; with this
approach you probably want to prevent that very forcibly.  Not that
your open() handling would work correctly with NFS, even with no modifications
from other clients or from server...
