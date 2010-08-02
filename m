Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351Ab0HBQ7r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 12:59:47 -0400
Received: from smtp.outflux.net ([198.145.64.163]:39801 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137Ab0HBQ7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 12:59:46 -0400
Date: Mon, 2 Aug 2010 09:59:36 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@ftp.linux.org.uk>
Subject: Re: Preview of changes to the Security susbystem for 2.6.36
Message-ID: <20100802165936.GV3948@outflux.net>
References: <alpine.LRH.2.00.1007301852110.14431@tundra.namei.org>
 <alpine.LRH.2.00.1008021216520.31941@tundra.namei.org>
 <20100802122421.GA12130@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100802122421.GA12130@infradead.org>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Mon, Aug 02, 2010 at 08:24:21AM -0400, Christoph Hellwig wrote:
> As mentioned a few times during the past discussion moving broken
> code into a LSM doesn't magically fix it.  In fact YAMA is not any kind
> of (semi-)coherent security policy like Selinux, smack or similar but
> just a random set of hacks that you didn't get past the subsystem
> maintainers.

I would love to have these "hacks" in the subsystem directly. But no one
has stepped forward to decode Al Viro's hints.

I'm getting pretty tired of moving this logic back and forth between the
subsystems and an LSM. You yourself told me to put these things in an
LSM[1], and yet now you're saying I shouldn't.

> Al gave you some very clear advice how a the sticky check should be

This is patently false. "Very clear advice" would have included actionable
instructions. He (and everyone else) has ignored my requests for
clarification[2]. If you see how the check should be implemented, please
send a patch demonstrating how. I would greatly prefer having these
protections in the VFS itself.

> done for symlinks (if we need it at all, which I tend to disagree with),

I can see how one might disagree with it, but anyone who handles day-to-day
security threats understands this protection to be a clear and obvious
solution for the past decade.

> and the ptrace check completely breaks crash handlers that we have
> in all kinds of applications.  If you can get it into the main ptrace

I've seen two so far. Both are addressed with a one line fix. And I would
stress that no other existing subsystem in the kernel can provide the same
level of control that my ptrace exception logic provides. SELinux cannot do
this.

> code past Roland and Oleg that's fine, but just pushing it out into
> a tree that has percieved easier merge criteria doesn't work.

This advice is precisely counter to prior advise. It would seem that no one
knows how to handle these patches. I find it very simple; either:
 - let me put them in an LSM that people can choose to enable
 - help me get the patches into shape for the subsystems directly

Since the latter has been repeatedly denied, the former was suggested to
me, which I implemented. The option "give up" is not available to me.
Perhaps there is another option I could choose from so I can get these
protections into the mainline kernel?

-Kees

[1] http://lkml.org/lkml/2010/6/1/78
[2] http://lkml.org/lkml/2010/6/4/44

-- 
Kees Cook
Ubuntu Security Team
