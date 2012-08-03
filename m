Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750Ab2HCH1H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 03:27:07 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:40168 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751118Ab2HCH1G convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 03:27:06 -0400
From: Virupax SADASHIVPETIMATH <virupax.sadashivpetimath@stericsson.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Praveena NADAHALLY <praveen.nadahally@stericsson.com>,
        Vikrant BAPAT <vikrant.bapat@stericsson.com>,
        Rajaram REGUPATHY <ragupathy.rajaram@stericsson.com>
Date: Fri, 3 Aug 2012 09:26:29 +0200
Subject: RE: [PATCH] usb:musb:musb_host: Handle highmem in PIO mode
Thread-Topic: [PATCH] usb:musb:musb_host: Handle highmem in PIO mode
Thread-Index: Ac1wveIxNZ/EtknUSuCr/sHqAgVZdQAiwtdw
Message-ID: <A3217089E06965468FCEC60ADC3A8F925C21599D6E@EXDCVYMBSTM006.EQ1STM.local>
References: <1343889402-7826-1-git-send-email-virupax.sadashivpetimath@stericsson.com>
 <Pine.LNX.4.44L0.1208021046280.1285-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1208021046280.1285-100000@iolanthe.rowland.org>
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
> Sent: Thursday, August 02, 2012 8:18 PM
> To: Virupax SADASHIVPETIMATH
> Cc: balbi@ti.com; gregkh@linuxfoundation.org; linux-usb@vger.kernel.org; linux-
> kernel@vger.kernel.org; Praveena NADAHALLY
> Subject: Re: [PATCH] usb:musb:musb_host: Handle highmem in PIO mode
> 
 
> > --- a/include/linux/usb.h
> > +++ b/include/linux/usb.h
> > @@ -21,6 +21,7 @@
> >  #include <linux/sched.h>	/* for current && schedule_timeout */
> >  #include <linux/mutex.h>	/* for struct mutex */
> >  #include <linux/pm_runtime.h>	/* for runtime PM */
> > +#include <linux/scatterlist.h>
> >
> >  struct usb_device;
> >  struct usb_driver;
> > @@ -1309,6 +1310,7 @@ struct urb {
> >  	usb_complete_t complete;	/* (in) completion routine */
> >  	struct usb_iso_packet_descriptor iso_frame_desc[0];
> >  					/* (in) ISO ONLY */
> > +	struct sg_mapping_iter sg_miter; /* handling highmem data in PIO mode */
> >  };
> 
> This is unacceptable.  Fields like this should be stored in the
> URB's hcpriv structure, not in the URB itself.

Ok I will add it in the hcpriv structure. Can you please comment on other
 part of the code also, so that all the changes can be done together. 

Thanks 
Virupax S 
