Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab1H2HVL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 03:21:11 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62646 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab1H2HVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 03:21:03 -0400
Date: Mon, 29 Aug 2011 09:20:54 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: rjw@sisk.pl, paul@paulmenage.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de
Subject: Re: [PATCH 08/16] freezer: use dedicated lock instead of task_lock()
 + memory barrier
Message-ID: <20110829072054.GB16431@mtj.dyndns.org>
References: <1313763382-12341-1-git-send-email-tj@kernel.org>
 <1313763382-12341-9-git-send-email-tj@kernel.org>
 <20110828175116.GA27032@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110828175116.GA27032@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, Aug 28, 2011 at 07:51:16PM +0200, Oleg Nesterov wrote:
> On 08/19, Tejun Heo wrote:
> >
> > it's by no means a
> > hot path and the priority is staying unintrusive and safe.  This patch
> > makes it simply use a dedicated lock
> 
> Agreed. but could you explain why it should be irq-safe? This is not
> clear from the changelog.

It doesn't need to be.  cgroup_freezer assumes irq-safety so I didn't
want to change it.  I was thinking about dropping irq-safety from all
of them later on.

> Off-topic, but fake_signal_wake_up() is not safe if the caller
> try_to_freeze_cgroup(). Unlike try_to_freeze_tasks() (which holds
> tasklist) we can race with the exiting thread, ->sighand can be
> NULL.

Indeed, guess we'll need to grab tasklist_lock around
try_to_freeze_cgroup() too.

Thanks.

-- 
tejun
