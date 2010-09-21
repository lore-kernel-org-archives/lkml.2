Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905Ab0IUUKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 16:10:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57590 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab0IUUKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 16:10:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sage Weil <sage@newdream.net>
Subject: Re: [PATCH] fs/locks.c: prepare for BKL removal
Date: Tue, 21 Sep 2010 22:09:51 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc4+; KDE/4.5.1; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        Matthew Wilcox <willy@linux.intel.com>, Christoph Hellwig <hch@lst.de>,
        Trond Myklebust <trond.myklebust@fys.uio.no>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, John Kacur <jkacur@redhat.com>,
        linux-fsdevel@vger.kernel.org, gregf@hq.newdream.net
References: <1284815371-5843-1-git-send-email-arnd@arndb.de> <20100920160729.96872d12.sfr@canb.auug.org.au> <Pine.LNX.4.64.1009210910410.13310@cobra.newdream.net>
In-Reply-To: <Pine.LNX.4.64.1009210910410.13310@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009212209.51956.arnd@arndb.de>
X-Provags-ID: V02:K0:gmIQaRs9p10Mx2u57SHMrqRLafyQE0BZgJs/32Xi4K+
 VB11+R6GMVgcxitWp0wsS4cIU1BaOSu42SbH4UVrlo8ghh5Hha
 X0hyAzQCCwe4s5HKlTbJWBZrE8R9IOe+XUgQTjicpQB5EAUtEA
 HXfuQfWXxszYv4vf3tuKQQyJWN8yB+K5OgT6KsVjhm63jLPoIZ
 zcvpHMUx1tu78Zd9l9nVQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 September 2010 18:12:07 Sage Weil wrote:
> On Mon, 20 Sep 2010, Stephen Rothwell wrote:
> 
> > On Sun, 19 Sep 2010 20:59:01 -0700 (PDT) Sage Weil <sage@newdream.net> wrote:
> > >
> > > I suspect the easiest thing is to leave Ceph out of this stage of your 
> > > series, I'll switch lock_kernel() to lock_flocks() once that exists 
> > > upstream.  Unless there is a better way? 
> > 
> > Maybe someone could write a trivial implementation of lock_flocks() (i.e.
> > one that does not make any changes to behaviour) and ask Linus to take it
> > now in preparation for the next merge window (he has done that before).
> > That way, more of this could be put into individual other trees and avoid
> > more conflicts ...
> 
> This sounds like the easiest solution to me.  Something as simple as
> 
> #define lock_flocks lock_kernel
> #define unlock_flocks unlock_kernel
> 
> in fs.h?

Sounds fine to me. I don't think it's necessary but if you prefer to do
it, you can have my Ack.

	Arnd
