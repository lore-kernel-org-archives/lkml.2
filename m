Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806Ab1HEPEn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 11:04:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755243Ab1HEPEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 11:04:41 -0400
Message-ID: <4E3C06D2.2020309@redhat.com>
Date: Fri, 05 Aug 2011 17:05:54 +0200
From: Laszlo Ersek <lersek@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc14 Lightning/1.0b3pre Mnenhy/0.8.3 Thunderbird/3.1.11
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Joe Jin <joe.jin@oracle.com>, open list <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] xen-blkback: add missing return on error in xen_update_blkif_status()
References: <20110805141821.GK7659@shale.localdomain>
In-Reply-To: <20110805141821.GK7659@shale.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/11 16:18, Dan Carpenter wrote:
> We should return here after reporting the error.  Otherwise we'd hit
> a NULL deref of blkif->xenblkd on the next line.
>
> Signed-off-by: Dan Carpenter<error27@gmail.com>
>
> diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
> index 32d4c3c..b750299 100644
> --- a/drivers/block/xen-blkback/xenbus.c
> +++ b/drivers/block/xen-blkback/xenbus.c
> @@ -107,6 +107,7 @@ static void xen_update_blkif_status(struct xen_blkif *blkif)
>   		err = PTR_ERR(blkif->xenblkd);
>   		blkif->xenblkd = NULL;
>   		xenbus_dev_error(blkif->be->dev, err, "start xenblkd");
> +		return;
>   	}
>
>   	blkif->be->kthread_pid = blkif->xenblkd->pid;

In case somebody were asking for my opinion:

I think this block was the last block in the originally containing 
function (update_blkif_status()?), thus the "return" wasn't needed 
there. I guess the block got copied and then other code was added below it.

Acked-by: Laszlo Ersek <lersek@redhat.com>
