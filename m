Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353Ab2HHGlK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 02:41:10 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:50840 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753114Ab2HHGlI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 02:41:08 -0400
From: Virupax SADASHIVPETIMATH <virupax.sadashivpetimath@stericsson.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        Praveena NADAHALLY <praveen.nadahally@stericsson.com>,
        Rajaram REGUPATHY <ragupathy.rajaram@stericsson.com>,
        Vikrant BAPAT <vikrant.bapat@stericsson.com>
Date: Wed, 8 Aug 2012 08:40:04 +0200
Subject: RE: [PATCH v2] usb:musb:musb_host: Handle highmem in PIO mode
Thread-Topic: [PATCH v2] usb:musb:musb_host: Handle highmem in PIO mode
Thread-Index: Ac10xLEUMQGO1YJGRliYZ6gSOaIyDwAZi58g
Message-ID: <A3217089E06965468FCEC60ADC3A8F925C21652138@EXDCVYMBSTM006.EQ1STM.local>
References: <1344330980-9064-1-git-send-email-virupax.sadashivpetimath@stericsson.com>
 <Pine.LNX.4.44L0.1208071342410.2400-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1208071342410.2400-100000@iolanthe.rowland.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Alan Stern [mailto:stern@rowland.harvard.edu]
> Sent: Tuesday, August 07, 2012 11:17 PM
> To: Virupax SADASHIVPETIMATH
> Cc: balbi@ti.com; gregkh@linuxfoundation.org; linux-usb@vger.kernel.org; linux-
> kernel@vger.kernel.org; linus.walleij@linaro.org; Praveena NADAHALLY; Rajaram
> REGUPATHY; Vikrant BAPAT
> Subject: Re: [PATCH v2] usb:musb:musb_host: Handle highmem in PIO mode
> 
> 
> > +	 */
> > +	if (!urb->transfer_buffer)
> > +		use_sg = true;
> 
> Here you test urb->transfer_buffer.

I will make the test as 
	if (!use_sg && !urb->transfer_buffer)
		use_sg = true;

> > +	if (use_sg) {
> > +		/* sg_miter_start is already done in musb_ep_program */
> > +		if (!sg_miter_next(&qh->sg_miter)) {
> > +			dev_err(musb->controller, "error: sg list empty\n");
> > +			sg_miter_stop(&qh->sg_miter);
> > +			status = -EINVAL;
> > +			goto done;
> > +		}
> > +		urb->transfer_buffer = qh->sg_miter.addr;
> 
> And here you set it.  As a result, on the next iteration of this
> routine the test above won't work right.  (This function gets invoked
> once for each entry in the sg list, right?)
> 
> Is there any reason to set urb->transfer_buffer here?  You could just
> use qh->sg_miter.addr directly in the musb_write_fifo() call two lines
> below.

I will change it. 

Thanks 
Virupax S 


