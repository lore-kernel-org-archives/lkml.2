Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492Ab0ENQEK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 12:04:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083Ab0ENQEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 12:04:05 -0400
Date: Fri, 14 May 2010 18:01:35 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrey Vagin <avagin@openvz.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Pavel Emelyanov <xemul@openvz.org>,
       Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [PATCH 1/2] posix_timer: separate timer_cleanup from timer_del
Message-ID: <20100514160135.GA3727@redhat.com>
References: <1273843731-12595-1-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273843731-12595-1-git-send-email-avagin@openvz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(add Stanislaw)

On 05/14, Andrey Vagin wrote:
>
> Signed-off-by: Andrey Vagin <avagin@openvz.org>

You forgot to write the changelog ;)



> --- a/kernel/posix-cpu-timers.c
> +++ b/kernel/posix-cpu-timers.c
> @@ -455,14 +455,21 @@ int posix_cpu_timer_del(struct k_itimer *timer)
>  			spin_unlock(&p->sighand->siglock);
>  		}
>  		read_unlock(&tasklist_lock);
> -
> -		if (!ret)
> -			put_task_struct(p);
>  	}
>  
> +	if (!ret)
> +		posix_cpu_timer_cleanup(timer);
> +
>  	return ret;
>  }

Could you please explain this change?

Oleg.

