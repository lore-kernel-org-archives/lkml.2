Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778Ab1LFRVs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 12:21:48 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46652 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab1LFRVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 12:21:46 -0500
MIME-Version: 1.0
In-Reply-To: <20111206164147.GJ2203@ZenIV.linux.org.uk>
References: <20111206154854.GH2203@ZenIV.linux.org.uk> <20111206164147.GJ2203@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 6 Dec 2011 09:21:24 -0800
X-Google-Sender-Auth: 5lOlOKzIFXYKpdqkrJ5eykO1FTo
Message-ID: <CA+55aFy8juoxVUsRXyjoZKZiU9oeOxqXTOdieYboX9HLtQZTAg@mail.gmail.com>
Subject: Re: [git pull] apparmor fix for __d_path() misuse
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 6, 2011 at 8:41 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Is there any way to have git to complain if you are pushing the current
> branch with uncommitted changes in your repository?

Git has hooks you can use for many ops, but that isn't one of them.
The hooks tend to be at the other end (ie around doing things that
change *your* repository, rather than change some remote repository).
So there are hooks around commit-like operations and around fetching
(so you can check that certain rules apply), but not for pushing.

That said, depending on *how* you push, you can fake it. For example,
since I push to multiple repositories (kernel.org and github, and
before I used github I used to have a separate "backup location" at a
linux-foundation site), I actually don't use "git push" to update
remote repositories, I have a git alias called "push-all" that pushes
to multiple remotes in one go.

And if you can teach your fingers some new way of pushing, then inside
that alias you can obviously add any commands you would want.

                          Linus
