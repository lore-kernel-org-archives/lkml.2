Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760114Ab0FKKlq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 06:41:46 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38697 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab0FKKlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 06:41:45 -0400
To: Howard Chu <hyc@symas.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: EXTPROC, telnetd LINEMODE, revisited
From: Andi Kleen <andi@firstfloor.org>
References: <4C120D8A.8050207@symas.com>
Date: Fri, 11 Jun 2010 12:41:40 +0200
In-Reply-To: <4C120D8A.8050207@symas.com> (Howard Chu's message of "Fri\, 11 Jun 2010 03\:18\:50 -0700")
Message-ID: <87631pq2aj.fsf@basil.nowhere.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Howard Chu <hyc@symas.com> writes:

> It's been over 10 years since I looked at this last
>
> http://lkml.indiana.edu/hypermail/linux/kernel/9911.3/0650.html

I would suggest you repost the patch.

>From a quick look it looks straight forward enough.

> Despite the fact that most people today have ready access to high
> speed broadband networking today, I think the motivation for local
> character processing is as great now as it was 10 years ago. I
> regularly use an ssh client on an Android phone to keep tabs on my
> servers when I'm away from my home base, and sometimes cellphone
> connectivity can be extremely lossy, networks can be heavily
> congested, etc... Waiting for character-at-a-time packet turnarounds
> in these conditions can be pretty aggravating. Also, if you're

I agree that it would be sometimes useful, I also had these
problems.

> unfortunate enough to need to get access to a machine while you're
> roaming away from your home network, the per-byte roaming fees can be
> murder. Both of these pain points can be minimized by using local
> character processing and only sending complete lines to the remote
> server.

I have some doubts this really needs to be implemented in the kernel.
Back in the old days it was important to save round trips
to user space because CPUs were so slow, but these days I don't think 
that's an issue anymore for mere typing.

Couldn't you implement it in screen or a similar pty based tool?

>
> Another feature with readline is a command history buffer that can be
> reviewed using Cursor Up/Down. Can/should we define this in the tty
> driver too? Or perhaps rely on the client to implement its own command
> buffer, and never mention this aspect on the wire protocol. Again,
> given the purpose, it makes most sense to me to keep this feature on
> the client side. But some coordination with the server would still be
> useful. E.g., different programs can maintain their own persistent
> command history files. It might be nice to have a way for the app to
> signal to the client which command context to use for the current
> history buffer, and keep them all separate. (Or not, I can see other
> times where you'd just rather have it all as one stack.)

e.g. history management is definitely something that should not
be done in the kernel.

> PS: if anyone knows where to send the patches for telnetd, please
> email me. Looks like the upstream source hasn't been touched since
> 2000.

I think they're defacto maintained by the distributions.

I would submit them to one of the big distributions and let
that maintainer figure it out.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
