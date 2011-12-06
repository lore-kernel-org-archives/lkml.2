Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab1LFTyl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:54:41 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38273 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab1LFTyj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:54:39 -0500
MIME-Version: 1.0
In-Reply-To: <20111206154854.GH2203@ZenIV.linux.org.uk>
References: <20111206154854.GH2203@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 6 Dec 2011 11:54:16 -0800
X-Google-Sender-Auth: Fjg9CqHySRq_QiE6WYaaOgZi7wo
Message-ID: <CA+55aFybiSeYk57DdWXVWJvDk0VTU2hUtJWZUMaBdWOxYtdd_w@mail.gmail.com>
Subject: Re: [git pull] apparmor fix for __d_path() misuse
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        John Johansen <john.johansen@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 6, 2011 at 7:48 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>        Fix for use-after-free race in apparmor d_namespace_path() and
> partially sanitizing the atrocious __d_path() API that has caused that
> mess in the first place.

Ugh, having looked at this, I really don't want to pull it.

First off, I do agree that the __d_path() api isn't pleasant, and that
we can/should change it. I just don't agree with the particular
changes. Feel free to try to convince me otherwise, but..

As far as I can tell, the *only* user of the new 'bastard' interface
is (apart from the pure amusement for the name) that silly special
check for AppArmour.

Is AA *worth* that special case? Does it even care that deeply?

So my argument is that I think your change to make 'root' const an
dnot be changed is good, and should stay. But 'bastard' should just go
away, amusingly named or not. All sane callers already call it with a
NULL pointer. The one case that doesn't isn't worth worrying about,
and should strive to solve its problems some saner way.

John explicitly cc'd, since he's the one that would have to figure out
that /sys special case. Is it possible that just calling __d_path()
with the global system root would be sufficient for apparmor in this
case to figure out the /sys part?

                        Linus
