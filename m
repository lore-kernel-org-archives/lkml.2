Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769Ab0JVSj2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:39:28 -0400
Received: from claw.goop.org ([74.207.240.146]:51228 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757263Ab0JVSjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:39:25 -0400
Message-ID: <4CC1DA58.8000606@goop.org>
Date: Fri, 22 Oct 2010 11:39:20 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Xen Devel <Xen-devel@lists.xensource.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gianluca Guida <gianluca.guida@citrix.com>,
        Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: linux-next: manual merge of the xen tree with the tip tree
References: <20101022140335.c4a3a48f.sfr@canb.auug.org.au> <20101022080129.GA8474@elte.hu>
In-Reply-To: <20101022080129.GA8474@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 10/22/2010 01:01 AM, Ingo Molnar wrote:
> * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
>> Hi all,
>>
>> Today's linux-next merge of the xen tree got a conflict in
>> arch/x86/mm/init_32.c between commit
>> 1d931264af0f10649b35afa8fbd2e169da51ac08 ("x86-32, memblock: Make
>> add_highpages honor early reserved ranges") from the tip tree and commit
>> 07147a06ac3b1b028124ea00ba44e69eb8ea7685 ("x86/32: honor reservations of
>> high memory") from the xen tree.
> Jeremy,
>
> Commit 07147a06ac is all over the x86 tree:
>
>   arch/x86/mm/init_32.c     |   42 ++++++++++++++++++++++++++++++++----------
>   include/linux/early_res.h |    3 +++
>   kernel/early_res.c        |   30 ++++++++++++++++++++++++++++++
>   3 files changed, 65 insertions(+), 10 deletions(-)
>
> ... but there's no x86 person who acked it or was Cc:-ed to this commit AFAICS. It 
> was not even posted to lkml! Nor does the commit title suggest that it affects core 
> kernel code as well.
>
> Also, the AuthorDate field is a total lie:
>
>   commit 07147a06ac3b1b028124ea00ba44e69eb8ea7685
>   Author:     Gianluca Guida <gianluca.guida@citrix.com>
>   AuthorDate: Sun Aug 2 01:25:48 2009 +0100
>   Commit:     Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>   CommitDate: Mon Oct 4 14:22:11 2010 -0700
>
>     x86/32: honor reservations of high memory
>
> This commit was written on Aug 2 2009, really? kernel/early_res.c, which is modified 
> by half of this commit, was _CREATED_ in February 2010 ...

Most of the code in early_res.c was simply moved from
arch/x86/.../e820.c, so the patch chunks were applied to the new file
when the code was moved.

> I realize that some original patch, much different from this one, was probably 
> written in 2009, and that via a series of undocumented rebases and modifications to 
> the patch you achieved this state.

The modified code was almost entirely unchanged over that period, so the
datestamp and original authorship of the patch was basically correct.

However...

> Crap like that is just _NOT_ acceptable, and you know that perfectly well - if you 
> do this to arch/x86/ i'll be forced to ask for the Xen tree to be removed from 
> linux-next and be done via the x86 tree again.

Hey, hey, hold your horses.  This is a wildly obsolete patch that we
were discussing a few weeks ago, but Yinghai did a proper alternative
for the memblock universe.

It was never in linux-next, and never intended to be.  I'm not sure why
it has appeared in linux-next now; it isn't in my branch.  I wonder if
it appeared in another Xen-related branch.  Let me investigate.

    J
