Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092Ab2KPQnw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 11:43:52 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:51759 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab2KPQnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 11:43:49 -0500
MIME-Version: 1.0
In-Reply-To: <1353083773.2332.40.camel@perseus.themaw.net>
References: <20121116041523.18624.46918.stgit@perseus.themaw.net>
 <CA+55aFx-9A0xknhX7z9KmLAoGMf5GXhuFgroZUixHtevGAFsOQ@mail.gmail.com> <1353083773.2332.40.camel@perseus.themaw.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 16 Nov 2012 08:43:28 -0800
X-Google-Sender-Auth: e0y4XyBoxkVm-rVm9IeQLNyhNKg
Message-ID: <CA+55aFz+JUthf-HAdYLzQH=r0niB4+X1ymn5egLpdhiptYXr7w@mail.gmail.com>
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

On Fri, Nov 16, 2012 at 8:36 AM, Ian Kent <ikent@redhat.com> wrote:
>
> Sure, are you recommending I alter the fs/libfs.c functions to add a
> function that doesn't have the outer lock, and have simple_empty() call
> that, then use it in autofs?

Yup. That's the standard pattern, although usually we *strive* to make
the unlocked versions be static to the internal code, and then use
them there for the various helpers. In your case that seems
impossible, since you do depend on holding the d_lock in the caller
after the tests. But at least we don't have to duplicate the code and
have it in two unrelated places.

Al? Comments?

            Linus
