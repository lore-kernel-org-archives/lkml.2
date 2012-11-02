Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab2KBVHO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 17:07:14 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:36123 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab2KBVHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 17:07:11 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <CA+55aFxm0D77c0RYJuAiq2EDJxn+hGKTEGYJnHXNM8XkVAYOTA@mail.gmail.com>
References: <CA+55aFwwTc4QXKqiECgE9NOE2zjC6GsGHHydGP9YDbgQSbw9Aw@mail.gmail.com>
	<26004880.qboZkUVCy9@vostro.rjw.lan>
	<CA+55aFxm0D77c0RYJuAiq2EDJxn+hGKTEGYJnHXNM8XkVAYOTA@mail.gmail.com>
Date: Fri, 2 Nov 2012 22:07:10 +0100
Message-ID: <CAKMK7uEgnpTET0_VXWm7JyGePnXL-q_nHgSWq4g=qWodwrg38Q@mail.gmail.com>
Subject: Re: Linux 3.7-rc3
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Airlie <airlied@linux.ie>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 2, 2012 at 9:25 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Oct 29, 2012 at 5:10 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>
>> Unfortunately, s2disk is broken with this one and previous -rc.  In the
>> majority of cases it just hangs the machine during hibernation, although
>> sometimes it returns to user space reporting freezing problems, suspicions
>> RCU usage and similar stuff, pretty much without any useful debug information.
>
> Ugh. I was hoping that we'd get more reports on this, right now
> there's not enough information to even make a guess about what's up.
>
> I also note that no actual i915 people were cc'd, despite your
> graphics driver suspect. Adding Daniel and Dave (one of the millions)
> to the cc since they probably do have lkml but probably don't react
> unless something gets pointed out.
>
> Daniel/Dave, do you have any reports of hibernation failing (or VT
> switching problems) with i915 after 3.6?

Not that I've heard of. We did though rewrite the entire modeset
sequence driving code in i915 for 3.7, removing massive amounts of
hacks and stupid "let's disable/enable things harder" code simply
because the old code couldn't keep track of the hw state well enough.
So I wouldn't be surprised at all if that unearthed a hidden bug
somewhere, but we've also added ridiculous amounts of self-checks. And
thus far they caught all issues due to that rework (and some ancient
bugs on top) when either the i915 driver or the bios did something
nefarious ...

I've rechecked the git log and otherwise there's nothing else which
pops up that would fit VT-switching/hibernate going bad but the
modeset rework.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
