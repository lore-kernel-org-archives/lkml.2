Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934340Ab1EWWTL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 18:19:11 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44220 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934318Ab1EWWTH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 18:19:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=VyBxQIcyqrxYI8iJdiDev7ZrwEtGZ3NuarbFy72y8ydXtEkr5JfIs0qDve7TRENJsY
         bsg/Sy5tnSFlLiCJvaFpzVZIs7QsxMi0xvDx5albWMEUvIHxrzxCEiP7q8PiPfION1hM
         S12N8KSvFD2ZiTKO0NzPA5p4m490MXzmcSYno=
MIME-Version: 1.0
In-Reply-To: <20110523123135.GA10785@linutronix.de>
References: <1306132882-9668-1-git-send-email-tlinder@codeaurora.org>
 <1306132882-9668-5-git-send-email-tlinder@codeaurora.org> <20110523123135.GA10785@linutronix.de>
From: Mike Frysinger <vapier@gentoo.org>
Date: Mon, 23 May 2011 18:18:45 -0400
X-Google-Sender-Auth: daJPIBKLWJ1v8_tNlKuIVYcreTc
Message-ID: <BANLkTimuG8wr4kOpaEL58W3CoiWrgYHB4A@mail.gmail.com>
Subject: Re: [PATCH v12 4/8] usb:gadget: Add SuperSpeed support to the Gadget Framework
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        balbi@ti.com, ablay@codeaurora.org,
        open list <linux-kernel@vger.kernel.org>,
        Tatyana Brokhman <tlinder@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 08:31, Sebastian Andrzej Siewior wrote:
> * Tatyana Brokhman | 2011-05-23 09:41:13 [+0300]:
>>diff --git a/drivers/usb/gadget/composite.c
>>b/drivers/usb/gadget/composite.c
>>index 1c6bd66..7738302 100644
>>--- a/drivers/usb/gadget/composite.c
>>+++ b/drivers/usb/gadget/composite.c
>>@@ -1015,6 +1175,62 @@ composite_setup(struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
>>               *((u8 *)req->buf) = value;
>>               value = min(w_length, (u16) 1);
>>               break;
>>+
>>+      /*
>>+       * USB 3.0 additions:
>>+       * Function driver should handle get_status request. If such cb
>>+       * wasn't supplied we respond with default value = 0
>>+       * Note: function driver should supply such cb only for the first
>>+       * interface of the function
>>+       */
>>+      case USB_REQ_GET_STATUS:
>>+              if (!gadget_is_superspeed(gadget))
>>+                      goto unknown;
>>+              if (ctrl->bRequestType != (USB_DIR_IN | USB_RECIP_INTERFACE))
>>+                      goto unknown;
>>+              value = 2;      /* This is the length of the get_status reply */
>>+              *((__le16 *)req->buf) = 0;
>
> Mike please correct me if I'm wrong bug this looks like a case for
> put_unaligned_le16().
> Is someone actually using gadget support on blackfin? I'm asking because
> config_buf() (same file, upstream) is using req->buf to build the
> descriptors in place and one element is le16 which should be affected.

yes, we do gadget stuff heavily on Blackfin with a few different
controllers.  if things broke, we'd be unhappy ;).
-mike
