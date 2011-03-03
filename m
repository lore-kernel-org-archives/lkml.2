Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358Ab1CCUzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 15:55:47 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45147 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758495Ab1CCUzq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 15:55:46 -0500
MIME-Version: 1.0
In-Reply-To: <20110303063214.GL22723@ZenIV.linux.org.uk>
References: <20110303063214.GL22723@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 3 Mar 2011 12:54:57 -0800
Message-ID: <AANLkTik4qEp-CCj-XbGPVxbq_WmmQyt1i6c3hLrD8Sk2@mail.gmail.com>
Subject: Re: [git pull] i_nlink fixes, part 1
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al, you _really_ need to improve your chagelogs.

On Wed, Mar 2, 2011 at 10:32 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Al Viro (8):
>      sysv: i_nlink races in rename()\
>      ufs: i_nlink races in rename()
>      minix: i_nlink races in rename()
>      nilfs2: i_nlink races in rename()
>      exofs: i_nlink races in rename()

What _are_ the races? You don't explain. And the patch in no way makes
it obvious either.

Now, compare it to the explanation for the ext2 case in commit
e8a80c6f769d and ask yourself: why didn't you? Yes, I can read _that_
commit, and I know what's going on, but a few weeks from now (or for
anybody else that only reads the commits for the one filesystem they
care about), that single line is going to be totally useless.

Maybe it doesn't need to be as extensive, but dang it, it needs to be
more than "fix races" with no explanation at all.

Saying just "fix race" may be fine if the patch itself is totally
self-explanatory (add a missing lock or whatever), but even then I'd
prefer something more.

I realize that you are really used to RCS, which made it a pain to
write any kind of explanation at all, but come on.

                        Linus
