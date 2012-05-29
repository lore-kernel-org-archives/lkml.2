Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab2E2Nqd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 09:46:33 -0400
Received: from mail.tpi.com ([70.99.223.143]:3856 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129Ab2E2Nqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 09:46:32 -0400
Message-ID: <4FC4D2F2.2070309@gmail.com>
Date: Tue, 29 May 2012 07:45:22 -0600
From: Tim Gardner <rtg.canonical@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Asias He <asias@redhat.com>
CC: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        tim.gardner@canonical.com
Subject: Re: [PATCH V3] block: Mitigate lock unbalance caused by lock switching
References: <20120528102214.GB15202@dhcp-172-17-108-109.mtv.corp.google.com> <1338255542-22247-1-git-send-email-asias@redhat.com>
In-Reply-To: <1338255542-22247-1-git-send-email-asias@redhat.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2012 07:39 PM, Asias He wrote:

<snip>

> @@ -440,6 +435,11 @@ void blk_cleanup_queue(struct request_queue *q)
>  	del_timer_sync(&q->backing_dev_info.laptop_mode_wb_timer);
>  	blk_sync_queue(q);
>  
> +	spin_lock_irq(lock);
> +	if (q->queue_lock != &q->__queue_lock)
> +		q->queue_lock = &q->__queue_lock;
> +	spin_unlock_irq(lock);
> +

Isn't the 'if' clause superfluous ? You could just do the assignment, e.g.,

+	spin_lock_irq(lock);
+	q->queue_lock = &q->__queue_lock;
+	spin_unlock_irq(lock);

rtg
-- 
Tim Gardner tim.gardner@canonical.com
