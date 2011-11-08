Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122Ab1KHE0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 23:26:44 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43225 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab1KHE0m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 23:26:42 -0500
MIME-Version: 1.0
In-Reply-To: <20111108031242.GU2203@ZenIV.linux.org.uk>
References: <CA+55aFzytqbGcOzWvYAo-EnJCeK5mFqdCF5OjMTeM5UBfeyCXw@mail.gmail.com>
 <20111108031242.GU2203@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 7 Nov 2011 20:26:20 -0800
X-Google-Sender-Auth: k0vLmpaW1FJcrk0UksPr4ao1dGs
Message-ID: <CA+55aFydrFEKUaSV-JPKXqPc63imZVmaVW0n6Ft_YqoWxp7RQQ@mail.gmail.com>
Subject: Re: Linux 3.2-rc1
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 7, 2011 at 7:12 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> FWIW, agruen seems to be doing patch(1) development these days; the last
> snapshot has this in NEWS:
>
> * Support for most features of the "diff --git" format: renames and copies,
>  permission changes, symlink diffs.

Oh, good.

> Caveats:
>  + Binary diffs are not supported yet; patch will complain and skip them.
>  + In the "diff --git" format, all the patches are relative to the original
>    state of the files to patch, allowing things like criss-cross renames.
>    GNU patch will currently fail for such patches.

This is all fine. The criss-cross renames are possible, but I don't
generate them: you need to specify the "-B" flag to git to "break"
existing names, and none of my normal kernel patches ever do that. It
can be useful to find cases where people have renamed things on top of
existing files (which does happen occasionally), but on the whole it's
not a big feature.

And the binary patches we've always generated the magical git binary
version of, since there is no traditional format for that at all - and
it has never been a problem in practice. I think the only binary file
we have is the logo, and that one doesn't change.

So it sounds like 'patch' will handle all the cases that are really relevant.

> Hell knows how long until they release it and distros pick the result, of
> course.  Their git tree on git://git.savannah.gnu.org/patch.git is fairly
> quiet; there had been a bunch of local fixes since the last snapshot (this
> April) but not much else...

It sounds like I should continue to do the traditional patches for a
while longer, but it does sound like it's an issue that will fix
itself in the not too distant future.  Goodie.

              Linus
