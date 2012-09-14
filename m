Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282Ab2INLoF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 07:44:05 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:47125 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758648Ab2INLn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 07:43:57 -0400
Message-ID: <50531832.3050902@mvista.com>
Date: Fri, 14 Sep 2012 15:42:42 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: navin patidar <navinp@cdac.in>
CC: gregkh@linuxfoundation.org, mfm@muteddisk.com, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: usbip: stub_dev: Fixed oops during removal of
 usbip_host
References: <1347616403-3413-1-git-send-email-navinp@cdac.in>
In-Reply-To: <1347616403-3413-1-git-send-email-navinp@cdac.in>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 14-09-2012 13:53, navin patidar wrote:

> stub_device_reset should set kernel thread pointers to NULL.
> so that at the time of usbip_host removal stub_shoutdown_connection
> doesn't try to kill kernel threads which are already killed.

> Signed-off-by: navin patidar <navinp@cdac.in>
> ---
>   drivers/staging/usbip/stub_dev.c |   14 +++++++++-----
>   1 file changed, 9 insertions(+), 5 deletions(-)

> diff --git a/drivers/staging/usbip/stub_dev.c b/drivers/staging/usbip/stub_dev.c
> index 92ced35..f584af8 100644
> --- a/drivers/staging/usbip/stub_dev.c
> +++ b/drivers/staging/usbip/stub_dev.c
> @@ -192,16 +192,13 @@ static void stub_shutdown_connection(struct usbip_device *ud)
>   	if (ud->tcp_tx)
>   		kthread_stop_put(ud->tcp_tx);
>
> -	/*
> -	 * 2. close the socket
> +	/* 2. close the socket

    It's the preferred comment style -- why modify it?

>   	 *
>   	 * tcp_socket is freed after threads are killed so that usbip_xmit does
>   	 * not touch NULL socket.
>   	 */
> -	if (ud->tcp_socket) {
> +	if (ud->tcp_socket)
>   		sock_release(ud->tcp_socket);
> -		ud->tcp_socket = NULL;
> -	}
>
>   	/* 3. free used data */
>   	stub_device_cleanup_urbs(sdev);
> @@ -233,6 +230,13 @@ static void stub_device_reset(struct usbip_device *ud)
>
>   	dev_dbg(&udev->dev, "device reset");
>
> +	/*reset tcp socket*/

    Add spaces after /* and before */, please.

> +	ud->tcp_socket = NULL;
> +
> +	/*reset kernel thread pointers */

    Here too.

WBR, Sergei

