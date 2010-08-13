Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760677Ab0HMBDh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 21:03:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:27296 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754757Ab0HMBDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 21:03:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,360,1278313200"; 
   d="scan'208";a="647249125"
Date: Fri, 13 Aug 2010 09:23:51 +0800
From: Feng Tang <feng.tang@intel.com>
To: Dan Carpenter <error27@gmail.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [patch] mfd: snprintf() returns largish values
Message-ID: <20100813092351.326d9982@feng-i7>
In-Reply-To: <20100812075009.GK645@bicker>
References: <20100812075009.GK645@bicker>
Organization: intel
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.0; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Aug 2010 15:50:09 +0800
Dan Carpenter <error27@gmail.com> wrote:

> snprintf() returns the number of bytes which would have been written
> so it can be larger than the size of the buffer.  In this case it's
> fine, but people copy and paste this code so I've fixed it.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/drivers/serial/mfd.c b/drivers/serial/mfd.c
> index bc9af50..5aa25e5 100644
> --- a/drivers/serial/mfd.c
> +++ b/drivers/serial/mfd.c
> @@ -171,6 +171,9 @@ static ssize_t port_show_regs(struct file *file,
> char __user *user_buf, len += snprintf(buf + len, HSU_REGS_BUFSIZE -
> len, "DIV: \t\t0x%08x\n", serial_in(up, UART_DIV));
>  
> +	if (len > HSU_REGS_BUFSIZE)
> +		len = HSU_REGS_BUFSIZE;
> +
>  	ret =  simple_read_from_buffer(user_buf, count, ppos, buf,
> len); kfree(buf);
>  	return ret;
> @@ -218,6 +221,9 @@ static ssize_t dma_show_regs(struct file *file,
> char __user *user_buf, len += snprintf(buf + len, HSU_REGS_BUFSIZE -
> len, "D0TSR: \t\t0x%08x\n", chan_readl(chan, HSU_CH_D3TSR));
>  
> +	if (len > HSU_REGS_BUFSIZE)
> +		len = HSU_REGS_BUFSIZE;
> +
>  	ret =  simple_read_from_buffer(user_buf, count, ppos, buf,
> len); kfree(buf);
>  	return ret;

Hi Carpenter,

It looks ok to me, thanks,

- Feng
