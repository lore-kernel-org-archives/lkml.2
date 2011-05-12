Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758301Ab1ELRqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 13:46:47 -0400
Received: from mx2.netapp.com ([216.240.18.37]:35820 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758201Ab1ELRqq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 13:46:46 -0400
X-IronPort-AV: E=Sophos;i="4.64,359,1301900400"; 
   d="scan'208";a="547509346"
Subject: Re: [GIT PULL] fuse fix for 2.6.39
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
In-Reply-To: <BANLkTikBVAJSmBZrAvJ6fRQD32TFNeO4zQ@mail.gmail.com>
References: <87fwokarjj.fsf@tucsk.pomaz.szeredi.hu>
	 <BANLkTin6Ujea+qdkvwkH_9o5F8WKPyFdyA@mail.gmail.com>
	 <BANLkTi=4rdtB5dQH=tycT1sybe7iJmTVcA@mail.gmail.com>
	 <1305217732.15566.31.camel@lade.trondhjem.org>
	 <BANLkTikBVAJSmBZrAvJ6fRQD32TFNeO4zQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp Inc
Date: Thu, 12 May 2011 13:46:29 -0400
Message-ID: <1305222389.21868.10.camel@lade.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
X-OriginalArrivalTime: 12 May 2011 17:46:30.0681 (UTC) FILETIME=[86BD0890:01CC10CC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-12 at 10:21 -0700, Linus Torvalds wrote:
> On Thu, May 12, 2011 at 9:28 AM, Trond Myklebust
> <Trond.Myklebust@netapp.com> wrote:
> >
> > NFS also requires look up using the full 'struct path' if/when we happen
> > upon an automount point (i.e. if we cross into a submounted filesystem
> > on the server or if we encounter an NFSv4 referral). Again, this is
> > something that lookup_one_len() can't do.
> 
> Sure. But we might not want to oops. Would you be willing to try
> ecryptfs over NFS to at least make it limp along?
> 
>                        Linus

I was thinking rather of just returning an EIO if people try. We know
that there are breakages w.r.t. certain operations as I pointed out in
my previous email.

I suppose it really boils down to the following:

Is there really a community of people out there relying on being able to
do ecryptfs over NFS today?
If so, what are they using it for, and are they going to care about
those breakages?

Cheers
  Trond

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

