Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab2LWRgl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 12:36:41 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:63148 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab2LWRgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 12:36:37 -0500
MIME-Version: 1.0
In-Reply-To: <20121223120822.233282ba@redhat.com>
References: <CA+55aFyd0Wk=hPqiRmk5MMnrwPhse5k1Aih9P-j-Badr7kwhbw@mail.gmail.com>
 <2183382.xv2VGtqdUf@vostro.rjw.lan> <20121223120822.233282ba@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 23 Dec 2012 09:36:15 -0800
X-Google-Sender-Auth: Lj_m2FWW-lqp9YvnuHvAsV17rLE
Message-ID: <CA+55aFy98A+LJK4+GWMcbzaa1zsPBRo76q+ioEjbx-uaMKH6Uw@mail.gmail.com>
Subject: Re: [Regression w/ patch] Media commit causes user space to misbahave
 (was: Re: Linux 3.8-rc1)
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 23, 2012 at 6:08 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
>
> Are you saying that pulseaudio is entering on some weird loop if the
> returned value is not -EINVAL? That seems a bug at pulseaudio.

Mauro, SHUT THE FUCK UP!

It's a bug alright - in the kernel. How long have you been a
maintainer? And you *still* haven't learnt the first rule of kernel
maintenance?

If a change results in user programs breaking, it's a bug in the
kernel. We never EVER blame the user programs. How hard can this be to
understand?

To make matters worse, commit f0ed2ce840b3 is clearly total and utter
CRAP even if it didn't break applications. ENOENT is not a valid error
return from an ioctl. Never has been, never will be. ENOENT means "No
such file and directory", and is for path operations. ioctl's are done
on files that have already been opened, there's no way in hell that
ENOENT would ever be valid.

> So, on a first glance, this doesn't sound like a regression,
> but, instead, it looks tha pulseaudio/tumbleweed has some serious
> bugs and/or regressions.

Shut up, Mauro. And I don't _ever_ want to hear that kind of obvious
garbage and idiocy from a kernel maintainer again. Seriously.

I'd wait for Rafael's patch to go through you, but I have another
error report in my mailbox of all KDE media applications being broken
by v3.8-rc1, and I bet it's the same kernel bug. And you've shown
yourself to not be competent in this issue, so I'll apply it directly
and immediately myself.

WE DO NOT BREAK USERSPACE!

Seriously. How hard is this rule to understand? We particularly don't
break user space with TOTAL CRAP. I'm angry, because your whole email
was so _horribly_ wrong, and the patch that broke things was so
obviously crap. The whole patch is incredibly broken shit. It adds an
insane error code (ENOENT), and then because it's so insane, it adds a
few places to fix it up ("ret == -ENOENT ? -EINVAL : ret").

The fact that you then try to make *excuses* for breaking user space,
and blaming some external program that *used* to work, is just
shameful. It's not how we work.

Fix your f*cking "compliance tool", because it is obviously broken.
And fix your approach to kernel programming.

               Linus
