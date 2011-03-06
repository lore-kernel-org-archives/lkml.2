Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943Ab1CFQpy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 11:45:54 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39986 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab1CFQpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 11:45:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=MLAzgaQ6Lvblavx3H+EPR+hqUW2/K4V161KYGKMPH+iPybTDJmHktCLxTdBfYrer0s
         wB0K5cLAmb+vjjUUvifFPn9tUrqkafMCJG9jHYNYKPoELYITyBIPtHjbvI9KMTAMJKhv
         WvifEAcd0PeXchzKa7VzE2OhGDrKJBjoHeSN8=
Message-ID: <4D73BA3A.3070700@lwfinger.net>
Date: Sun, 06 Mar 2011 10:45:46 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Xiaochen Wang <wangxiaochen0@gmail.com>
CC: greg@kroah.com, florian.c.schilhabel@googlemail.com,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] check copy_from_user return value in rtl8712
References: <20110306142414.GA19990@chii>
In-Reply-To: <20110306142414.GA19990@chii>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2011 08:24 AM, Xiaochen Wang wrote:
> Description:return -EFAULT if copy_to_user() fails
>
> Signed-off-by: Xiaochen Wang<wangxiaochen0@gmail.com>
> ---
>   drivers/staging/rtl8712/rtl871x_ioctl_linux.c |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> index 685a7b1..8a8e682 100644
> --- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> +++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> @@ -1965,9 +1965,9 @@ static int r871x_wps_start(struct net_device *dev,
>   	struct _adapter *padapter = (struct _adapter *)_netdev_priv(dev);
>   	struct iw_point *pdata =&wrqu->data;
>   	u32   u32wps_start = 0;
> -	unsigned int uintRet = 0;
>
> -	uintRet = copy_from_user((void *)&u32wps_start, pdata->pointer, 4);
> +	if (copy_from_user((void *)&u32wps_start, pdata->pointer, 4))
> +		return -EFAULT;
>   	if ((padapter->bDriverStopped) || (pdata == NULL))
>   		return -EINVAL;
>   	if (u32wps_start == 0)

ACK.

Larry

