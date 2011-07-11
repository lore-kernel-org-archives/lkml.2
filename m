Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230Ab1GKOCi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 10:02:38 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56416 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932199Ab1GKOCh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 10:02:37 -0400
Subject: Re: Union mount and lockdep design issues
From: Peter Zijlstra <peterz@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, Alexander Viro <aviro@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Michal Suchanek <hramrach@centrum.cz>, Ian Kent <ikent@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>, miklos@szeredi.hu
In-Reply-To: <16414.1310392490@redhat.com>
References: <1310385651.18678.59.camel@twins>
	 <1310305703.13309.7.camel@twins> <4E0AF2BA.2040706@gmail.com>
	 <1302756608.2854.10.camel@perseus.themaw.net>
	 <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com>
	 <4DA4B6A8.7030804@gmail.com>
	 <BANLkTimsAE1ZAJhsSjnh3LqwsN9x0cLaXg@mail.gmail.com>
	 <4DA5DCB8.3040101@gmail.com>
	 <BANLkTineg2XYYOZAU9trrw=+-vH8McN_9w@mail.gmail.com>
	 <4DA5F569.9020309@gmail.com>
	 <BANLkTi=Z1CQm=u2Q1VCHfr=53n5qTC=7bA@mail.gmail.com>
	 <24792.1302808448@redhat.com> <2477.1309342656@redhat.com>
	 <4E1962BE.8010204@redhat.com> <1408.1310382069@redhat.com>
	 <16414.1310392490@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 11 Jul 2011 16:02:10 +0200
Message-ID: <1310392930.18678.63.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-11 at 14:54 +0100, David Howells wrote:
> 
> I think I misunderstood you, then.  'Fully formed' in what sense?  I assumed
> you meant populated on disk.

I meant, sb exists and has inodes. It would be easier to deal with if
the union mount creates all sb involved, because then we can set the
proper lock class from the start and not have to worry about existing
state.

> I'll post the two patches I have to deal with this.  The first propagates the
> mount flags to sget() and the second makes use of MS_UNION in sget() to key the
> locks appropriately.

Right, note that the patch I provided has a number of problems, for one
it assumes inodes are unused and unlocked in that reclassify loop,
furthermore even by holding inode_sb_list_lock there is a race with
inode creation because we set the lock keys before adding to the
s_inodes list.

Anyway, it does illustrate the idea and someone more versed in vfs can
make it work, I hope ;-)
