Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933742Ab0J1RB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 13:01:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37869 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759982Ab0J1RBU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 13:01:20 -0400
MIME-Version: 1.0
In-Reply-To: <20101028163854.GA15450@elte.hu>
References: <E1PBKT9-0004Uk-Sm@tytso-glaptop> <20101028075631.GA7690@elte.hu>
 <AANLkTi=8SbOZizWpxLg=Bgp7atdgr8MsR6tnRDYr1+eW@mail.gmail.com> <20101028163854.GA15450@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 28 Oct 2010 10:00:26 -0700
Message-ID: <AANLkTin62vAwJxcsrFk6Yn7Q6tzr-D=EmKKwPazuAJ11@mail.gmail.com>
Subject: Re: -tip: origin tree build failure (was: [GIT PULL] ext4 update for 2.6.37)
To: Ingo Molnar <mingo@elte.hu>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 9:38 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> Point taken in any case, i'll read your edited changelog and will change the
> template accordingly.
>
> Would this:
>
>  Upstream commit 5dabfc7 ("ext4: rename {exit,init}_ext4_*() to
>  ext4_{exit,init}_*()"), breaks the build on all[yes/mod]config with
>  CONFIG_EXT4_FS_XATTR disabled:
>
>  ...
>
> have been better?

Yes. Except for the kernel the default git commit abbreviation is
borderline too short. Seven hex-chars can easily alias with a few more
pulls from me: git will not give aliases at the time it gives a
shorthand, but a month or two later the abbreviated commit may no
longer be unique.

So I suggest using --abbrev=12 or similar.

What I ended up writing your commit as was this:

    ext4: fix compile with CONFIG_EXT4_FS_XATTR disabled

    Commit 5dabfc78dced ("ext4: rename {exit,init}_ext4_*() to
    ext4_{exit,init}_*()") causes

      fs/ext4/super.c:4776: error: implicit declaration of function
‘ext4_init_xattr’

    when CONFIG_EXT4_FS_XATTR is disabled.

    It renamed init_ext4_xattr to ext4_init_xattr but forgot to update the
    dummy definition in fs/ext4/xattr.h.

    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Acked-by: "Theodore Ts'o" <tytso@mit.edu>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

but that's just me.

                   Linus
