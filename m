Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932773Ab2AISqp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 13:46:45 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37235 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806Ab2AISqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 13:46:43 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFwikQQrpGoyxvY+y=B8NfKBSdcAnKME+xZh+N1TQfp8LA@mail.gmail.com>
References: <87ipkl87m9.fsf@tucsk.pomaz.szeredi.hu> <20120109171639.GA9359@infradead.org>
 <20120109173010.GX23916@ZenIV.linux.org.uk> <CA+55aFwikQQrpGoyxvY+y=B8NfKBSdcAnKME+xZh+N1TQfp8LA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 9 Jan 2012 10:46:22 -0800
X-Google-Sender-Auth: 85J9LQKVzwr70T-hAnPkD19git4
Message-ID: <CA+55aFxRroO0KAz8qbhz_2vDc=bc-C2b0ux0tdFfQhBGMnqRzQ@mail.gmail.com>
Subject: Re: [RFC PATCH] shrink_dcache_parent() deadlock
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, Miklos Szeredi <miklos@szeredi.hu>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mgorman@suse.de, gregkh@suse.de, akpm@linux-foundation.org,
        david@fromorbit.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 9, 2012 at 10:30 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Here's a TOTALLY UNTESTED rebase of just that single patch from Dave.

Well, it boots, and the dentry cache shrinks under memory pressure. So
it's not _totally_ untested now.

But I don't really see why it would fix Miklos' case. I think
select_parent() may still end up touching the d_lru list of something
that is on the 'dispose' list. So the patch looks like a nice cleanup,
but it seems to be independent of the issue Miklos found.

What am I missing now?

                      Linus
