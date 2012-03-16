Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997Ab2CPVJ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 17:09:56 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:44872 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360Ab2CPVJy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 17:09:54 -0400
MIME-Version: 1.0
In-Reply-To: <20120316210446.2198.qmail@science.horizon.com>
References: <alpine.LNX.2.00.1203161623130.18356@pobox.suse.cz> <20120316210446.2198.qmail@science.horizon.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 16 Mar 2012 14:09:32 -0700
X-Google-Sender-Auth: _Q03kHfZJzaIRxn0fV4Ft5v182M
Message-ID: <CA+55aFwDrh_ODr_3+zEL8f=yJV4_D1sKTStpi8R+fZaxB78VYQ@mail.gmail.com>
Subject: Re: Oops in ext3_block_to_path.isra.40+0x26/0x11b
To: George Spelvin <linux@horizon.com>
Cc: jkosina@suse.cz, jack@suse.cz, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 2:04 PM, George Spelvin <linux@horizon.com> wrote:
>
> Unfortunately, this is the only time it's happened to me with kernel
> modesetting *on*.  Would repeated checksums of a kernel tree be a good
> way to detect random memory stomping?

Yes, doing filesystem checksums tends to be a good way to find memory
corruption, since a lot of memory tends to be caches.

Another approach is to have a stupid program that allocates an array
of say about half the physical memory, and writes some nicely
recognizable pattern to it. Then, every minute or two, re-check the
pattern.

The advantage of the pattern approach is that it makes it possible to
show things like "these X bytes at offset Y in the page changed",
which can give hints about the source of corruption. The full virtual
address is obviously useless, but the "offset within page" can be
quite useful for figuring out corruption patterns even if you can't
necessarily see which physical page it actually is.

                     Linus
