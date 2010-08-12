Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934020Ab0HLVvQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 17:51:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43185 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760889Ab0HLVvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 17:51:15 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTi=s-KFuUnmNaDN6OYaiwZiaBLbYB5MCwde7tvvw@mail.gmail.com>
References: <201008122200.05598.thomas@m3y3r.de> <AANLkTikZ4wA4jJ0AnWMXYmgWVBShRW=Yu67J0QvebRx0@mail.gmail.com>
 <s5hpqxntw64.wl%tiwai@suse.de> <4C646110.1040104@gmail.com>
 <s5hbp97ttt5.wl%tiwai@suse.de> <AANLkTi=s-KFuUnmNaDN6OYaiwZiaBLbYB5MCwde7tvvw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 Aug 2010 14:50:16 -0700
Message-ID: <AANLkTikudWaowKOJ0Qxd1hGKcZiQ8PCeJm+pgXBm7Vc2@mail.gmail.com>
Subject: Re: 2.6.36: Sound stop working
To: Takashi Iwai <tiwai@suse.de>, Eric Paris <eparis@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: Jiri Slaby <jirislaby@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        Thomas Meyer <thomas@m3y3r.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 2:41 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Al, what was the problem that caused you to think that we want to have
> a 'struct file' here? Is it just the fact that some of those fsnotify
> things use that 'path' structure that is embedded in the parent? But
> isn't the simplest fix for that to just _copy_ the "struct path"
> rather than pass the "struct file" around?

Btw, that's exactly what the fsnotify code does seem to do, in
fsnotify_create_event(). So as far as I can tell, it's all ok - we
only use that file->f_path pointer while we hold the file open, and
then we copy it to event->path and increment the counts properly.

Of course, maybe I'm missing some other case where we _don't_ copy the
data, and pass a pointer to a file->f_path around that could get
stale. Or maybe I'm missing some other worry entirely.

But those games with f_count are just disgusting. The path-based thing
seems to be much more straightforward.

                              Linus
