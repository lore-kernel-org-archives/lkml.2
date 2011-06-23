Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169Ab1FWNZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 09:25:40 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52123 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649Ab1FWNZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 09:25:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ECebPG28juT0qDm8rsSqBZGFiNzmAAVs5U4JviJq5P6ZhGGBHTKU7wBXVK1+8lmE/y
         d+NAY3BM9UkWCzKnNKmte7ZNsAaCqoFgTtwwZhqnw/y0qg7pUnMIFWUy2Vef3upKHOdb
         dznmX6vSFXhRTHVTrggSTzb/647SDvP6Ukzuo=
Date: Thu, 23 Jun 2011 15:25:23 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        hch@infradead.org
Subject: Re: [PATCH 3/8] __ptrace_detach: avoid task_detached(), check
 do_notify_parent()
Message-ID: <20110623132523.GN30101@htj.dyndns.org>
References: <1308322240-8247-1-git-send-email-tj@kernel.org>
 <1308322240-8247-7-git-send-email-tj@kernel.org>
 <20110622210757.GA20549@redhat.com>
 <20110622210853.GD20549@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110622210853.GD20549@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 11:08:53PM +0200, Oleg Nesterov wrote:
> __ptrace_detach() relies on the current obscure behaviour of
> do_notify_parent(tsk) which changes tsk->exit_signal if this child
> should be silently reaped. That is why we check task_detached(), it
> is true if the task is sub-thread, or it is the group_leader but
> its exit_signal was changed by do_notify_parent().
> 
> This is confusing, change the code to rely on !thread_group_leader()
> or the value returned by do_notify_parent().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

This looks good to me.

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
