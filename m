Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902Ab1H1SY4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 14:24:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394Ab1H1SYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 14:24:50 -0400
Date: Sun, 28 Aug 2011 20:21:24 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, paul@paulmenage.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de
Subject: Re: [PATCH 08/16] freezer: use dedicated lock instead of
	task_lock() + memory barrier
Message-ID: <20110828182124.GE27032@redhat.com>
References: <1313763382-12341-1-git-send-email-tj@kernel.org> <1313763382-12341-9-git-send-email-tj@kernel.org> <20110828175116.GA27032@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110828175116.GA27032@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28, Oleg Nesterov wrote:
>
> Off-topic, but fake_signal_wake_up() is not safe if the caller
> try_to_freeze_cgroup(). Unlike try_to_freeze_tasks() (which holds
> tasklist) we can race with the exiting thread, ->sighand can be
> NULL.

Although with PF_NOFREEZE in do_exit() from 6/16, this race is only
theoretical.

And, forgot to mention, __thaw_task() looks racy too, but i think
this recalc_sigpending_and_wake() can simply go away.

Oleg.

