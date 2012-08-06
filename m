Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604Ab2HFDOf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 23:14:35 -0400
Received: from emcscan.emc.com.tw ([192.72.220.5]:33245 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552Ab2HFDOH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 23:14:07 -0400
From: =?big5?B?vEK5xcJA?= <scott.liu@emc.com.tw>
To: "'Jian-Jhong Ding'" <jj_ding@emc.com.tw>,
        "'benjamin.tissoires'" <benjamin.tissoires@gmail.com>,
        "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>,
        "'Jiri Kosina'" <jkosina@suse.cz>
Cc: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <eleghost@gmail.com>
Subject: RE: [PATCH 1/1]hid:hid-multitouch:  add mt_resume for ELAN's production
Date: Mon, 6 Aug 2012 11:14:01 +0800
Message-ID: <1D0CA16CE8BA4331BC7C995D25717BFE@elan.corp>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <87y5lw5mbv.fsf@emc.com.tw>
Thread-Index: Ac1xXn6wuwvSAvLASIGoNKVoJPs7igCINdwQ
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Mode change to 0644.

From: Scott Liu<scott.liu@emc.com.tw>
Signed-off-by: Scott Liu <scott.liu@emc.com.tw>

---
 0 files changed
 mode change 100755 => 100644 drivers/hid/hid-ids.h
 mode change 100755 => 100644 drivers/hid/hid-multitouch.c

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
old mode 100755
new mode 100644
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
old mode 100755
new mode 100644
-- 
1.7.9.5


-----Original Message-----
From: linux-input-owner@vger.kernel.org
[mailto:linux-input-owner@vger.kernel.org] On Behalf Of Jian-Jhong Ding
Sent: Friday, August 03, 2012 5:58 PM
To: ¼B¹ÅÂ@; 'benjamin.tissoires'; 'Dmitry Torokhov'; 'Jiri Kosina'
Cc: linux-input@vger.kernel.org; linux-kernel@vger.kernel.org;
eleghost@gmail.com
Subject: Re: [PATCH 1/1]hid:hid-multitouch: add mt_resume for ELAN's
production

Hi Scott,

¼B¹ÅÂ@ <scott.liu@emc.com.tw> writes:
> Some of ELAN¡¦s production need to issue set_idle when resume.
>
> Signed-off-by: Scott Liu <scott.liu@emc.com.tw>

You might want to add a From: line at the top of mail body to make your
name go along with the SoB line.

> ---
>  drivers/hid/hid-ids.h        |    3 +++
>  drivers/hid/hid-multitouch.c |   27 +++++++++++++++++++++++++++
>  2 files changed, 30 insertions(+)
>  mode change 100644 => 100755 drivers/hid/hid-ids.h
>  mode change 100644 => 100755 drivers/hid/hid-multitouch.c

I believe these two files are merely plain text source file. No need to
make them executives.

And, please consider using git send-mail to send the patches. Your MTA
is still making the indent pretty ugly.

Thanks,
-JJ

> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> old mode 100644
> new mode 100755
> index 41c34f2..703aaed
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -829,4 +829,7 @@
>  #define USB_VENDOR_ID_PRIMAX  0x0461
>  #define USB_DEVICE_ID_PRIMAX_KEYBOARD     0x4e05
>  
> +#define USB_VENDOR_ID_ELAN      0x04f3
> +#define USB_DEVICE_ID_ELAN_MOCCA 0x000a
> +
>  #endif
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> old mode 100644
> new mode 100755
> index 59c8b5c..2c898bb
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -767,6 +767,32 @@ static int mt_reset_resume(struct hid_device *hdev)
>        mt_set_input_mode(hdev);
>        return 0;
>  }
> +
> +static int mt_resume(struct hid_device *hdev)
> +{
> +      struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
> +      struct usb_host_interface *interface = intf->cur_altsetting;
> +
> +      struct usb_device *dev = hid_to_usb_dev(hdev);
> +
> +
> +      if (hdev->vendor == USB_VENDOR_ID_ELAN && 
> +                      hdev->product == USB_DEVICE_ID_ELAN_MOCCA) {
> +
> +              usb_control_msg(dev, 
> +                                              usb_sndctrlpipe(dev, 0),

> +                              HID_REQ_SET_IDLE, 
> +                                              USB_TYPE_CLASS |
USB_RECIP_INTERFACE, 
> +                                              0,
> +                              interface->desc.bInterfaceNumber, 
> +                                              NULL, 
> +                                              0, 
> +                                              USB_CTRL_SET_TIMEOUT);
> +      }
> +
> +      return 0;
> +}
> +
>  #endif
>  
>  static void mt_remove(struct hid_device *hdev)
> @@ -1092,6 +1118,7 @@ static struct hid_driver mt_driver = {
>        .event = mt_event,
>  #ifdef CONFIG_PM
>        .reset_resume = mt_reset_resume,
> +      .resume=mt_resume,
>  #endif
>  };
>  
> -- 
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
--
To unsubscribe from this list: send the line "unsubscribe linux-input" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

