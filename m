Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699Ab1IMU5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 16:57:53 -0400
Received: from mail3.microsoft.com ([131.107.115.214]:39176 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932556Ab1IMU5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 16:57:52 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Joe Perches <joe@perches.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 1/1] Staging: hv: netvsc: Cleanup the name and type of
 link_stat variable
Thread-Topic: [PATCH 1/1] Staging: hv: netvsc: Cleanup the name and type of
 link_stat variable
Thread-Index: AQHMck8mQFx3XNhN9ke9w2n7Kx84OZVMMXoA//+Yu+A=
Date: Tue, 13 Sep 2011 20:57:50 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048081E4D9D@TK5EX14MBXC124.redmond.corp.microsoft.com>
References: <1315943618-22308-1-git-send-email-kys@microsoft.com>
 <1315944283.25776.14.camel@Joe-Laptop>
In-Reply-To: <1315944283.25776.14.camel@Joe-Laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.33]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p8DKw4Iv018862



> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com]
> Sent: Tuesday, September 13, 2011 4:05 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang
> Subject: Re: [PATCH 1/1] Staging: hv: netvsc: Cleanup the name and type of
> link_stat variable
> 
> On Tue, 2011-09-13 at 12:53 -0700, K. Y. Srinivasan wrote:
> > Consistently name the variable tracking the link status. Use a consistent
> > type for this variable and get rid of some unnecessary parentheses as well.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > ---
> >  drivers/staging/hv/rndis_filter.c |    8 ++++----
> >  1 files changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/staging/hv/rndis_filter.c b/drivers/staging/hv/rndis_filter.c
> > index 963582a..696d2c5 100644
> > --- a/drivers/staging/hv/rndis_filter.c
> > +++ b/drivers/staging/hv/rndis_filter.c
> > @@ -41,7 +41,7 @@ struct rndis_device {
> >  	struct netvsc_device *net_dev;
> >
> >  	enum rndis_device_state state;
> > -	u32 link_stat;
> > +	bool link_state;
> >  	atomic_t new_req_id;
> >
> >  	spinlock_t request_lock;
> > @@ -514,7 +514,7 @@ static int rndis_filter_query_device_link_status(struct
> rndis_device *dev)
> >
> >  	return rndis_filter_query_device(dev,
> >  				      RNDIS_OID_GEN_MEDIA_CONNECT_STATUS,
> > -				      &dev->link_stat, &size);
> > +				      &dev->link_state, &size);
> 
> Are you sure you can do this?
> You're changing the info request from u32 to bool
> without changing the size above it

Oops! I will fix this.

> 
> 	u32 size = sizeof(u32);
> 
> 
> >  }
> >
> >  static int rndis_filter_set_packet_filter(struct rndis_device *dev,
> > @@ -736,11 +736,11 @@ int rndis_filter_device_add(struct hv_device *dev,
> >
> >  	rndis_filter_query_device_link_status(rndis_device);
> >
> > -	device_info->link_state = rndis_device->link_stat;
> > +	device_info->link_state = rndis_device->link_state;
> >
> >  	dev_info(&dev->device, "Device MAC %pM link state %s",
> >  		 rndis_device->hw_mac_adr,
> > -		 ((device_info->link_state) ? ("down\n") : ("up\n")));
> > +		 device_info->link_state ? "down\n" : "up\n");
> 
> It's better to remove the multiple "\n"s from "up" and "down"
> and move it to the format string as I suggested.

I will fix it.

Thank you,

K. Y

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
