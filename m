Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410Ab1LFQot (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 11:44:49 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64390 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab1LFQos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 11:44:48 -0500
MIME-Version: 1.0
In-Reply-To: <CAPM=9twbX+eDG=DE8FSU7HUoe1dQ=9bx1QQw5T6nKAjQdSgi4w@mail.gmail.com>
References: <alpine.DEB.2.00.1112061619190.11925@skynet.skynet.ie>
 <CA+55aFyFar45vTWb33FnJ1xv4zT+9XfnKBs=Xwx6-5O-RBHO4Q@mail.gmail.com> <CAPM=9twbX+eDG=DE8FSU7HUoe1dQ=9bx1QQw5T6nKAjQdSgi4w@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 6 Dec 2011 08:44:26 -0800
X-Google-Sender-Auth: g7RIaPE36QzEgumAiODDhnDt6rU
Message-ID: <CA+55aFx+qUuPh7kRXVqMXeE-yZY+LddnqOFiVp3MkVuwvNnnKw@mail.gmail.com>
Subject: Re: [git pull] drm fixes
To: Dave Airlie <airlied@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 6, 2011 at 8:36 AM, Dave Airlie <airlied@gmail.com> wrote:
>
> Well I do care about kexec but only due to being forced into caring
> about it for a certain enterprise distro that uses it a lot, so maybe
> I was a bit biased in this case, and I dislike random memory
> corruptions due to my subsystem even in the kexec case. Writing a
> random 0 dword somewhere in memory isn't that pretty and no fun to
> track down, when the kexec looks like it succeeds.

So having looked at the patch itself, I don't dislike the notion of
making sure certain fields are nicely initialized. So I don't hate the
patch itself, but quite frankly, to me it doesn't smell even
*remotely* like "regression fix". I don't think this is something that
has ever worked.

And I do realize that some enterprise distros want to use kexec, but
at the same time I say "that's *their* problem". We know kexec hasn't
been horribly reliable, anybody who uses it should have be taking that
into account.

I hope kexec gets more reliable, but I *also* really hope that our RC
series will calm down, and on the whole, weighing the two concerns,
when we're talking about something that has never worked before
either, I think the thing is pretty clear.

That said, if there is some other real use-case ("this fixes problems
with the BIOS from Xyz initializing things to random crap"), I'd have
no real objections to the patch itself.

So my complaint is really a "I want to be more anal about the later
-rc patches, I feel we're slipping", not a "I hate the patch per se".

                          Linus
