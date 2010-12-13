Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062Ab0LMPJp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 10:09:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42159 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758051Ab0LMPJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 10:09:43 -0500
Date: Mon, 13 Dec 2010 10:09:09 -0500
From: Don Zickus <dzickus@redhat.com>
To: =?iso-8859-1?Q?CS=C9CSY_L=E1szl=F3?= <boobaa@frugalware.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, gorcunov@gmail.com,
        aris@redhat.com, peterz@infradead.org, Ingo Molnar <mingo@elte.hu>,
        VAJNA =?iso-8859-1?Q?Mikl=F3s?= <vmiklos@frugalware.org>,
        linux-kernel@vger.kernel.org
Subject: Re: 2.6.36 does not boot properly
Message-ID: <20101213150909.GC18577@redhat.com>
References: <201012130019.41234.boobaa@frugalware.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201012130019.41234.boobaa@frugalware.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 12:19:40AM +0100, CSÉCSY László wrote:

Hell Csecsy,

> Additional info:
> 
> The first "bad" build while bisecting caused the above-mentioned freeze, but 
> the latest 4 were all panicking immediately after boot - here is the 
> "screenshot" I created with my camera:

I find it odd that commit would be the cause of a kernel freeze that early
in boot.  But I did try to do a git log between your last known good
commit and bad commit.  The output was just the bad commit.

[dzickus@ihatethathostname upstream]$ git log --oneline
93736624635235cc5372ffca6d62816d02170724..e40b17208b6805be50ffe891878662b6076206b9
e40b172 x86: Move notify_die from nmi.c to traps.c
[dzickus@ihatethathostname upstream]$

Though a git log on the bad commit showed other commits I thought would
have popped out before the intersection with the good commit.

Just for my sanity could you do a 'git revert
e40b17208b6805be50ffe891878662b6076206b9' and try that kernel.  I would
think it would still fail, but if it does boot then I need to do some
serious head scratching.

Cheers,
Don
