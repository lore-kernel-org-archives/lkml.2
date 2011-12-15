Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410Ab1LOIu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 03:50:29 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:65332 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab1LOIu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 03:50:28 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Paris <eparis@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] audit: fix mark refcounting
References: <87obwof06x.fsf@tucsk.pomaz.szeredi.hu>
	<87ipljcjc2.fsf@tucsk.pomaz.szeredi.hu>
	<CA+55aFxuGPj5rhFYt3O1yci_CqHe+Xs8U7WrWOih2W9U73N69w@mail.gmail.com>
Date: Thu, 15 Dec 2011 09:49:39 +0100
In-Reply-To: <CA+55aFxuGPj5rhFYt3O1yci_CqHe+Xs8U7WrWOih2W9U73N69w@mail.gmail.com>
	(Linus Torvalds's message of "Wed, 14 Dec 2011 18:15:11 -0800")
Message-ID: <87k45yjk2k.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> Looks reasonable, but why doesn't all callers have that "put_mark()" thing?
>
> And if/when all callers *do* have that put_mark() thing, maybe we
> should make destroy_mark() just do it?
>
> In particular, a quick grep shows that there are destroy_mark users still in:
>
>  - fs/notify/fanotify/fanotify_user.c
>
>  - fs/notify/dnotify/dnotify.c (2 of them)

These do in fact do "put_mark()" after the "destroy_mark()".

>
>  - fs/notify/inotify/inotify_fsnotify.c

This one, I think, is broken.

Thanks,
Miklos
