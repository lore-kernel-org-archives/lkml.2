Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab2JEBj4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 21:39:56 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:34616 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755791Ab2JEBjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 21:39:54 -0400
MIME-Version: 1.0
In-Reply-To: <1349375519.14388.16.camel@twins>
References: <CAAhV-H54CJdg+UekpucZ=kOgCY5r5vvYQ+v4VwAMTCv+mCedXA@mail.gmail.com>
	<20121004174626.GB14301@kroah.com>
	<1349375519.14388.16.camel@twins>
Date: Thu, 4 Oct 2012 18:39:53 -0700
Message-ID: <CAFzf2XxYab=MUdffjR7VtftW=Xv45KQFbd3YSn2ogJpUWf+wqA@mail.gmail.com>
Subject: Re: Seems like "sched: Add missing call to calc_load_exit_idle()"
 should be reverted in 3.5 branch
From: Jonathan Nieder <jrnieder@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Huacai Chen <chenhc@lemote.com>, Charles Wang <muming.wq@taobao.com>,
        Ingo Molnar <mingo@kernel.org>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:

> I can't find wtf went wrong either, the initial patch 5167e8d5417bf5c
> contains both hunks, but in that case the fixup 749c8814f0 doesn't make
> sense, not can I find anything in merge commits using:
>
>   git log -S calc_load_exit_idle kernel/time/tick-sched.c

 git log -m -p --first-parent -Scalc_load_exit_idle -- kernel/time/tick-sched.c

finds 3992c0321258 ("Merge branch 'timers-core-for-linus'",
2012-07-22), which seems to have mismerged 2ac0d98fd624 ("nohz: Make
nohz API agnostic against idle ticks cputime accounting").

Thanks,
Jonathan
