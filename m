Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508Ab0JUA6v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 20:58:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33481 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755592Ab0JUA6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 20:58:48 -0400
MIME-Version: 1.0
In-Reply-To: <1287614875.23812.7.camel@heimdal.trondhjem.org>
References: <20101019225813.12396.2564.stgit@paris.rdu.redhat.com>
 <20101019225839.12396.92630.stgit@paris.rdu.redhat.com> <20101019231747.GC12506@dastard>
 <1287574269.3488.11.camel@twins> <20101020220557.GN32255@dastard>
 <AANLkTikoPoV=OYjzX9+Rd5tWERS+n8sFejJuot7++ONP@mail.gmail.com> <1287614875.23812.7.camel@heimdal.trondhjem.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 20 Oct 2010 17:58:19 -0700
Message-ID: <AANLkTi=HAQEqqswmueJHoc5ez3Bq1_3X2xZkO9sg8gzZ@mail.gmail.com>
Subject: Re: [PATCH 5/6] IMA: use rbtree instead of radix tree for inode
 information cache
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Dave Chinner <david@fromorbit.com>, Peter Zijlstra <peterz@infradead.org>,
        Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, zohar@us.ibm.com, warthog9@kernel.org,
        jmorris@namei.org, kyle@mcmartin.ca, hpa@zytor.com,
        akpm@linux-foundation.org, mingo@elte.hu, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 3:47 PM, Trond Myklebust
<Trond.Myklebust@netapp.com> wrote:
>
> That is a really interesting alternative to traditional locking. Could
> we perhaps document it in Documentation/rbtree.txt?

Well, I'd actually suggest avoiding it unless you feel that you
_really_ need it. So I wouldn't want to really suggest it as a generic
locking model - you had better have looked at pretty much all other
alternatives first.  And if that seqlock starts failing a lot under
load, it ends up being _more_ expensive than just taking the lock in
the first place.

                         Linus
