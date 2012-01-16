Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454Ab2APS4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 13:56:23 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57517 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756351Ab2APS4R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 13:56:17 -0500
MIME-Version: 1.0
In-Reply-To: <20120116160136.GC16431@quack.suse.cz>
References: <1325774407-28531-1-git-send-email-jack@suse.cz>
 <CA+55aFy0sidnCzPkP6yjnarLZx3a=7QSpgfaf2mUNVy14y3vCw@mail.gmail.com> <20120116160136.GC16431@quack.suse.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 16 Jan 2012 10:55:55 -0800
X-Google-Sender-Auth: yCFrz_MEQ2WOEzQl33hbcyuM1Yg
Message-ID: <CA+55aFyUiLq7UZeQD=-MU5ppvEDULiBP8xV0mJqVLL6nFAi7VA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] Stop clearing uptodate flag on write IO error
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        Edward Shishkin <edward@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 8:01 AM, Jan Kara <jack@suse.cz> wrote:
>
>  Hum, let me understand this. I understand the meaning of buffer_uptodate
> bit as "the buffer has at least as new content as what is on disk". Now
> when storage cannot write the block under the buffer, the contents of the
> buffer is still "at least as new as what is (was) on disk".

No.

Stop making crap up.

If the write fails, the buffer contents have *nothing* to do with what
is on disk.

You don't know what the disk contents are.

So clearly the buffer cannot be up-to-date.

Now, feel free to use *other* arguments for why we shouldn't clear the
up-to-date bit, but using the disk contents as one is pure and utter
garbage. And it is *obviously* pure and utter garbage.

                   Linus
