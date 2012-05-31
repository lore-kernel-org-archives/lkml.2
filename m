Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606Ab2EaA4P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 20:56:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59751 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757553Ab2EaA4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 20:56:11 -0400
Date: Thu, 31 May 2012 01:56:07 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Paris <eparis@parisplace.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@us.ibm.com>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: fix IMA lockdep circular locking dependency
Message-ID: <20120531005607.GB11775@ZenIV.linux.org.uk>
References: <20120530163605.GV11775@ZenIV.linux.org.uk>
 <1338406967.2257.24.camel@localhost>
 <20120530202427.GW11775@ZenIV.linux.org.uk>
 <CA+55aFxiCksfNdRrm+O-eJSY=qTUQEsZtFbi8wj2_kj1XeNHnQ@mail.gmail.com>
 <20120530205612.GY11775@ZenIV.linux.org.uk>
 <CA+55aFwXfD6vCj8sHuB33ctB-D8cfJN45h+iURXA6mR=S0mgwA@mail.gmail.com>
 <20120530213638.GZ11775@ZenIV.linux.org.uk>
 <CA+55aFzP8Eo1AX7MS-RRG_Atq3NF0bS1ReZydRtgxxy7TDn57Q@mail.gmail.com>
 <20120531002802.GA11775@ZenIV.linux.org.uk>
 <CA+55aFzDeZQeFY1i1xLES4ijtDeGBk3EBOh-mA0dhEH2yaGf9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzDeZQeFY1i1xLES4ijtDeGBk3EBOh-mA0dhEH2yaGf9A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 05:40:54PM -0700, Linus Torvalds wrote:
> On Wed, May 30, 2012 at 5:28 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > FWIW, I think it's cleaner to take the whole thing into an inlined helper.
> 
> Even better.
> 
> I notice that your inlined helper doesn't do what I did: if PROT_EXEC
> is already set, stop all the stupid games. IOW, the first test in that
> function could as well be
> 
>     if (prot & (PROT_READ | PROT_EXEC) != PROT_READ)
>         return prot;
> 
> because if PROT_EXEC is already set, or if PROT_READ wasn't set, none
> of the rest of the checks make any sense at all.

Point...  OK, done, pushed and the whole thing thrown into #for-next.
Probably too late for today's linux-next, but tomorrow one should pick
that.  BTW, tomorrow there'll be a signal.git pull request as well,
with task_work_add() series in it.

Now for the Miklos' stuff...
