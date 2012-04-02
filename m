Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab2DBLh7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:37:59 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:59461 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab2DBLh6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:37:58 -0400
MIME-Version: 1.0
In-Reply-To: <CAGZ=bqJ4mAwzuHk5rDbvKTfR_Qi=QiPt6MrwbVhe7H63Yba2Wg@mail.gmail.com>
References: <20120401125741.GA7484@p183.telecom.by> <4F78D0BA.9040709@zytor.com>
 <CAGZ=bqJ4mAwzuHk5rDbvKTfR_Qi=QiPt6MrwbVhe7H63Yba2Wg@mail.gmail.com>
From: Ulrich Drepper <drepper@gmail.com>
Date: Mon, 2 Apr 2012 07:37:37 -0400
Message-ID: <CAOPLpQeJPxD4uVncY5tcheTizZzZ1xbWfwm1BKTqXMH56FP_3w@mail.gmail.com>
Subject: Re: [PATCH] nextfd(2)
To: Kyle Moffett <kyle@moffetthome.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alexey Dobriyan <adobriyan@gmail.com>,
        akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 1, 2012 at 21:19, Kyle Moffett <kyle@moffetthome.net> wrote:
> Well, I imagine one typical usecase for closing all FDs is for
> security isolation purposes (EG: chroot()+etc),

chroot and security in the same sentence...?


> and in a great deal of
> chroot environments you don't have /proc available.  In particular
> /proc has been a source of a lot of privilege escalations in the past,
> so avoiding mounting it in a chroot is good security policy if
> possible.

The problem is that the kernel exports quite a bit of information only
through the /proc and /sys filesystems.  I might try to finish my
comprehensive list of functionality depending on /proc sometime soon.
The list is quite long.

Not mounting /proc is inconvenient at best, it renders the environment
unusable quite often and in some cases is outright insecure..  I don't
think you can use not mounting /proc as an argument.  And, as Peter
said, the loop over the directory content is quite efficient.

If you want to avoid /proc I suggest you first work on removing the
dependencies.  Of just secure /proc itself.
