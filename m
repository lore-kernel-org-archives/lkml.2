Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497Ab1KVVZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 16:25:10 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59383 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698Ab1KVVZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 16:25:08 -0500
MIME-Version: 1.0
In-Reply-To: <20111122210930.GJ2203@ZenIV.linux.org.uk>
References: <20111122174419.GI2203@ZenIV.linux.org.uk> <CA+55aFz+9TN2z+q9vH2g0wMq6_X8AfYANrntGQd_et+U5+c74Q@mail.gmail.com>
 <20111122210930.GJ2203@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 22 Nov 2011 13:24:46 -0800
X-Google-Sender-Auth: VNFAytnmzB83tqE1SZUqTlvst_I
Message-ID: <CA+55aFyhYDOt49v7kn3nKqr3gNt9+ZcCdT6qa3OZjiL+OLPjpw@mail.gmail.com>
Subject: Re: [git pull] vfs fix
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 1:09 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> FWIW, the fixed form of script follows; if you see any potential problems in
> it, please tell:

So not problems per se, just not very pretty.

> echo Shortlog:
> base=`git merge-base origin "$1"`
> git log --pretty=short "$base..$1" | git shortlog
> echo Diffstat:
> git diff --stat -M "$base..$1"

I would suggest this instead:

  echo Shortlog:
  git shortlog "origin..$1"
  echo Diffstat:
  git diff --stat --summary -M "origin...$1"

and skip all the merge-base crap (git will do it for you: with a "git
log" you don't need it, and with a "git diff" the three-dot version
will do it for you). And just use "git shortlog" directly.

And the above also uses "--summary" for the "git diff" to show a
summary of renames/deletes.

                        Linus
