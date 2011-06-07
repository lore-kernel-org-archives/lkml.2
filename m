Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab1FGK2B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 06:28:01 -0400
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:52015 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab1FGK17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 06:27:59 -0400
Date: Tue, 7 Jun 2011 12:27:48 +0200
From: Jan Glauber <jang@linux.vnet.ibm.com>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux390@de.ibm.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Frank Blaschka <frank.blaschka@de.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/2] s390/qdio_debug: Use kstrtoul_from_user
Message-ID: <20110607102748.GA10838@hal>
References: <1307394474-747-1-git-send-email-peterhuewe@gmx.de>
 <1307394474-747-2-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307394474-747-2-git-send-email-peterhuewe@gmx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 11:07:54PM +0200, Peter Huewe wrote:
> This patch replaces the code for getting an unsigned long from a
> userspace buffer by a simple call to kstroul_from_user.
> This makes it easier to read and less error prone.
> 
> Kernel Version: v3.0-rc2
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

Acked-by: Jan Glauber <jang@linux.vnet.ibm.com>

> ---
>  drivers/s390/cio/qdio_debug.c |   12 +++---------
>  1 files changed, 3 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/s390/cio/qdio_debug.c b/drivers/s390/cio/qdio_debug.c
> index f8b03a6..0e615cb 100644
> --- a/drivers/s390/cio/qdio_debug.c
> +++ b/drivers/s390/cio/qdio_debug.c
> @@ -188,19 +188,13 @@ static ssize_t qperf_seq_write(struct file *file, const char __user *ubuf,
>  	struct qdio_irq *irq_ptr = seq->private;
>  	struct qdio_q *q;
>  	unsigned long val;
> -	char buf[8];
>  	int ret, i;
> 
>  	if (!irq_ptr)
>  		return 0;
> -	if (count >= sizeof(buf))
> -		return -EINVAL;
> -	if (copy_from_user(&buf, ubuf, count))
> -		return -EFAULT;
> -	buf[count] = 0;
> -
> -	ret = strict_strtoul(buf, 10, &val);
> -	if (ret < 0)
> +
> +	ret = kstrtoul_from_user(ubuf, count, 10, &val);
> +	if (ret)
>  		return ret;
> 
>  	switch (val) {
> -- 
> 1.7.3.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
