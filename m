Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350Ab2HFFBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 01:01:17 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52380 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab2HFFBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 01:01:15 -0400
MIME-Version: 1.0
In-Reply-To: <20120806134318.8af35d047e255fd25398210b@canb.auug.org.au>
References: <20120806134318.8af35d047e255fd25398210b@canb.auug.org.au>
Date: Sun, 5 Aug 2012 22:01:14 -0700
Message-ID: <CANN689GqydNH0-gisSfUPtGKAHVajzZ4KQCTKoJ7J76dJ8zVbg@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the akpm tree
From: Michel Lespinasse <walken@google.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 5, 2012 at 8:43 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Caused by commit 5599fe1ab023 ("rbtree: empty nodes have no color") from
> the akpm tree interacting with commit cde7c325077b ("GFS2: Add structure
> to contain rgrp, bitmap, offset tuple") from the gfs2 tree.
>
> I have applied the following merge fix patch (which is probably not
> sufficient).

You are right that this is insufficient - gfs2 is using
RB_EMPTY_NODE() to check for nodes not being inserted on any rbtree,
so it must use RB_CLEAR_NODE() for initialization.

Will attach a patch as a reply to this.

I am surprised how fast these rb_init_node() calls are spreading.
Should I send Linus a patch removing that function so he could include
it in v3.6 and avoid having to deal with all these new uses ?

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
