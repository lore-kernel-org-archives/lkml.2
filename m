Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab1IBRxm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 13:53:42 -0400
Received: from mailb.microsoft.com ([131.107.115.215]:26336 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058Ab1IBRxi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 13:53:38 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@suse.de>, Olaf Hering <olaf@aepfle.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: [PATCH] Staging: hv: vmbus: Show the modalias in
 /sys/bus/vmbus/devices/*/
Thread-Topic: [PATCH] Staging: hv: vmbus: Show the modalias in
 /sys/bus/vmbus/devices/*/
Thread-Index: AQHMaY0RFSglJspxWUu3P1/h0ZnnU5U6vv4A//+fryA=
Date: Fri, 2 Sep 2011 17:53:37 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048081B605D@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <20110902162556.GA25073@aepfle.de>
 <20110902163550.GA5508@suse.de>
In-Reply-To: <20110902163550.GA5508@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Friday, September 02, 2011 12:36 PM
> To: Olaf Hering
> Cc: KY Srinivasan; linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> virtualization@lists.osdl.org
> Subject: Re: [PATCH] Staging: hv: vmbus: Show the modalias in
> /sys/bus/vmbus/devices/*/
> 
> On Fri, Sep 02, 2011 at 06:25:56PM +0200, Olaf Hering wrote:
> > Show a modalias file in /sys/bus/vmbus/devices/*/
> > Add a helper function to print the same content in modalias and uevent.
> >
> > Signed-off-by: Olaf Hering <olaf@aepfle.de>
> 
> Nice idea, thanks for this, one minor nit below:
> 
> > ---
> >  drivers/staging/hv/vmbus_drv.c |   21 ++++++++++++++++-----
> >  1 file changed, 16 insertions(+), 5 deletions(-)
> >
> > --- a/drivers/staging/hv/vmbus_drv.c
> > +++ b/drivers/staging/hv/vmbus_drv.c
> > @@ -93,6 +93,14 @@ static void get_channel_info(struct hv_d
> >  		debug_info.outbound.bytes_avail_towrite;
> >  }
> >
> > +#define VMBUS_ALIAS_LEN ((sizeof((struct hv_vmbus_device_id *)0)->guid)
> * 2)
> > +static void print_alias_name(struct hv_device *hv_dev, char *alias_name)
> > +{
> > +	int i;
> > +	for (i = 0; i < VMBUS_ALIAS_LEN; i += 2)
> > +		sprintf(&alias_name[i], "%02x", hv_dev->dev_type.b[i/2]);
> > +}
> > +
> >  /*
> >   * vmbus_show_device_attr - Show the device attribute in sysfs.
> >   *
> > @@ -105,6 +113,7 @@ static ssize_t vmbus_show_device_attr(st
> >  {
> >  	struct hv_device *hv_dev = device_to_hv_device(dev);
> >  	struct hv_device_info device_info;
> > +	char alias_name[VMBUS_ALIAS_LEN + 1];
> 
> Is that too big to put on the stack?  64 bytes, right?  Hm, maybe not.
> 
> Wait, hv_device_info is huge, that should be dynamic in the first place.
> Olaf, not your issue, but KY, want to fix that up?

hv_device_info is about 101 bytes. I will fix this. Greg, if you are applying Olaf's patch,
I will generate my patch on top of Olaf's. Let me know.

Regards,

K. Y

