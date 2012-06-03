Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760020Ab2FCDBM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 23:01:12 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:63277 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844Ab2FCDBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 23:01:09 -0400
Message-ID: <4FCAD371.6080205@kernel.org>
Date: Sat, 02 Jun 2012 23:01:05 -0400
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-acpi <linux-acpi@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] ACPI & Power Management Patches for Linux-3.5-merge
References: <4FC9B39B.403@kernel.org> <CA+55aFyGqZnVvd5-ZLUkS=EE72QG1FqempZrs+vBLyCkWP6T_Q@mail.gmail.com>
In-Reply-To: <CA+55aFyGqZnVvd5-ZLUkS=EE72QG1FqempZrs+vBLyCkWP6T_Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2012 07:51 PM, Linus Torvalds wrote:

> On Fri, Jun 1, 2012 at 11:32 PM, Len Brown <lenb@kernel.org> wrote:
>>
>> ps. Sorry for sending this request at the tails of the merge window --
>> I'll try to be earlier next time.
> 
> Christ, not only is it after I really wanted to do -rc1 (held up by
> the tty locking problems), but it doesn't even compile.
> 
> Find the bug (the compiler certainly did):
> 
> static inline int acpi_pm_device_sleep_state(struct device *d, int *p, int m)
> {
>         if (p)
>                 *p = ACPI_STATE_D0;
>         return (m >= ACPI_STATE_D0 && <= ACPI_STATE_D3) ? m : ACPI_STATE_D0;
> }
> 
> and no, it wasn't a merge error. That's what it looks like in your tree.

>

> The commit was done yesterday. It clearly had *zero* testing.

Hmm.

This hunk is in the CONFIG_PM=n case.

Of the several hundred x86_64 and i386 kernels I build
before sending you a pull request, only two do not have CONFIG_PM=y --
x86_64 allnoconfig and i386 allnoconfig.
Like the other kernels, those build fine.

I'm curious what config and compiler tripped on this for you.

> Looking more at the pull as a result of this, I notice that almost
> every commit in that tree is from yesterday, and thus cleary cannot
> have been in -next.


Yes, I did check in Ying's patch this week, and a few others.

But a bunch of the patches have been in linux-next for some time.

I know you'd prefer patches to live in the tree frozen at the
date that they were 1st checked in, but that doesn't work well
when patches change.  To update a patch in a series I need to re-base.
Yes, I could re-base in place -- in the context of an rc
that nobody anywhere (including me) will ever build or boot.
Or I could re-base up to the latest release boundary which
a lot of people (including me) will test.  In this case
I think I re-based everything up to 3.4.

> I was going to just fix up the obvious one-liner

> fixup, but looking at the bigger picture I'm going to say "3.6
> material" for this whole thing.


It would be sad for a simple, though embarrassing,
issue with this patch to delay the other patches.

-Len
