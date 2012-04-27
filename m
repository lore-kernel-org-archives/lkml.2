Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761286Ab2D0TPE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 15:15:04 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:44917 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760458Ab2D0TPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 15:15:02 -0400
Date: Fri, 27 Apr 2012 15:14:33 -0400 (EDT)
Message-Id: <20120427.151433.1007849975903946491.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: mjt@tls.msk.ru, linux-kernel@vger.kernel.org, autofs@vger.kernel.org,
        raven@themaw.net, thomas@m3y3r.de, stable@kernel.org
Subject: Re: [PATCH v2] Introduce a version6 of autofs interface, to fix
 design error.
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+55aFyLk-uPMVaic19YOWdvdj2pv4R+E3s7UQ6voAy6UkO_Sg@mail.gmail.com>
References: <20120427.143402.1028957981042061092.davem@davemloft.net>
	<CA+55aFwvFaxBT8Mdp5s4-6Gxy7nM4WVzbWna4RF_OUK3hnx+jQ@mail.gmail.com>
	<CA+55aFyLk-uPMVaic19YOWdvdj2pv4R+E3s7UQ6voAy6UkO_Sg@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 27 Apr 2012 12:14:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 27 Apr 2012 11:55:12 -0700

> On Fri, Apr 27, 2012 at 11:42 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> There's no question that systemd is broken.
> 
> Actually, I'll take that back.
> 
> Yes, systemd has breakage. But it's actually automount that is the
> truly broken piece of sh*t.
> 
> I think that 'automount' is even more broken. The fact that the
> automount maintainers knew about this, and added TOTALLY BROKEN code
> to their automount source tree, over five years ago, because the
> authors clearly did not understand what the f*ck they were doing,
> that's the real problem.

I respectfully disagree.

It's ugly as shit, but it is the only one place where one can be
absolutely sure that we are dealing with a pipe passing those v5
things around.

All these hacks we have been talking about, assuming the mount means
the pipe is for passing structure so-and-so around, and now trying
to find some other check such as one on current->comm...

That's better?

Only the application really knows.  And I bet the person who wrote
that automountd code you find so distasteful analyzed this and came
to realize how difficult the kernel side would be to get right.

So they decided that the datastructure on 32-bit changes based upon
whether we run on a 64-bit kernel or not, that's the interface the
kernel has always exported, and therefore that's the interface it
choose to use.
