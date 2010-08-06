Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935182Ab0HFCKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 22:10:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59286 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760584Ab0HFCKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 22:10:01 -0400
MIME-Version: 1.0
In-Reply-To: <4C5B64EA.2000804@gmail.com>
References: <20100804125156.GA23464@sepie.suse.cz> <AANLkTi=hYsksUJUsrETjFouLDiKhwQHgD2oQ7XLyrOC-@mail.gmail.com> 
	<4C5B64EA.2000804@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 5 Aug 2010 19:08:52 -0700
Message-ID: <AANLkTikpsvpHuB-mWVfmqTRRMvbvhJz2LmoYBgtn4NQE@mail.gmail.com>
Subject: Re: [GIT] kbuild: kconfig changes
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, JBeulich@novell.com, aris@redhat.com,
        catalin.marinas@arm.com, jacmet@sunsite.dk, lizf@cn.fujitsu.com,
        sam@ravnborg.org, ulfalizer.lkml@gmail.com, zippel@linux-m68k.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 5, 2010 at 6:27 PM, Justin P. Mattock
<justinmattock@gmail.com> wrote:
>
> With what I submitted I did not test make oldconfig, only make menuconfig
> due to gcc 4.6.0 giving me a slew of warnings.
> From looking at make oldconfig I do see a more detailed explanation of what
> each option is(last I remember it was more of a line with y/n)but then again
> you could be seeing something completly different.

Just test what I described:  do a "make oldconfig" (do it twice, if
the first one needs to actually get some input). Do it on 2.6.35, and
then on the current tree. Look at the _huge_ difference in output.

> Now if this is with what I submitted then I'll have a look at it and see if I can get this fixed.

I just did a quick git bisect. It's introduced by commit 4062f1a4c030
("kconfig: use long options in conf") by Sam Ravnborg. Apparently that
thing is totally buggy, and doesn't just change the option names, but
actively breaks them.

                 Linus
