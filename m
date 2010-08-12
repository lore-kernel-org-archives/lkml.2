Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759068Ab0HLVCR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 17:02:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32905 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754924Ab0HLVCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 17:02:16 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTi=Sh=4mmV2B_VsQw-1+jHzf2jWZsYQkJmqWwms+@mail.gmail.com>
References: <201008122200.05598.thomas@m3y3r.de> <AANLkTikZ4wA4jJ0AnWMXYmgWVBShRW=Yu67J0QvebRx0@mail.gmail.com>
 <AANLkTi=Sh=4mmV2B_VsQw-1+jHzf2jWZsYQkJmqWwms+@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 Aug 2010 14:01:50 -0700
Message-ID: <AANLkTimr_S3rtg50wOh+H4yybn_U6Ru3=rbt5FjYWpD3@mail.gmail.com>
Subject: Re: 2.6.36: Sound stop working
To: Pekka Enberg <penberg@kernel.org>, Eric Paris <eparis@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: Thomas Meyer <thomas@m3y3r.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 1:20 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So I suspect it's not sound that is broken at all, but pulseaudio that
> got broken by the fanotify changes.

Confirmed. That broken commit 3bcf3860a4ff9bb doesn't even boot for me
(looks like a stack smash recursion), and the commit to "fix" it
(c1e5c954020e12) is really too ugly to live.

I think we need to totally undo the whole "struct file" thing, and
just admit that it was a mistake. The code really wants a "struct
path", and using a struct file screws up all the refcounting and is
just not right.

The fact that dentry_open() may have some problem needs to be fixed
-there- rather than make the callers do crazy things that they don't
want to do and can't do sanely.

                           Linus
