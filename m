Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751185Ab2AYWAR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 17:00:17 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46374 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab2AYWAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 17:00:16 -0500
Message-ID: <4F207B6C.9090504@gmail.com>
Date: Wed, 25 Jan 2012 23:00:12 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120118 Thunderbird/10.0
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Baohua.Song@csr.com, Tejun Heo <tj@kernel.org>,
        "pavel@ucw.cz" <pavel@ucw.cz>
Subject: Re: [linux-pm] PM: cannot hibernate -- BUG at	kernel/workqueue.c:3659
References: <4F1EC8D5.5040102@suse.cz> <201201250002.37916.rjw@sisk.pl> <4F1F4717.2090704@gmail.com> <201201250110.44360.rjw@sisk.pl> <4F20204F.6040606@linux.vnet.ibm.com> <4F202721.6050900@linux.vnet.ibm.com>
In-Reply-To: <4F202721.6050900@linux.vnet.ibm.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2012 05:00 PM, Srivatsa S. Bhat wrote:
> So, Jiri, can you please try the following patch and see if it works for
> you as expected? I'll be happy to provide a formal patch with a changelog
> if this works.

FWIW it works, thanks. If you want me test a proper fix, jsut let me know.

> ---
>  kernel/workqueue.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index bec7b5b..cb26c5d 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -3656,7 +3656,9 @@ void freeze_workqueues_begin(void)
>  
>  	spin_lock(&workqueue_lock);
>  
> -	BUG_ON(workqueue_freezing);
> +	if (workqueue_freezing)
> +		goto out_unlock;
> +
>  	workqueue_freezing = true;
>  
>  	for_each_gcwq_cpu(cpu) {
> @@ -3678,6 +3680,7 @@ void freeze_workqueues_begin(void)
>  		spin_unlock_irq(&gcwq->lock);
>  	}
>  
> +out_unlock:
>  	spin_unlock(&workqueue_lock);
>  }
>  


-- 
js
