Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932479Ab1FWN4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 09:56:44 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63080 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196Ab1FWN4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 09:56:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KlfIhIW01Nekn4jNzkTFE1SXEguDFMAI78fnQ1Zg++9zo7FjdK1ej4ZZtLC7FZOMka
         oOl9uX/buBKWJMvke8Z1GM9iY7XwQJIptipbq/IG92SHlafEQNzCbQWhLufaiwLLDim9
         Hl8fh4HJBxT2ehDkl1QZjd/xeSVm1sYgKAEpE=
Date: Thu, 23 Jun 2011 15:56:38 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        hch@infradead.org
Subject: Re: [PATCH 8/8] redefine thread_group_leader() as exit_signal >= 0
Message-ID: <20110623135638.GQ30101@htj.dyndns.org>
References: <1308322240-8247-1-git-send-email-tj@kernel.org>
 <1308322240-8247-7-git-send-email-tj@kernel.org>
 <20110622210757.GA20549@redhat.com>
 <20110622211026.GI20549@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110622211026.GI20549@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jun 22, 2011 at 11:10:26PM +0200, Oleg Nesterov wrote:
> Change de_thread() to set old_leader->exit_signal = -1. This is
> good for the consistency, it is no longer the leader and all
> sub-threads have exit_signal = -1 set by copy_process(CLONE_THREAD).
> 
> And this allows us to micro-optimize thread_group_leader(), it can
> simply check exit_signal >= 0. This also makes sense because we
> should move ->group_leader from task_struct to signal_struct.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Patches 5-8 look correct to me but I frankly don't know the area
enough to assert acked-by's.  Please feel free to add reviewed-by's
tho.

Thanks.

-- 
tejun
