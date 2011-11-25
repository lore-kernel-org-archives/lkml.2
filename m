Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547Ab1KYQ1O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 11:27:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571Ab1KYQ1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 11:27:13 -0500
Date: Fri, 25 Nov 2011 17:22:20 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Tejun Heo <tj@kernel.org>, Pedro Alves <pedro@codesourcery.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        James Bottomley <jbottomley@parallels.com>
Subject: Re: [RFC][PATCH 0/3] fork: Add the ability to create tasks with
	given pids
Message-ID: <20111125162220.GA17173@redhat.com>
References: <4EC4F2FB.408@parallels.com> <201111221204.39235.pedro@codesourcery.com> <20111122153326.GD322@google.com> <201111231620.45440.pedro@codesourcery.com> <20111123162417.GE25780@google.com> <4ECD3946.1030503@parallels.com> <4ECD542C.7010705@parallels.com> <20111124173121.GA23260@redhat.com> <4ECF6AA0.80006@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ECF6AA0.80006@parallels.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25, Pavel Emelyanov wrote:
>
> The proposal is to implement the PR_RESERVE_PID prctl which allocates and puts a
> pid on the current. The subsequent fork() uses this pid,

Oh. This is subjective, yes, but this doesn't clean to me.

Amd why?? On the running system PR_RESERVE_PID can obviously fail anyway.
It only helps to avoid the race with another fork.

>  * one more field on struct pid is OK, since it size doesn't change (32 bit level is
>    anyway not required, it's OK to reduce on down to 16 bits)

Even if sizeof is the same, the new member and the code which plays
with ->flags doesn't make the things better ;)

>  * yes, we have +1 member on task_struct :(

Yes, and this task_struct->rsv_pid acts as implicit parameter for the
next clone(). Doesn't look very nice to me. Plus the code complications.

> Oleg, Tejun, do you agree with such an approach?

If set_last_pid doesn't work, I'd prefer CLONE_CHILD_USEPIDS.

Oleg.

