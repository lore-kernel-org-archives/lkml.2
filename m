Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab2KCIZI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 04:25:08 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:59677 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039Ab2KCIZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 04:25:05 -0400
Date: Sat, 3 Nov 2012 09:24:55 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Shan Wei <shanwei88@gmail.com>
Cc: Kernel-Maillist <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, cl@linux-foundation.org
Subject: Re: [PATCH v2 5/9] kernel: padata : use this_cpu_read per-cpu helper
Message-ID: <20121103082455.GB20868@secunet.com>
References: <5093EE63.5000005@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5093EE63.5000005@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 03 Nov 2012 08:24:55.0563 (UTC) FILETIME=[B45CCDB0:01CDB99C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  
> @@ -204,8 +204,7 @@ static struct padata_priv *padata_get_next(struct parallel_data *pd)
>  		goto out;
>  	}
>  
> -	queue = per_cpu_ptr(pd->pqueue, smp_processor_id());
> -	if (queue->cpu_index == next_queue->cpu_index) {
> +	if (this_cpu_read(pd->pqueue->cpu_index) == next_queue->cpu_index) {

This runs with bottom halves off, so we can use __this_cpu_read here.
