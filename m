Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931Ab0KVQqz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 11:46:55 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39480 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab0KVQqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 11:46:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=DnQn3x6fhB5Ii3tm25GI3VOloR3CxPYheFjks4XetlDGh5Gli/K73DI0PQNOHs6szJ
         Nji3TGksWOpvt3QGjR+fDHi+jZvwb7ViWtvi7NPQzjG0izb7bi9MsXNGcm8rE0/YKFM4
         xAG0Hs82H+uujIArTVhoFr9oZJUxAr+zg0beY=
Date: Mon, 22 Nov 2010 19:46:23 +0300
From: Dan Carpenter <error27@gmail.com>
To: pavan_savoy@ti.com
Cc: marcel@holtmann.org, padovan@profusion.mobi,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6] Bluetooth: btwilink driver
Message-ID: <20101122164623.GB8882@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>, pavan_savoy@ti.com,
	marcel@holtmann.org, padovan@profusion.mobi,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1290424125-2717-1-git-send-email-pavan_savoy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290424125-2717-1-git-send-email-pavan_savoy@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 06:08:45AM -0500, pavan_savoy@ti.com wrote:
> +static int bt_ti_probe(struct platform_device *pdev)
> +{
> +	static struct ti_st *hst;
> +	struct hci_dev *hdev;
> +	int err;
> +
> +	hst = kzalloc(sizeof(struct ti_st), GFP_KERNEL);
> +	if (!hst)
> +		return -ENOMEM;
> +
> +	/* Expose "hciX" device to user space */
> +	hdev = hci_alloc_dev();
> +	if (!hdev) {
> +		kfree(hst);
> +		return -ENOMEM;
> +	}
> +
> +	BT_DBG("hdev %p", hdev);
> +
> +	hst->hdev = hdev;
> +	hdev->bus = HCI_UART;
> +	hdev->driver_data = hst;
> +	hdev->open = ti_st_open;
> +	hdev->close = ti_st_close;
> +	hdev->flush = NULL;
> +	hdev->send = ti_st_send_frame;
> +	hdev->destruct = ti_st_destruct;
> +	hdev->owner = THIS_MODULE;
> +
> +	err = hci_register_dev(hdev);
> +	if (err < 0) {
> +		BT_ERR("Can't register HCI device error %d", err);
> +		hci_free_dev(hdev);

	Should there be a kfree(hst); here?  That's how it's done in
	bpa10x_probe() from drivers/bluetooth/bpa10x.c

> +		return err;
> +	}
> +
> +	BT_DBG(" HCI device registered (hdev %p)", hdev);
                ^
	Quite a few places have an extra space at the start.

> +
> +	dev_set_drvdata(&pdev->dev, hst);
> +	return err;
> +}

regards,
dan carpenter


