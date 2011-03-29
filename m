Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab1C2L2J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 07:28:09 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42897 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab1C2L2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 07:28:08 -0400
Message-ID: <4D91C1EB.5060604@ru.mvista.com>
Date: Tue, 29 Mar 2011 15:26:35 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Steven Hardy <shardy@redhat.com>
CC: Greg KH <gregkh@suse.de>, Aristeu Rozanski <aris@redhat.com>,
        mjg@redhat.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH 2/3 (2nd draft)] Resend : Fix memory leak in qcserial
 driver
References: <1301321186.4397.13.camel@shardy.csb> <20110328142148.GA19521@suse.de> <20110328221636.GA8195@shardy.csb>
In-Reply-To: <20110328221636.GA8195@shardy.csb>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 29-03-2011 2:16, Steven Hardy wrote:

> Second draft of patch #2, this addresses the review comments made by Aristeu Rozanski, now usb_set_serial_data() is only called when we are not returning -ENODEV

    Such comments should be put under --- tearline (which should appear under 
your signoff). Otherwise Greg will have to hand edit them out of your patch.

> Original description:

    Omit that please.

> Don't assign serial->private when doing the kzalloc or serial->private ends up pointing to freed memory in the event we return -ENODEV, instead call usb_set_serial_data(serial, data) at the end of the function, and only have one return-point.

    Still not properly wrapped.

> Signed-off-by: Steve Hardy<shardy@redhat.com>


> diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
> index 6e3b933..b9b97ad 100644
> --- a/drivers/usb/serial/qcserial.c
> +++ b/drivers/usb/serial/qcserial.c
[...]
> @@ -199,9 +199,12 @@ static int qcprobe(struct usb_serial *serial, const struct usb_device_id *id)
>   		dev_err(&serial->dev->dev,
>   			"unknown number of interfaces: %d\n", nintf);
>   		kfree(data);
> -		return -ENODEV;
> +		retval = -ENODEV;
>   	}
>
> +	/* Set serial->private if not returning -ENODEV */
> +	if ( retval != -ENODEV )

    No spaces after ( and before ) allowed.

WBR, Sergei
