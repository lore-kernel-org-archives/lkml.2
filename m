Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab2KPQgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 11:36:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54619 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371Ab2KPQgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 11:36:18 -0500
Message-ID: <1353083773.2332.40.camel@perseus.themaw.net>
Subject: Re: [PATCH] autofs4 - use simple_empty() for empty directory check
From: Ian Kent <ikent@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Date: Sat, 17 Nov 2012 00:36:13 +0800
In-Reply-To: <CA+55aFx-9A0xknhX7z9KmLAoGMf5GXhuFgroZUixHtevGAFsOQ@mail.gmail.com>
References: <20121116041523.18624.46918.stgit@perseus.themaw.net>
	 <CA+55aFx-9A0xknhX7z9KmLAoGMf5GXhuFgroZUixHtevGAFsOQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-16 at 07:45 -0800, Linus Torvalds wrote:
> On Thu, Nov 15, 2012 at 8:15 PM, Ian Kent <ikent@redhat.com> wrote:
> >
> > +static inline int __simple_empty(struct dentry *dentry)
> > +{
> 
> This seems completely bogus.
> 
> It's a duplicate of the existing fs/libfs.c "simple_empty()" function,
> but without taking the outer lock.
> 
> That kind of code duplication - and doing it in a totally different
> file, and making it look autofs-specific - seems entirely wrong.

Sure, are you recommending I alter the fs/libfs.c functions to add a
function that doesn't have the outer lock, and have simple_empty() call
that, then use it in autofs?

Or are recommending I rework the autofs code?

Ian

