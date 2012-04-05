Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462Ab2DEAKR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 20:10:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44364 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757399Ab2DEAKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 20:10:15 -0400
Date: Wed, 4 Apr 2012 17:10:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Antipov <dmitry.antipov@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        linux-man@vger.kernel.org
Subject: Re: [RFC PATCH] hrtimers: system-wide and per-task hrtimer slacks
Message-Id: <20120404171013.ac08575d.akpm@linux-foundation.org>
In-Reply-To: <1329724172-27690-1-git-send-email-dmitry.antipov@linaro.org>
References: <1329724172-27690-1-git-send-email-dmitry.antipov@linaro.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Feb 2012 11:49:32 +0400
Dmitry Antipov <dmitry.antipov@linaro.org> wrote:

> This patch proposes a system-wide sysctl-aware default for the
> high-resolution timer slack value, which may be changed from 0
> to HRTIMER_MAX_SLACK nanoseconds. Default system-wide and per-task
> values are HRTIMER_DEFAULT_SLACK. Per-task value isn't inherited
> across fork(); instead, newborn task uses system-wide value by
> default, and newborn thread uses it's group leader value.

Well..  there are some back-incompatibilities here. 
prctl(PR_SET_TIMERSLACK, -1) used to restore current's slack setting to
whatever-we-inherited-at-fork, but that has been removed.  What are the
implications of this, and did we need to do it?

If we do make changes in this area then the prctl manpage should be
updated, please.  And if
http://www.spinics.net/lists/linux-man/msg01149.html represents the
current state of that manpage then it should be updated anyway - that
entry doesn't say anything about the (arg2 <= 0) case.


