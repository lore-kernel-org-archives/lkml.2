Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186Ab0E0TQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 15:16:34 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59679 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323Ab0E0TQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 15:16:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=c26loxEwwF6Px9m1eVnS9taNtX4Q0bdoiMROpreUbApQ9QvCQF1oWObVwBox0WVa5W
         LJQRvY23u28yupD46H89QJ1IDKQQ+C9Mt+pXz3iFAsYX8oFOOYU7sHdrv5dGU2eXVxvH
         +FS0TLEoC4SiGn8G61FlsrosAxAr/42dAHhRE=
Date: Thu, 27 May 2010 21:16:31 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com
Subject: Re: [PATCH]: mutex: Fix !CONFIG_MUTEX_SPIN_ON_OWNER compile warning
Message-ID: <20100527191628.GA5390@nowhere>
References: <20100527190336.24665.22701.sendpatchset@prarit.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100527190336.24665.22701.sendpatchset@prarit.bos.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 03:07:40PM -0400, Prarit Bhargava wrote:
> Fixes linux-next !CONFIG_MUTEX_SPIN_ON_OWNER compile warning:
> 
> kernel/mutex.c: In function ‘__mutex_lock_common’:
> kernel/mutex.c:148: error: unused variable ‘timeout’
> 
> timeout is only used if CONFIG_MUTEX_SPIN_ON_OWNER is on.
> 
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> 
> diff --git a/kernel/mutex.c b/kernel/mutex.c
> index 7d4626b..c262942 100644
> --- a/kernel/mutex.c
> +++ b/kernel/mutex.c
> @@ -145,7 +145,9 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>  	struct task_struct *task = current;
>  	struct mutex_waiter waiter;
>  	unsigned long flags;
> +#ifdef CONFIG_MUTEX_SPIN_ON_OWNER
>  	unsigned long timeout;
> +#endif



Andrew had a patch that fixed it with a "__used" tag.
Either way that doesn't look much proper.

It would be much nicer to put the mutex spinning in a separate
function, that would be a stub with !CONFIG_MUTEX_SPIN_ON_OWNER.

