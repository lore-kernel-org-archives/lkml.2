Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928Ab2GRAQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 20:16:26 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:50911 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757922Ab2GRAQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 20:16:13 -0400
Date: Tue, 17 Jul 2012 19:16:07 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [ 11/37] sched/nohz: Rewrite and fix load-avg computation --
 again
Message-ID: <20120718001607.GJ25325@burratino>
References: <20120717232455.GA5994@kroah.com>
 <20120717232431.399005532@linuxfoundation.org>
 <20120717232432.250519502@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120717232432.250519502@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Greg Kroah-Hartman wrote:

> commit 5167e8d5417bf5c322a703d2927daec727ea40dd upstream.
>
> Thanks to Charles Wang for spotting the defects in the current code:
>
>  - If we go idle during the sample window -- after sampling, we get a
>    negative bias because we can negate our own sample.
>
>  - If we wake up during the sample window we get a positive bias
>    because we push the sample to a known active period.
>
> So rewrite the entire nohz load-avg muck once again, now adding
> copious documentation to the code.

I'm thrilled to see this regression fix for stable@, but are we really
really sure that it won't cause new regressions?

Words like "rewrite" set off alarm bells.  As do missing acks:

> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>

(though I guess there's an implied ack from Linus, given that it was
pulled).  And big diffstats:

>  include/linux/sched.h    |    8 +
>  kernel/sched/core.c      |  275 ++++++++++++++++++++++++++++++++++-------------
>  kernel/sched/idle_task.c |    1 
>  kernel/sched/sched.h     |    2 
>  kernel/time/tick-sched.c |    2 
>  5 files changed, 213 insertions(+), 75 deletions(-)

Thanks,
Jonathan
