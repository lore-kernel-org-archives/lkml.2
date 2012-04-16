Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab2DPTWF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 15:22:05 -0400
Received: from masquerade.micron.com ([137.201.242.130]:25043 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab2DPTWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 15:22:04 -0400
Message-ID: <4F8C7151.3070808@micron.com>
Date: Mon, 16 Apr 2012 12:21:53 -0700
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Jens Axboe <axboe@kernel.dk>, <linux-kernel@vger.kernel.org>
Subject: Re: mtip32xx: Add new bitwise flag 'dd_flag'
References: <20120416111245.GA26187@elgon.mountain>
In-Reply-To: <20120416111245.GA26187@elgon.mountain>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-6.800.1017-18844.001
X-TM-AS-Result: No--14.761100-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/16/2012 4:12 AM, Dan Carpenter wrote:

> Hello Asai Thambi S P,
> 
> The patch 45038367c271: "mtip32xx: Add new bitwise flag 'dd_flag'"
> from Apr 9, 2012, leads to the following Smatch warning:
> drivers/block/mtip32xx/mtip32xx.c:2516 mtip_hw_get_scatterlist()
> 	 warn: inconsistent returns sem:&dd->port->cmd_slot: locked (2514,2516) unlocked ()
> 
> @@ -2193,6 +2245,10 @@ static struct scatterlist *mtip_hw_get_scatterlist(struct driver_data *dd,
>         down(&dd->port->cmd_slot);
>         *tag = get_slot(dd->port);
>  
> +       if (unlikely(test_bit(MTIP_DD_FLAG_REMOVE_PENDING_BIT, &dd->dd_flag))) {
> +               up(&dd->port->cmd_slot);
>                 ^^^^^^^^^^^^^^^^^^^^^^^
> We release the lock here.
> 
> +               return NULL;
> +       }
>         if (unlikely(*tag < 0))
>                 return NULL;
>                 ^^^^^^^^^^^^
> Should we release it here as well?
> 

Thanks for finding this. I should start using smatch :). I will send out the
patch.

--
Regards,
Asai Thambi

