Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab1DZUX2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 16:23:28 -0400
Received: from mail3.microsoft.com ([131.107.115.214]:45295 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab1DZUX1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 16:23:27 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "Haiyang Zhang" <haiyangz@microsoft.com>,
        "Abhishek Kane (Mindtree Consulting PVT LTD)" 
	<v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: RE: [PATCH 18/25] Staging: hv: Get rid of struct hv_bus
Thread-Topic: [PATCH 18/25] Staging: hv: Get rid of struct hv_bus
Thread-Index: AQHMBCwn1s6JBZAG00mF/Gjulq2PA5RxAJqA//+U6AA=
Date: Tue, 26 Apr 2011 20:23:25 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481DD061@TK5EX14MBXC124.redmond.corp.microsoft.com>
References: <1303834785-4981-1-git-send-email-kys@microsoft.com>
 <1303834842-5022-1-git-send-email-kys@microsoft.com>
 <1303834842-5022-18-git-send-email-kys@microsoft.com>
 <20110426194031.GD17467@suse.de>
In-Reply-To: <20110426194031.GD17467@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.35]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Tuesday, April 26, 2011 3:41 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> virtualization@lists.osdl.org; Haiyang Zhang; Abhishek Kane (Mindtree Consulting
> PVT LTD); Hank Janssen
> Subject: Re: [PATCH 18/25] Staging: hv: Get rid of struct hv_bus
> 
> On Tue, Apr 26, 2011 at 09:20:35AM -0700, K. Y. Srinivasan wrote:
> > Now, get rid of struct hv_bus. We will no longer be embedding
> > struct bus_type.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
> > Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
> > ---
> >  drivers/staging/hv/vmbus_drv.c |   33 ++++++++++++++-------------------
> >  1 files changed, 14 insertions(+), 19 deletions(-)
> >
> > diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
> > index a3a7741..515311c 100644
> > --- a/drivers/staging/hv/vmbus_drv.c
> > +++ b/drivers/staging/hv/vmbus_drv.c
> > @@ -45,11 +45,6 @@ static struct pci_dev *hv_pci_dev;
> >  static struct tasklet_struct msg_dpc;
> >  static struct tasklet_struct event_dpc;
> >
> > -/* Main vmbus driver data structure */
> > -struct hv_bus {
> > -	struct bus_type bus;
> > -};
> > -
> >  unsigned int vmbus_loglevel = (ALL_MODULES << 16 | INFO_LVL);
> >  EXPORT_SYMBOL(vmbus_loglevel);
> >  	/* (ALL_MODULES << 16 | DEBUG_LVL_ENTEREXIT); */
> > @@ -405,14 +400,14 @@ static void vmbus_device_release(struct device
> *device)
> >  }
> >
> >  /* The one and only one */
> > -static struct hv_bus  hv_bus = {
> > -	.bus.name =		"vmbus",
> > -	.bus.match =		vmbus_match,
> > -	.bus.shutdown =		vmbus_shutdown,
> > -	.bus.remove =		vmbus_remove,
> > -	.bus.probe =		vmbus_probe,
> > -	.bus.uevent =		vmbus_uevent,
> > -	.bus.dev_attrs =	vmbus_device_attrs,
> > +static struct bus_type  hv_bus = {
> > +	.name =		"vmbus",
> > +	.match =		vmbus_match,
> > +	.shutdown =		vmbus_shutdown,
> > +	.remove =		vmbus_remove,
> > +	.probe =		vmbus_probe,
> > +	.uevent =		vmbus_uevent,
> > +	.dev_attrs =	vmbus_device_attrs,
> >  };
> >
> >  static const char *driver_name = "hyperv";
> > @@ -550,14 +545,14 @@ static int vmbus_bus_init(struct pci_dev *pdev)
> >  		goto cleanup;
> >  	}
> >
> > -	hv_bus.bus.name = driver_name;
> > +	hv_bus.name = driver_name;
> 
> Why are you setting the name of the bus again?  Shouldn't this line be
> removed?

You are absolutely right. Since this redundancy was in the existing
code, should I send you a separate patch to fix this?

Regards,

K. Y

> 
> thanks,
> 
> greg k-h

