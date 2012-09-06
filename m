Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932899Ab2IFRyp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 13:54:45 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:37751 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932729Ab2IFRyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 13:54:43 -0400
Message-ID: <5048E35F.5020304@suse.cz>
Date: Thu, 06 Sep 2012 19:54:39 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Tomas Hlavacek <tmshlvck@gmail.com>
CC: gregkh@linuxfoundation.org, alan@linux.intel.com,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        marek.vasut@gmail.com
Subject: Re: [PATCH v6] uartclk value from serial_core exposed to sysfs
References: <1344929718-22736-1-git-send-email-tmshlvck@gmail.com> <1346894238-12870-1-git-send-email-tmshlvck@gmail.com>
In-Reply-To: <1346894238-12870-1-git-send-email-tmshlvck@gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2012 03:17 AM, Tomas Hlavacek wrote:
> @@ -2362,8 +2392,8 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *uport)
>  	 * Register the port whether it's detected or not.  This allows
>  	 * setserial to be used to alter this ports parameters.
>  	 */
> -	tty_dev = tty_port_register_device(port, drv->tty_driver, uport->line,
> -			uport->dev);
> +	tty_dev = tty_register_device_attr(drv->tty_driver, uport->line,
> +			uport->dev, port, tty_dev_attr_groups);

This makes me believe you have not tested the change at all?

-- 
js
suse labs
