Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644Ab2LWUWK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 15:22:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573Ab2LWUWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 15:22:09 -0500
Date: Sun, 23 Dec 2012 18:21:35 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [Regression w/ patch] Media commit causes user space to
 misbahave (was: Re: Linux 3.8-rc1)
Message-ID: <20121223182135.575cb915@redhat.com>
In-Reply-To: <CA+55aFy98A+LJK4+GWMcbzaa1zsPBRo76q+ioEjbx-uaMKH6Uw@mail.gmail.com>
References: <CA+55aFyd0Wk=hPqiRmk5MMnrwPhse5k1Aih9P-j-Badr7kwhbw@mail.gmail.com>
	<2183382.xv2VGtqdUf@vostro.rjw.lan>
	<20121223120822.233282ba@redhat.com>
	<CA+55aFy98A+LJK4+GWMcbzaa1zsPBRo76q+ioEjbx-uaMKH6Uw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Em Sun, 23 Dec 2012 09:36:15 -0800
Linus Torvalds <torvalds@linux-foundation.org> escreveu:

> To make matters worse, commit f0ed2ce840b3 is clearly total and utter
> CRAP even if it didn't break applications. ENOENT is not a valid error
> return from an ioctl. Never has been, never will be. ENOENT means "No
> such file and directory", and is for path operations. ioctl's are done
> on files that have already been opened, there's no way in hell that
> ENOENT would ever be valid.

Agreed: ENOENT was a bad choice, and it should be reverted.

What I'm trying to understand is why pulseaudio is complaining.
Is it because it only accepts EINVAL error code for media controls?

I'm asking it to Rafael because I'm pretty sure that other drivers
don't return EINVAL when a media control is not available. So, the bug
may already be there, and probably got noticed on 3.8-rc1 because most
notebooks come with UVC cameras installed internally.

> > So, on a first glance, this doesn't sound like a regression,
> > but, instead, it looks tha pulseaudio/tumbleweed has some serious
> > bugs and/or regressions.
> 
> Shut up, Mauro. And I don't _ever_ want to hear that kind of obvious
> garbage and idiocy from a kernel maintainer again. Seriously.

OK.

> I'd wait for Rafael's patch to go through you, but I have another
> error report in my mailbox of all KDE media applications being broken
> by v3.8-rc1, and I bet it's the same kernel bug.

Ouch!

> And you've shown
> yourself to not be competent in this issue, so I'll apply it directly
> and immediately myself.

OK, please apply it.

I suspect however that just applying Rafael's patch may not be enough,
as the bug may still be there affecting all other drivers.

> WE DO NOT BREAK USERSPACE!

I know and I'm doing my best rejecting patches that could potentially
break userspace in advance.

Sometimes shit happens. Sorry for that.

Cheers,
Mauro
