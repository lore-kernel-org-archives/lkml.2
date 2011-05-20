Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756987Ab1ETPYr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 11:24:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:53448 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626Ab1ETPYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 11:24:46 -0400
Date: Fri, 20 May 2011 17:24:39 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, balbi@ti.com,
        ablay@codeaurora.org, linux-arm-msm@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v11 2/7] usb: Configure endpoint according to gadget
 speed.
Message-ID: <20110520152439.GA31929@linutronix.de>
References: <1305805417-31750-1-git-send-email-tlinder@codeaurora.org>
 <1305805417-31750-3-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1305805417-31750-3-git-send-email-tlinder@codeaurora.org>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tatyana Brokhman | 2011-05-19 14:43:27 [+0300]:

>diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
>index 5cbb1a4..cfba1ee 100644
>--- a/drivers/usb/gadget/composite.c
>+++ b/drivers/usb/gadget/composite.c
>@@ -27,6 +27,7 @@
> #include <linux/utsname.h>
> 
> #include <linux/usb/composite.h>
>+#include <linux/byteorder/generic.h>

Just applied that patch on v39 + usb-next nad it builds without this
line. Why is it required?

>diff --git a/include/linux/usb/composite.h b/include/linux/usb/composite.h
>index b78cba4..324fbc7 100644
>--- a/include/linux/usb/composite.h
>+++ b/include/linux/usb/composite.h
>@@ -146,6 +146,27 @@ int usb_function_activate(struct usb_function *);
> int usb_interface_id(struct usb_configuration *, struct usb_function *);
> 
> /**
>+ * config_ep_by_speed() - configures the given endpoint
>+ * according to gadget speed.
>+ * @g: pointer to the gadget
>+ * @f: usb function
>+ * @_ep: the endpoint to configure
>+ *
>+ * Return: error code, 0 on success
>+ *
>+ * This function chooses the right descriptors for a given
>+ * endpoint according to gadget speed and saves it in the
>+ * endpoint desc field. If the endpoint already has a descriptor
>+ * assigned to it - overwrites it with currently corresponding
>+ * descriptor. The endpoint maxpacket field is updated according
>+ * to the chosen descriptor.
>+ * Note: the supplied function should hold all the descriptors
>+ * for supported speeds
>+ */

Didn't we aggree on not adding the same kerneldoc to function's
prototype and the actual function? Please add it only to the function's
implemention.

>+int config_ep_by_speed(struct usb_gadget *g, struct usb_function *f,
>+			struct usb_ep *_ep);
>+

Sebastian
