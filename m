Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547Ab2KPPpx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 10:45:53 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53826 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab2KPPpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 10:45:50 -0500
MIME-Version: 1.0
In-Reply-To: <20121116041523.18624.46918.stgit@perseus.themaw.net>
References: <20121116041523.18624.46918.stgit@perseus.themaw.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 16 Nov 2012 07:45:29 -0800
X-Google-Sender-Auth: igTdAHhVF0RWWYel7rAxdCC50C8
Message-ID: <CA+55aFx-9A0xknhX7z9KmLAoGMf5GXhuFgroZUixHtevGAFsOQ@mail.gmail.com>
Subject: Re: [PATCH] autofs4 - use simple_empty() for empty directory check
To: Ian Kent <ikent@redhat.com>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2012 at 8:15 PM, Ian Kent <ikent@redhat.com> wrote:
>
> +static inline int __simple_empty(struct dentry *dentry)
> +{

This seems completely bogus.

It's a duplicate of the existing fs/libfs.c "simple_empty()" function,
but without taking the outer lock.

That kind of code duplication - and doing it in a totally different
file, and making it look autofs-specific - seems entirely wrong.

                      Linus
