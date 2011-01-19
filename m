Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab1ASS1K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 13:27:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34159 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751698Ab1ASS1I convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 13:27:08 -0500
MIME-Version: 1.0
In-Reply-To: <20110119180735.GA9752@home.goodmis.org>
References: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com>
 <AANLkTimp0UcWi68N5Jv_hUww9PhGVgCzY0qYLETc8Dj_@mail.gmail.com>
 <1161CC5A-C8CA-477E-B2CE-7870F8E634EE@gmail.com> <AANLkTin+Div6HoAJdFOfqRFSMyxqx7ft7mcteXomaV_Y@mail.gmail.com>
 <20110119051049.GA2536@WALL-E> <AANLkTikdCek7DGN885Cjuo1nkswe_Y8KG6Knn8XknzsF@mail.gmail.com>
 <AANLkTikV6=FCQ+-Z=fAi8SH90M-izCUEBisinqGwo=DU@mail.gmail.com> <20110119180735.GA9752@home.goodmis.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 19 Jan 2011 10:26:15 -0800
Message-ID: <AANLkTinYk-xAk==1wtYy-XjVe-SGbZn-wiAK19Yj0jyr@mail.gmail.com>
Subject: Re: Linux 2.6.38-rc1
To: Steven Rostedt <rostedt@goodmis.org>
Cc: nobody <darwinskernel@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 10:07 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> When I first started using git (2006?) I was recommended to use "-k"
> when doing a fetch or pull. I don't even remember why it was
> recommended. I still do it, but is it necessary?
>
> All the help says is:
>
>       -k, --keep
>                  Keep downloaded pack.

That's a different issue. That marks the resulting pack for "keeping",
which means that it won't participate in garbage collection.

IOW, it's a bad idea.

There _is_ a reason for it, namely that if your machine is really
slow, you may want to mark big packs for keeping, so that when you do
a gc it will be cheaper to do. In particular, the initial clone/fetch
may well be worth marking "keep". But even that is really only worth
it if you have such a slow machine (or the machine has too little
memory) that repacking is really a big pain (it's not like you need to
do gc very often - once a week would be overkill for most projects).

(There can be other reasons to mark packs as "keep" - namely to help
with http/rsync of the resulting archive if you have a huge amount of
history. In that case, it might be worthwhile keeping historical data
as a "keep" pack, so that rsync/http don't need to re-fetch it after a
GC or repack event.)

                           Linus
