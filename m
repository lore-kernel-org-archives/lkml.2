Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab2DFJOv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 05:14:51 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45808 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822Ab2DFJOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 05:14:49 -0400
Message-ID: <4F7EB406.5020703@linaro.org>
Date: Fri, 06 Apr 2012 13:14:46 +0400
From: Dmitry Antipov <dmitry.antipov@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        linux-man@vger.kernel.org
Subject: Re: [RFC PATCH] hrtimers: system-wide and per-task hrtimer slacks
References: <1329724172-27690-1-git-send-email-dmitry.antipov@linaro.org> <20120404171013.ac08575d.akpm@linux-foundation.org>
In-Reply-To: <20120404171013.ac08575d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2012 04:10 AM, Andrew Morton wrote:

> Well..  there are some back-incompatibilities here.
> prctl(PR_SET_TIMERSLACK, -1) used to restore current's slack setting to
> whatever-we-inherited-at-fork, but that has been removed.  What are the
> implications of this, and did we need to do it?

It seems you're looking at the previous version of this patch
(http://lkml.org/lkml/2012/2/20/55). Latest proposal is
http://lwn.net/Articles/484162/, which defines PR_SET_TIMERSLACK
action as:
...
case PR_SET_TIMERSLACK:
         if (arg2 <= 0)
                 current->timer_slack_ns =
                         default_timer_slack_ns;
         else if (arg2 <= HRTIMER_MAX_SLACK)
                 current->timer_slack_ns = arg2;
         else
                 error = -EINVAL;
         break;
...

> If we do make changes in this area then the prctl manpage should be
> updated, please.  And if
> http://www.spinics.net/lists/linux-man/msg01149.html represents the
> current state of that manpage then it should be updated anyway - that
> entry doesn't say anything about the (arg2<= 0) case.

I sent a patch for man pages too, it should be one of the recent posts
at http://www.spinics.net/lists/linux-man/index.html.

Dmitry


