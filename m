Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758402Ab1FWNiO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 09:38:14 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33967 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab1FWNiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 09:38:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=k//YNBO4WEDFICcOz55hE7RyP1jBrnAObkC+iYxU4a1xu/8ctXkmpSYsfFR6sckduR
         HyG+q3qaK+7jaN+ufcgNK+hFHsh4mwPtbskst7IEJvVxrBQ5onqChDipP0o3YIinV0QJ
         FjKbbUXLrT20ATW/9WqXF/7FfPCULL7NX/SqI=
Date: Thu, 23 Jun 2011 15:38:08 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        hch@infradead.org
Subject: Re: [PATCH 4/8] make do_notify_parent() __must_check, update the
 callers
Message-ID: <20110623133808.GP30101@htj.dyndns.org>
References: <1308322240-8247-1-git-send-email-tj@kernel.org>
 <1308322240-8247-7-git-send-email-tj@kernel.org>
 <20110622210757.GA20549@redhat.com>
 <20110622210909.GE20549@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110622210909.GE20549@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 11:09:09PM +0200, Oleg Nesterov wrote:
> Change other callers of do_notify_parent() to check the value it
> returns, this makes the subsequent task_detached() unnecessary.
> Mark do_notify_parent() as __must_check.
> 
> Use thread_group_leader() instead of !task_detached() to check
> if we need to notify the real parent in wait_task_zombie().
> 
> Remove the stale comment in release_task(). "just for sanity" is
> no longer true, we have to set EXIT_DEAD to avoid the races with
> do_wait().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
