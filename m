Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab1A1Sqh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 13:46:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41455 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754039Ab1A1Sqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 13:46:36 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Tejun Heo <tj@kernel.org>
X-Fcc: ~/Mail/linus
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 02/10] ptrace: remove the extra wake_up_process() from ptrace_detach()
In-Reply-To: Tejun Heo's message of  Friday, 28 January 2011 16:08:36 +0100 <1296227324-25295-3-git-send-email-tj@kernel.org>
References: <1296227324-25295-1-git-send-email-tj@kernel.org>
	<1296227324-25295-3-git-send-email-tj@kernel.org>
X-Zippy-Says: Toes, knees, NIPPLES.  Toes, knees, nipples, KNUCKLES...  Nipples,
    dimples, knuckles, NICKLES, wrinkles, pimples!!  I don't like
    FRANK SINATRA or his CHILDREN.
Message-Id: <20110128184601.CBF7C180996@magilla.sf.frob.com>
Date: Fri, 28 Jan 2011 10:46:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NAK.  Let's have the wake_up_state(task, TASK_TRACED|TASK_STOPPED) version
go in first.  That one will be more appropriate for -stable.  Even if we
shortly remove it entirely in mainline, having the more conservative
intermediate state in the git history will make any future problems more
susceptible to bisection.

Thanks,
Roland
