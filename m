Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461Ab1KGNRy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 08:17:54 -0500
Received: from damascus.uab.es ([158.109.168.135]:32734 "EHLO damascus.uab.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932189Ab1KGNRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 08:17:53 -0500
Date: Mon, 07 Nov 2011 15:20:07 +0100
From: Davidlohr Bueso <dave@gnu.org>
Subject: Re: [RFC PATCH] tmpfs: support user quotas
In-reply-to: <20111107112952.GB25130@tango.0pointer.de>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Christoph Hellwig <hch@infradead.org>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Kay Sievers <kay.sievers@vrfy.org>
Message-id: <1320675607.2330.0.camel@offworld>
Organization: GNU
MIME-version: 1.0
X-Mailer: Evolution 3.0.3-2
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
X-Spam-Tests: ALL_TRUSTED=-1
X-imss-version: 2.054
X-imss-result: Passed
X-imss-scanInfo: M:P L:N SM:0
X-imss-tmaseResult: TT:0 TS:0.0000 TC:00 TRN:0 TV:6.5.1024(18498.006)
X-imss-scores: Clean:99.90000 C:2 M:3 S:5 R:5
X-imss-settings: Baseline:3 C:3 M:3 S:3 R:3 (0.5000 0.5000)
References: <1320614101.3226.5.camel@offbook>
 <20111107112952.GB25130@tango.0pointer.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-07 at 12:29 +0100, Lennart Poettering wrote:
> On Mon, 07.11.11 02:31, Christoph Hellwig (hch@infradead.org) wrote:
> 
> >
> > On Sun, Nov 06, 2011 at 06:15:01PM -0300, Davidlohr Bueso wrote:
> > > From: Davidlohr Bueso <dave@gnu.org>
> > >
> > > This patch adds a new RLIMIT_TMPFSQUOTA resource limit to restrict an individual user's quota across all mounted tmpfs filesystems.
> > > It's well known that a user can easily fill up commonly used directories (like /tmp, /dev/shm) causing programs to break through DoS.
> >
> > Please jyst implement the normal user/group quota interfaces we use for other
> > filesystem.
> 
> Please don't.
> 
> tmpfs by its very nature is volatile, which means that we'd have to
> upload the quota data explicitly each time we mount a tmpfs, which means
> we'd have to add quite some userspace infrastructure to make tmpfs work
> with quota. Either every time a tmpfs is mounted we'd have to apply a
> quota for every configured user and every future user to it (which is
> simply not realistic) or on every user logging in we'd have to go
> through all tmpfs mount points and apply a user-specific quota setting
> to it -- which isn't much less ugly and complex. Just using a
> user-specific RLIMIT is much much simpler and beautiful there, and
> requires almost no changes to userspace.
> 
> On top of that I think a global quota over all tmpfs is actually
> preferable than a per-tmpfs quota, because what you want to enforce is
> that clients cannot drain the pool that tmpfs is backed from but how
> they distribute their share of that pool on the various tmpfs mounted
> doesn't really matter in order to avoid DoS vulnerabilities.

Right, rlimit approach guarantees a simple way of dealing with users
across all tmpfs instances.

