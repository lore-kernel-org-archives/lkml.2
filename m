Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab1CVTAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 15:00:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50939 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705Ab1CVTAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 15:00:05 -0400
Date: Tue, 22 Mar 2011 19:00:02 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de
Subject: Re: [PATCH 0/6 v7] overlay filesystem - request for inclusion
Message-ID: <20110322190002.GW22723@ZenIV.linux.org.uk>
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
> On Tue, 22 Mar 2011, Linus Torvalds wrote:
> > On Tue, Mar 22, 2011 at 11:39 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > >
> > > Locking analysis would be really nice; AFAICS, it violates locking order
> > > when called from e.g. ->setattr()
> 
> Locking order is always:
> 
> -> overlayfs locks
>    -> upper fs locks
>    -> lower fs locks
> 
> So it's really pretty simple and easy to validate.

In which *order* on the upper fs?

> Protection is exactly as for userspace callers.  AFAICT.

Pardon?  You traverse the chain of ancestors; fine, but who says it stays
anywhere near being relevant as you go?
