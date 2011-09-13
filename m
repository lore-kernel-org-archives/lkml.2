Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab1IMBdg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 21:33:36 -0400
Received: from smtp-out.google.com ([216.239.44.51]:30227 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab1IMBdc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 21:33:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=BeuKH9lp/vHi4Vn3/R4qcT5JETMhPbJTSCHsMj1ijlcZByXLYHAXz3A2jU173nd8B
	GnJN1/ZFN2i90rAZWyfCw==
MIME-Version: 1.0
In-Reply-To: <1315008447-11012-1-git-send-email-bleung@chromium.org>
References: <1315008447-11012-1-git-send-email-bleung@chromium.org>
Date: Mon, 12 Sep 2011 18:29:20 -0700
X-Google-Sender-Auth: NokCakoQYkoLQmRHOyd0kgcRogA
Message-ID: <CANLzEkto=6itnTXz3cwsjNUS0UR5knMzyut7-m8_Mfw9fNMsMw@mail.gmail.com>
Subject: Re: [PATCH] HID: usbhid: fix suspend timeout due to RUNNING bits
From: Benson Leung <bleung@chromium.org>
To: jkosina@suse.cz, linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: bleung@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping. Would someone in linux-usb take a look at this fix?

Thanks,
Benson

On Fri, Sep 2, 2011 at 5:07 PM, Benson Leung <bleung@chromium.org> wrote:
> hid_submit_ctrl and hid_submit_out should return error
> codes when HID_REPORTED_IDLE is set by hid_suspend.
> This will allow the output and control completion
> handlers to clear HID_OUT_RUNNING and HID_CTRL_RUNNING
> so hid_suspend succeeds.
>
> Previously, if there were outstanding out messages
> or control messages while hid_suspend was called,
> hid_suspend would fail because usbhid_wait_io would time
> out.
>
> This condition happens with USB keyboards with both capslock and
> numlock leds enabled at suspend time. Control requests
> will come down to the hid-core to disable both leds, with
> hid_suspend being called between the two being submitted.
>
> Signed-off-by: Benson Leung <bleung@chromium.org>
> ---
>  drivers/hid/usbhid/hid-core.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
> index a9fa294..cf5c106 100644
> --- a/drivers/hid/usbhid/hid-core.c
> +++ b/drivers/hid/usbhid/hid-core.c
> @@ -326,6 +326,8 @@ static int hid_submit_out(struct hid_device *hid)
>                        return -1;
>                }
>                usbhid->last_out = jiffies;
> +       } else {
> +               return -1;
>        }
>
>        return 0;
> @@ -385,6 +387,8 @@ static int hid_submit_ctrl(struct hid_device *hid)
>                        return -1;
>                }
>                usbhid->last_ctrl = jiffies;
> +       } else {
> +               return -1;
>        }
>
>        return 0;
> --
> 1.7.1
>
>



-- 
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org
