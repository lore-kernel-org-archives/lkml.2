Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361Ab1DMJzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 05:55:33 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:29561 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab1DMJzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 05:55:32 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6314"; a="85316567"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: "'Sebastian Andrzej Siewior'" <bigeasy@linutronix.de>
Cc: <gregkh@suse.de>, <linux-arm-msm@vger.kernel.org>, <balbi@ti.com>,
        <ablay@codeaurora.org>,
        "'open list:USB GADGET/PERIPH...'" <linux-usb@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
References: <1300867445-20911-1-git-send-email-tlinder@codeaurora.org> <20110411141404.GC4018@linutronix.de>
In-Reply-To: <20110411141404.GC4018@linutronix.de>
Subject: RE: [PATCH/RESEND 3/5 v4] usb: Configure endpoint according to gadget speed.
Date: Wed, 13 Apr 2011 12:56:27 +0300
Message-ID: <001701cbf9c1$11875fc0$34961f40$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acv4Ur14D0Hbjgc7ToK6TO8vVTce5gBbbWcw
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >+	/* find descriptors */
> >+	for (d_spd = next_ep_desc(speed_desc); d_spd;
> >+	      d_spd = next_ep_desc(d_spd+1)) {
> 
> this might look better if you would something like the list_for_each()
> macro.

The function next_ep_desc() goes over the endpoint descriptors (struct
usb_descriptor_header). It's not a list so I don't see how the
list_for_each() macro can be used here. Am I missing something?

> > /**
> >+ * config_ep_by_speed() - configures the given endpoint
> >+ * according to gadget speed.
> >+ * @g: pointer to the gadget
> >+ * @f: usb function
> >+ * @_ep: the endpoint to configure
> >+ *
> >+ * Return: error code, 0 on success
> >+ *
> >+ * This function chooses the right descriptors for a given
> >+ * endpoint according to gadget speed and saves in in the
> >+ * endpoint desc field. If the endpoint already has a descriptor
> >+ * assigned to it - overwrites it with currently corresponding
> >+ * descriptor. The endpoint maxpacket field is updated according
> >+ * to the choosen descriptor.
> >+ * Note: the supplied function should hold all the descriptors
> >+ * for supported speeds
> >+ */
> 
> You have the same comment (including the same typo) here and in the .c.
> Please use only on (in the .c file) as they will go async.

Thanks for noticing that! 
What do you mean by "they will go async"? Is there some sort of automation
that updates the comments for functions from c files to the headers? I'm not
familiar with such...


Best regards,
Tanya Brokhman
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum




