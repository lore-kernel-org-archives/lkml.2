Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab1ERVR3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:17:29 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43305 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149Ab1ERVR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:17:27 -0400
Date: Wed, 18 May 2011 23:17:23 +0200
From: Borislav Petkov <bp@alien8.de>
To: James <bjlockie@lockie.ca>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org
Subject: Re: help to bisect
Message-ID: <20110518211723.GA4313@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	James <bjlockie@lockie.ca>,
	Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org
References: <4DD31264.4070704@lockie.ca>
 <20110518072245.GB17608@liondog.tnic>
 <4DD42F10.90602@lockie.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4DD42F10.90602@lockie.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First of all, please hit "reply-to-all" next time so that all recipients
can receive your mail and not find it by chance when looking thru the
new lkml messages.

On Wed, May 18, 2011 at 04:41:52PM -0400, James wrote:
> Here is what I did:
> 
> $ git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.37.y.git
> $ cd linux-2.6.37.y
> $ git checkout v2.6.36
> build and boot kernel

what does that mean? Is .36 ok?

> $ cd linux-2.6.37.y
> $ git bisect start
> $ git bisect good v2.6.36
> $ git bisect bad v2.6.37.6

Also, is .37.6 bad?

> 
> build and boot kernel
> git bisect good|bad
> repeat
> 
> 3044100e58c84e133791c8b60a2f5bef69d732e4 is the first bad commit.

Which is a merge commit and it means that you most likely made a mistake
during bisection.

What is actually the problem you're experiencing with .37.6?

..

> How do I find out what change causes the problem?
> The problem causes my wireless card not to work.

Ah, here it is.

> Other people have similar cards that do work so the problem seems
> isolated to my hardware but kernel-2.6.36 works so I don't think my
> hardware is faulty.

Which card is that? (adding linux-wireless)

Please, describe in a very detailed way how your problem incarnates
itself: dmesg, error messages, what exactly do you do to trigger it?

Also, can you test whether 38.6 works for ya - it could've been fixed in
the meantime. You can also test .39 which will be released any minute
now.

I think that should be enough for now.

-- 
Regards/Gruss,
    Boris.
