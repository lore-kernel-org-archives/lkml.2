Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab1EVK7V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 06:59:21 -0400
Received: from www.linutronix.de ([62.245.132.108]:50155 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab1EVK7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 06:59:15 -0400
Date: Sun, 22 May 2011 12:59:08 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, balbi@ti.com,
        ablay@codeaurora.org, linux-arm-msm@vger.kernel.org,
        "'open list'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v11 4/7] usb:gadget: Add SuperSpeed support to the
 Gadget Framework
Message-ID: <20110522105908.GA26607@linutronix.de>
References: <1305805417-31750-1-git-send-email-tlinder@codeaurora.org>
 <1305805417-31750-5-git-send-email-tlinder@codeaurora.org>
 <20110520164924.GC31929@linutronix.de>
 <002401cc1850$c4cd7030$4e685090$@org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <002401cc1850$c4cd7030$4e685090$@org>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tanya Brokhman | 2011-05-22 10:20:42 [+0300]:

>Hi Sebastian
Hi Tanya,

>> >+	usb_ext = (struct usb_ext_cap_descriptor *)
>> cdev->req->buf is (void *) so you can skip that cast.
>> 
>> >+			(cdev->req->buf+bos->wTotalLength);
>> a space between + please. bos->wTotalLength is le16 so you can't simply
>> do that way.
>> 
>> What about something like
>> 
>>   usb_ext = (struct usb_ext_cap_descriptor *)(bos + 1)
>> 
>> ?
>
>Added the spaces and the le16_to_cpu(bos->wTotalLength). 
>It seems clearer to me to leave it as 
>	usb_ext = cdev->req->buf + le16_to_cpu(bos->wTotalLength);
>if that's ok with you.
Yes it is.

>
>> >@@ -499,6 +633,9 @@ static int set_config(struct usb_composite_dev
>> *cdev,
>> > 		case USB_SPEED_LOW:	speed = "low"; break;
>> > 		case USB_SPEED_FULL:	speed = "full"; break;
>> > 		case USB_SPEED_HIGH:	speed = "high"; break;
>> >+		case USB_SPEED_SUPER:
>> >+			speed = "super";
>> >+			break;
>> 
>> This is not my favorite style either but please do it the way the other
>> three are done.
>
>Well here is the dilemma: if I do it the other tree were done - I get
>checkpatch error. 
>You're right, adding this the way it's above doesn't look too good but when
>I fixed the other three I was asked not to do so in this patch, which also
>makes sense since it has nothing to do with SS support...
>So what do I do? Submit with a checkpatch error?

It is nice to have things consistent and a follow-up patch could fix the
checkpatch error(s).

>
>

Sebastian
