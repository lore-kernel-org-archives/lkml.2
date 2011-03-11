Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149Ab1CKDRt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 22:17:49 -0500
Received: from smtp.microsoft.com ([131.107.115.214]:31046 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab1CKDRr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 22:17:47 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "Mike Sterling" <Mike.Sterling@microsoft.com>,
        "Abhishek Kane (Mindtree Consulting PVT LTD)" 
	<v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: RE: [PATCH 13/21] [PATCH 13/21] Staging: hv: Rename
 vmbus_driver_context structure
Thread-Topic: [PATCH 13/21] [PATCH 13/21] Staging: hv: Rename
 vmbus_driver_context structure
Thread-Index: AQHL33NwKc0pOySQ6kS2FqvDfbI2lJQnsgwA///BrCA=
Date: Fri, 11 Mar 2011 03:17:46 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048018BBD@TK5EX14MBXC128.redmond.corp.microsoft.com>
References: <[PATCH 00/21] Staging: hv: Cleanup vmbus driver>
 <1299795131-1335-1-git-send-email-kys@microsoft.com>
 <alpine.LFD.2.00.1103102347450.2787@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1103102347450.2787@localhost6.localdomain6>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.123.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> Sent: Thursday, March 10, 2011 5:50 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang; Mike
> Sterling; Abhishek Kane (Mindtree Consulting PVT LTD); Hank Janssen
> Subject: Re: [PATCH 13/21] [PATCH 13/21] Staging: hv: Rename
> vmbus_driver_context structure
> 
> On Thu, 10 Mar 2011, K. Y. Srinivasan wrote:
> > Now that struct vmbus_driver_context is properly
> > cleaned up, rename this structure appropriately and
> > cleanup the code.
> 
> > @@ -877,10 +873,10 @@ static irqreturn_t vmbus_isr(int irq, void *dev_id)
> >  	/* Schedules a dpc if necessary */
> >  	if (ret > 0) {
> >  		if (test_bit(0, (unsigned long *)&ret))
> > -			tasklet_schedule(&vmbus_drv.msg_dpc);
> > +			tasklet_schedule(&hv_bus.msg_dpc);
> >
> >  		if (test_bit(1, (unsigned long *)&ret))
> > -			tasklet_schedule(&vmbus_drv.event_dpc);
> > +			tasklet_schedule(&hv_bus.event_dpc);
> 
> What's the plan to convert that tasklet/work stuff to threaded irqs ?


This is on my plate; I was going to work on this after I addressed all other issues 
preventing the vmbus driver from exiting staging.

Regards,

K. Y 


