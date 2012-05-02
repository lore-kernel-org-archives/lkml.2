Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758581Ab2EBC7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 22:59:09 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:57212 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758408Ab2EBC7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 22:59:08 -0400
MIME-Version: 1.0
In-Reply-To: <20120502004439.965120020@goodmis.org>
References: <20120502004439.965120020@goodmis.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 1 May 2012 19:58:46 -0700
X-Google-Sender-Auth: 68BXbPYeAstPQ1F_CQEPunfWZK4
Message-ID: <CA+55aFy02d13HkfwY-TEGwu=2cd8en+_rnrnwcwixGKRmdJRtA@mail.gmail.com>
Subject: Re: [PATCH 0/2] [GIT PULL] ktest: A couple of fixes
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Junio C Hamano <gitster@pobox.com>,
        Git Mailing List <git@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 1, 2012 at 5:44 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Is git set up to not fast forward by default? (I need to give it another try)

Git will fast-forward by default if you do a pull and there is no
development of your own in your tree.

There are two exceptions:

 - you explicitly say that you don't want to fast-forward (--no-ff or
"[merge] ff=false" in the git config file)

 - if you pull a signed tag with a modern version of git.

That second case may be what you hit.

If you do a

  git pull linus v3.4-rc5

in order to just update to the state of my latest tag, then git will
assume you want to do a new commit (and thus a non-fast-forward) just
so that git can record the tag signature in the commit.

The sad part is that I don't think you can even override the second
case. IOW, I think even "git pull --ff linus v3.4-rc5" will still do a
non-fast-forward merge.

That's inconvenient, and an unintended consequence of the behavior I
wanted as a top-level maintainer. But I really do think it's wrong for
normal developers who might validly just want to update to some
particular tagged release.

Junio? Any ideas?

                           Linus
