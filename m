Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269Ab2AQBAG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 20:00:06 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:54795 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab2AQBAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 20:00:04 -0500
MIME-Version: 1.0
In-Reply-To: <20120117003613.GA28571@dastard>
References: <1325774407-28531-1-git-send-email-jack@suse.cz>
 <CA+55aFy0sidnCzPkP6yjnarLZx3a=7QSpgfaf2mUNVy14y3vCw@mail.gmail.com>
 <20120116160136.GC16431@quack.suse.cz> <CA+55aFyUiLq7UZeQD=-MU5ppvEDULiBP8xV0mJqVLL6nFAi7VA@mail.gmail.com>
 <20120117003613.GA28571@dastard>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 16 Jan 2012 16:59:41 -0800
X-Google-Sender-Auth: GTv7KOHxqVbwqktVoaRE5QtmQcU
Message-ID: <CA+55aFxZ8dF8WagoyQPYTm92R1ZKd0G_tztqmAc+jrv0LkWGAA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] Stop clearing uptodate flag on write IO error
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        Edward Shishkin <edward@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 4:36 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> Jan is right, Linus. His definition of what up-to-date means for
> dirty buffers is correct, especially in the case of write errors.

It's not a dirty buffer any more.

Go look. We've long since cleared the dirty bit.

So stop spouting garbage.

My argument is simple: the contents ARE NOT CORRECT ENOUGH to be
called "up-to-date and clean".

And I outlined the two choices:

 - mark it dirty and continue trying to write it out forever

 - invalidate it.

Anything else is crazy talk. And marking it dirty forever isn't really
an option. So..

               Linus
