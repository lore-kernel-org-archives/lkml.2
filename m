Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759144Ab1FWJwp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 05:52:45 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48003 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758872Ab1FWJwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 05:52:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Uf/+LANHlh124RMecyuHrTRNv6MKm/48S9V2g6LoDHbjcP3AnEE/9hlHvY3NORd7BF
         vpAxk1cHYSZRodWTZMBWQQ56xjX0JqqPT330/jwOKtkiXjj1IXScqPDWVba5McLFliFl
         yEa+TR7A/SMXYlC0pfmKAnQBYjx/e349OKGG8=
Date: Thu, 23 Jun 2011 11:52:39 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        hch@infradead.org
Subject: Re: [PATCH 1/8] make do_notify_parent() return bool
Message-ID: <20110623095239.GK30101@htj.dyndns.org>
References: <1308322240-8247-1-git-send-email-tj@kernel.org>
 <1308322240-8247-7-git-send-email-tj@kernel.org>
 <20110622210757.GA20549@redhat.com>
 <20110622210818.GB20549@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110622210818.GB20549@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jun 22, 2011 at 11:08:18PM +0200, Oleg Nesterov wrote:
> - change do_notify_parent() to return a boolean, true if the task should
>   be reaped because its parent ignores SIGCHLD.
> 
> - update the only caller which checks the returned value, exit_notify().
> 
> This temporary uglifies exit_notify() even more, will be cleanuped by
> the next change.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
> @@ -2161,7 +2161,7 @@ extern int kill_pid_info_as_uid(int, str
>  extern int kill_pgrp(struct pid *pid, int sig, int priv);
>  extern int kill_pid(struct pid *pid, int sig, int priv);
>  extern int kill_proc_info(int, struct siginfo *, pid_t);
> -extern int do_notify_parent(struct task_struct *, int);
> +extern bool do_notify_parent(struct task_struct *, int);
>  extern void __wake_up_parent(struct task_struct *p, struct task_struct *parent);
>  extern void force_sig(int, struct task_struct *);
>  extern int send_sig(int, struct task_struct *, int);

While at it, would you mind adding the name of the parameters to the
prototype?  I find prototypes w/o parameter names a bit irksome.

Other than that,

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
