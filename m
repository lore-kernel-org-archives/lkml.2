Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab2BVSUG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 13:20:06 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:32936 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941Ab2BVSUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 13:20:02 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFzKet5sASgrD==8iZ5m1+-FDpznfuqcNDS5ZyCocwzAbg@mail.gmail.com>
References: <CA+55aFzhS69QSoN1j+Z2md116u+3OfniAoE0QMo6xyBjDyjbEw@mail.gmail.com>
 <20120221.221609.218135609185671883.davem@davemloft.net> <CA+55aFwvmZGDzO_8wwYfH8HsLE=qCmLkJfeMyCe4PVvOYbDMHQ@mail.gmail.com>
 <CA+55aFzv3X3yW8WZGMZO+aKa=qWi2w8=zn2DP-Q3jRry8Ermyw@mail.gmail.com>
 <CA+55aFyh1NmBt0LwR3+iD6B-Xa8wAs-nGJ0MBouPhTzWUi8W5g@mail.gmail.com>
 <1329889428.2193.45.camel@perseus.themaw.net> <4F4484F0.9070501@zytor.com>
 <CA+55aFwUvuaGdnpwVQLQLF=DdqROmKqz65v+_DXHbebNhPqkLg@mail.gmail.com>
 <4F4529D4.6070008@zytor.com> <CA+55aFzKet5sASgrD==8iZ5m1+-FDpznfuqcNDS5ZyCocwzAbg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 22 Feb 2012 10:19:41 -0800
X-Google-Sender-Auth: -Pe_gnixiQ-1IfRloIuQUUtFtnw
Message-ID: <CA+55aFzGyA8QLmri=un4Wm_TnNavCHAMVoY1tfEoA+_UVxT5OA@mail.gmail.com>
Subject: Re: compat: autofs v5 packet size ambiguity - update
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ian Kent <raven@themaw.net>, David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, autofs@vger.kernel.org,
        Thomas Meyer <thomas@m3y3r.de>, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 10:16 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Of course, right now autofs leaks kernel stack way more than that one
> possible alignment word: the whole "name[NAME_MAX+1]" array is leaking
> stuff after the name length (and final zero). So the padding is the
> least of the leaking worries.

Oh, we do have that "memset()" there, and it seems to have been there
since the beginning.

I take all that back. Fixing user space is actually possible.

However, the whole "no regressions" part is that we shouldn't require
updated user space, so we should fix the compat mess in the kernel
regardless.  At which point "fixing user space" becomes irrelevant
again, so ..

                  Linus
