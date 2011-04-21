Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634Ab1DUNZH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 09:25:07 -0400
Received: from smtp.nokia.com ([147.243.1.48]:22748 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995Ab1DUNZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 09:25:05 -0400
Message-ID: <4DB030B2.7090801@nokia.com>
Date: Thu, 21 Apr 2011 16:27:14 +0300
From: Roger Quadros <roger.quadros@nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: ext Alan Stern <stern@rowland.harvard.edu>
CC: <gregkh@suse.de>, <mina86@mina86.com>, <m-sonasath@ti.com>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] usb: gadget: composite: Allow function drivers to
 defer setup responses
References: <Pine.LNX.4.44L0.1104191001590.1835-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1104191001590.1835-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.21.36.144]
X-OriginalArrivalTime: 21 Apr 2011 13:24:46.0118 (UTC) FILETIME=[7B6A2460:01CC0027]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2011 05:14 PM, ext Alan Stern wrote:
> On Tue, 19 Apr 2011, Roger Quadros wrote:
>
>> +/**
>> + * usb_composite_setup_continue() - Continue the delayed setup transfer
>
> You're should say "control transfer", not "setup transfer".  Control
> transfers consist of a setup stage, an optional data stage, and a
> status stage.  The setup stage has already ended by the time the
> function's setup handler is called.

Yes I will re-word the things and re-send the patches.

>
>> + * @cdev: the composite device who's setup transfer was delayed
>> + *
>> + * This function must be called by the USB function driver to continue
>> + * with the setup transfer's data/status phase in case it had requested to
>
> Data and Status are stages, not phases.  See section 8.5.3 of the
> USB-2.0 spec.
>
> You made these mistakes in a few different places throughout the patch.
>
>> + * delay the status phase. A USB function's setup handler (e.g. set_alt())
>> + * can request the composite framework to delay the setup request's status phase
>> + * by returning USB_GADGET_DELAYED_STATUS.
>> + */
>> +void usb_composite_setup_continue(struct usb_composite_dev *cdev)
>> +{
>> +	int			value;
>> +	struct usb_request	*req = cdev->req;
>> +	unsigned long		flags;
>> +
>> +	DBG(cdev, "%s\n", __func__);
>> +	spin_lock_irqsave(&cdev->lock, flags);
>> +
>> +	if (cdev->delayed_status == 0) {
>> +		WARN(cdev, "%s: Unexpected call\n", __func__);
>> +
>> +	} else if (--cdev->delayed_status == 0) {
>> +		DBG(cdev, "%s: Completing delayed status\n", __func__);
>> +		req->length = 0;
>> +		req->zero = 1;
>
> There's no reason to set this flag.  It has no effect when req->length
> is 0.
>
OK.

Thanks for review.

-- 
regards,
-roger
