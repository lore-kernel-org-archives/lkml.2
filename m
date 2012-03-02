Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab2CBVff (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 16:35:35 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:58826 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab2CBVfe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 16:35:34 -0500
MIME-Version: 1.0
In-Reply-To: <20120302204521.GD22215@thunk.org>
References: <CADzG2TC8y=sYVYx0rVLAo_o6Mo2tjMOJYAw97ZhKAmNX555a6w@mail.gmail.com>
	<20120302204521.GD22215@thunk.org>
Date: Fri, 2 Mar 2012 21:35:33 +0000
Message-ID: <CADzG2TC-AiUBgwu-s64A7PGch4qnto4avFmQtBzL9Dc7+6CKWQ@mail.gmail.com>
Subject: Re: ext4 bug? last write time precedes last mount time on a writable volume!
From: Neil Clarkson <neilaclarkson@gmail.com>
To: "Ted Ts'o" <tytso@mit.edu>, Neil Clarkson <neilaclarkson@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for responding Ted.

That would all make sense, if it weren't for the last write time on
the Ubuntu box being earlier than the last mount time, when clearly
the superblock *must* have got modified. Clearly that isn't what
Ubuntu is doing with it. But I guess, given that Ubuntu is different
from OpenSuse and Fedora in this regard, perhaps that's just something
Canonical have changed, intentionally or otherwise.

Andi Kleen was right then, when he offered much the same explanation
to me last week on the list.

> Is there a reason why you particularly care about s_wtime being updated?

Yes and no ;)

It was interesting to me when it seemed like it might be a way to find
the time of the last write to the file system, bugs notwithstanding. A
few public domain info sources suggest this is what it is. I could
have made good use of that in some work I'm doing. But if its not
meant to do that, which certainly makes sense from a performance
perspective, then no.


On 2 March 2012 20:45, Ted Ts'o <tytso@mit.edu> wrote:

> It shows the last time the superblock has been modified, and one of
> the things that we've been doing lately has been to optimize ext4 so
> that it writes to the superblock *much* less often.  It was a
> performance bottleneck to be constantly updating the number of free
> blocks in the superblock each time we write to a new block, for
> example --- or update the superblock to update the number of free
> inodes each time we allocate a new inode.
>
> Is there a reason why you particularly care about s_wtime being
> updated?
>
>                                        - Ted
