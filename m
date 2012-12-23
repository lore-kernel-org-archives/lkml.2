Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311Ab2LWW32 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 17:29:28 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:40214 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab2LWW3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 17:29:25 -0500
MIME-Version: 1.0
In-Reply-To: <20121223182135.575cb915@redhat.com>
References: <CA+55aFyd0Wk=hPqiRmk5MMnrwPhse5k1Aih9P-j-Badr7kwhbw@mail.gmail.com>
 <2183382.xv2VGtqdUf@vostro.rjw.lan> <20121223120822.233282ba@redhat.com>
 <CA+55aFy98A+LJK4+GWMcbzaa1zsPBRo76q+ioEjbx-uaMKH6Uw@mail.gmail.com> <20121223182135.575cb915@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 23 Dec 2012 14:29:04 -0800
X-Google-Sender-Auth: rcJHgV_-Sqbk84rbQCun0YOG7TI
Message-ID: <CA+55aFzX56kPPwSO97X=UyPaMzV5QRNG9ScN=nxnHFjmz=_8yA@mail.gmail.com>
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

On Sun, Dec 23, 2012 at 12:21 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
>
> Agreed: ENOENT was a bad choice, and it should be reverted.

Well, *any* other error value is likely a bad choice.

> What I'm trying to understand is why pulseaudio is complaining.
> Is it because it only accepts EINVAL error code for media controls?

What I am trying to understand is why you even care, and how you could
*possibly* ever even consider this to be a user-space bug.

Applications *do* care about error return values. There's no way in
hell you can willy-nilly just change them. And if you do change them,
and applications break, there is no way in hell you can then blame the
application.

Yes, I'm upset. Very upset. Why was the error value changed in the
first place? There was no reason given, and it was changed to a
completely idiotic value. And when applications - understandably -
broke, you start asking "why?"

If applications didn't care about specific error values, then it
wouldn't make sense to have more than one to begin with, and you
shouldn't care which one that was. But since applications *do* care,
and since we *do* have multiple error values, we stick to the old
ones, unless there are some *very* good reasons not to.

And those reasons really need to be very good, and spelled out and
explained. In this case, none of that was even remotely the case.

So your question "why would pulseaudio care" is totally *irrelevant*,
senseless, and has nothing to do with anything. Pulseaudio cares, and
caring fundamentally makes sense. It's questioning that obvious fact
that does not make sense!

                   Linus
