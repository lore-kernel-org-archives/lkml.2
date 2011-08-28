Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836Ab1H1Ryr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 13:54:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980Ab1H1Ryn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 13:54:43 -0400
Date: Sun, 28 Aug 2011 19:51:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, paul@paulmenage.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de
Subject: Re: [PATCH 08/16] freezer: use dedicated lock instead of
	task_lock() + memory barrier
Message-ID: <20110828175116.GA27032@redhat.com>
References: <1313763382-12341-1-git-send-email-tj@kernel.org> <1313763382-12341-9-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313763382-12341-9-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19, Tejun Heo wrote:
>
> it's by no means a
> hot path and the priority is staying unintrusive and safe.  This patch
> makes it simply use a dedicated lock

Agreed. but could you explain why it should be irq-safe? This is not
clear from the changelog.

> +	if (!(current->flags & PF_NOFREEZE))
> +		current->flags |= PF_FROZEN;

it is not clear why do we check PF_NOFREEZE... but OK, iiuc you
remove this check later anyway.



Off-topic, but fake_signal_wake_up() is not safe if the caller
try_to_freeze_cgroup(). Unlike try_to_freeze_tasks() (which holds
tasklist) we can race with the exiting thread, ->sighand can be
NULL.

Oleg.

