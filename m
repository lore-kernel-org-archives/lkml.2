Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787Ab1L0VuS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 16:50:18 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41916 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463Ab1L0VuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 16:50:17 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH] freezer: fix return value of freezable_schedule_timeout_killable
Date: Tue, 27 Dec 2011 22:53:29 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1324692054-5424-1-git-send-email-jlayton@redhat.com>
In-Reply-To: <1324692054-5424-1-git-send-email-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201112272253.29446.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, December 24, 2011, Jeff Layton wrote:
> ...it should return the return code from schedule_timeout_killable(),
> not the one from freezer_count().
> 
> All of the current callers ignore the return code so the bug is
> harmless but it's worth fixing.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>

Applied to linux-pm/pm-freezer, will be pushed for 3.3.

Thanks,
Rafael


> ---
>  include/linux/freezer.h |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/freezer.h b/include/linux/freezer.h
> index 30f06c2..96b5b59 100644
> --- a/include/linux/freezer.h
> +++ b/include/linux/freezer.h
> @@ -122,9 +122,11 @@ static inline int freezer_should_skip(struct task_struct *p)
>  /* Like schedule_timeout_killable(), but should not block the freezer. */
>  #define freezable_schedule_timeout_killable(timeout)			\
>  ({									\
> +	long __retval;							\
>  	freezer_do_not_count();						\
> -	schedule_timeout_killable(timeout);				\
> +	__retval = schedule_timeout_killable(timeout);			\
>  	freezer_count();						\
> +	__retval;							\
>  })
>  
>  /*
> 

