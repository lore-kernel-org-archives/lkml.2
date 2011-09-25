Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab1IYJm1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 05:42:27 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51721 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762Ab1IYJm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 05:42:26 -0400
Date: Sun, 25 Sep 2011 11:42:22 +0200
From: Borislav Petkov <bp@alien8.de>
To: Wizard <wizarddewhite@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: Seems the comment of find_next_system_ram() is not exact
Message-ID: <20110925094222.GA11289@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Wizard <wizarddewhite@gmail.com>, linux-kernel@vger.kernel.org,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
References: <CAOkaeLJTeewFWpHCVBqNwmuL7nEbFYnrQ86SQOO7fVg_Uc3Q4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAOkaeLJTeewFWpHCVBqNwmuL7nEbFYnrQ86SQOO7fVg_Uc3Q4Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 24, 2011 at 09:40:52PM +0800, Wizard wrote:
> Hi, Experts
> 
> I am a newbie for linux kernel. I just read the code of
> find_next_system_ram() in kernel/resource.c
> 
> I think the comment of this function is not exact. This says "Finds
> the lowest memory reosurce exists within [res->start.res->end)".
> 
> While I think the code is to find the lowest memory resource overlaps
> [res->start, res->end).
> 
> 308:      if ((p->end >= start) && (p->start < end))
> 
> If I am not correct, please let me know. :)

Right,

hint for the future, do a "git annotate" on the file containing that
code - the patch adding the piece of code might (err, and should!) have
a verbose commit message explaining the situation. And it seems it does
have something to a degree, here's another hint:

58c1b5b079071

:-)

But I agree that the comment over the function could use some more
verbosity on why the function needs to handle overlapping resources and
sections. Let's ask the author.

> BTW, I find the "reosurce" is a typo.

Yes, he could fix it while explaining the overlap :-).

HTH.

-- 
Regards/Gruss,
    Boris.
