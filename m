Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285Ab2FOJoB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 05:44:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755806Ab2FOJoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 05:44:00 -0400
Date: Fri, 15 Jun 2012 11:42:03 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Wagin <avagin@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: general protection fault on finalizing task
Message-ID: <20120615094202.GA16768@redhat.com>
References: <CANaxB-xyBw+O9h7OrFRNM93+Gp+GX63C-OgOZ2ZK2QbKMDBJ7g@mail.gmail.com> <20120614160129.GA3433@redhat.com> <CANaxB-z3Jho4vjRcG30mECYO+CdjwHXX7TmvxCy2A8rp2J7AOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANaxB-z3Jho4vjRcG30mECYO+CdjwHXX7TmvxCy2A8rp2J7AOA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Thanks lot for testing, I guess we need these fixes in 3.5

But I am puzzled...

On 06/15, Andrew Wagin wrote:
>
> FYI: I bisected this problem.
>
> # git bisect bad
> Bisecting: 0 revisions left to test after this (roughly 0 steps)
> [3208450488ae724196f1efffc457e4265957c04e] pidns: use
> task_active_pid_ns in do_notify_parent
>
> commit 3208450488ae724196f1efffc457e4265957c04e
> Author: Eric W. Biederman <ebiederm@xmission.com>
> Date:   Thu May 31 16:26:39 2012 -0700
>
>     pidns: use task_active_pid_ns in do_notify_parent

Impossible ;) I think. I'd say it should be the next change

	00c10bc13cdb58447d6bb2a003afad7bd60f5a5f
	"pidns: make killed children autoreap"

which is fine by itself, but makes the problem (hopefully fixed
by -mm patches) more visible.

Oleg.

