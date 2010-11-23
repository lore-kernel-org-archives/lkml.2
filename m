Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab0KWMhP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 07:37:15 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:53621 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab0KWMhM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 07:37:12 -0500
MIME-Version: 1.0
X-Originating-IP: [192.163.20.231]
In-Reply-To: <20101122164623.GB8882@bicker>
References: <1290424125-2717-1-git-send-email-pavan_savoy@ti.com>
	<20101122164623.GB8882@bicker>
Date: Tue, 23 Nov 2010 18:07:11 +0530
Message-ID: <AANLkTik0WAK9QvDeXWb7n07TPAadXn6fYsYgjjfUE0uJ@mail.gmail.com>
Subject: Re: [PATCH v6] Bluetooth: btwilink driver
From: Pavan Savoy <pavan_savoy@sify.com>
To: Dan Carpenter <error27@gmail.com>, pavan_savoy@ti.com, marcel@holtmann.org,
        padovan@profusion.mobi, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan, Marcel, Gustavo,

On Mon, Nov 22, 2010 at 10:16 PM, Dan Carpenter <error27@gmail.com> wrote:
> On Mon, Nov 22, 2010 at 06:08:45AM -0500, pavan_savoy@ti.com wrote:
>> +static int bt_ti_probe(struct platform_device *pdev)
>> +{
>> +     static struct ti_st *hst;
>> +     struct hci_dev *hdev;
>> +     int err;
>> +
>> +     hst = kzalloc(sizeof(struct ti_st), GFP_KERNEL);
>> +     if (!hst)
>> +             return -ENOMEM;
>> +
>> +     /* Expose "hciX" device to user space */
>> +     hdev = hci_alloc_dev();
>> +     if (!hdev) {
>> +             kfree(hst);
>> +             return -ENOMEM;
>> +     }
>> +
>> +     BT_DBG("hdev %p", hdev);
>> +
>> +     hst->hdev = hdev;
>> +     hdev->bus = HCI_UART;
>> +     hdev->driver_data = hst;
>> +     hdev->open = ti_st_open;
>> +     hdev->close = ti_st_close;
>> +     hdev->flush = NULL;
>> +     hdev->send = ti_st_send_frame;
>> +     hdev->destruct = ti_st_destruct;
>> +     hdev->owner = THIS_MODULE;
>> +
>> +     err = hci_register_dev(hdev);
>> +     if (err < 0) {
>> +             BT_ERR("Can't register HCI device error %d", err);
>> +             hci_free_dev(hdev);
>
>        Should there be a kfree(hst); here?  That's how it's done in
>        bpa10x_probe() from drivers/bluetooth/bpa10x.c
>
>> +             return err;
>> +     }
>> +
>> +     BT_DBG(" HCI device registered (hdev %p)", hdev);
>                ^
>        Quite a few places have an extra space at the start.
>
>> +
>> +     dev_set_drvdata(&pdev->dev, hst);
>> +     return err;
>> +}
>
> regards,
> dan carpenter

Thanks Dan for the comments,
Marcel, Gustavo - Please provide your comments too... So I can bundle
them all and post a v7 ....

> --
> To unsubscribe from this list: send the line "unsubscribe linux-bluetooth" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
