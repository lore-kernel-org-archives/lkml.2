Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758948Ab1FWN2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 09:28:00 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39223 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139Ab1FWN17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 09:27:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=I426HX/kbL59+1/5okmWHuPDndV/Do2atI+wPxCsrmLF1vMHVYi+/thd+GIcw1/VZU
         z+Ej/UEGiE81J4/xTzI0U+NAMSHyHAt286nGzH1MqfPx6lJN9Vsw3bqUy3NVjRJamiZK
         XXu1xX/gzVbhZQO/wRG6+OXuiKC0F4fGMZtSY=
Date: Thu, 23 Jun 2011 15:27:54 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        hch@infradead.org
Subject: Re: [PATCH 2/8] kill tracehook_notify_death()
Message-ID: <20110623132754.GO30101@htj.dyndns.org>
References: <1308322240-8247-1-git-send-email-tj@kernel.org>
 <1308322240-8247-7-git-send-email-tj@kernel.org>
 <20110622210757.GA20549@redhat.com>
 <20110622210834.GC20549@redhat.com>
 <20110623122253.GM30101@htj.dyndns.org>
 <20110623132126.GA10410@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110623132126.GA10410@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Thu, Jun 23, 2011 at 03:21:26PM +0200, Oleg Nesterov wrote:
> > > This also fixes a minor bug, if the exiting task is the group_leader
> > > and it is traced by its real_parent, tracehook_notify_death() returns
> > > task->exit_signal or SIGCHLD depending on thread_group_empty(), this
> > > looks strange.
> >
> > Maybe we should do the above in a separate patch?
> 
> Do you think this makes sense? OK, I can do this...

Having subtle behavior change mixed with reorganization isn't too
nice, so I think separating is better.

> > thread_group_leader() seems unnecessarily indirect.
> 
> This is what I disagree with. Contrary, I think thread_group_leader() exactly
> explains what do we want to check. (but once again, exec_id logic should be
> cleanuped, not only in this function).

Hmmm... well, this was minor to begin with and thread_group_leader()
matches later patches better, so using thread_group_leader() seems
fine.

Thanks.

-- 
tejun
