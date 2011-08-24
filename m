Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab1HXAop (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 20:44:45 -0400
Received: from smtp.microsoft.com ([131.107.115.214]:53265 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab1HXAoj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 20:44:39 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 003/117] Staging: hv: Add struct hv_vmbus_device_id to
 mod_devicetable.h
Thread-Topic: [PATCH 003/117] Staging: hv: Add struct hv_vmbus_device_id to
 mod_devicetable.h
Thread-Index: AQHMQxTTgzmsMn/8gUaVtEtcxauI8JUruumA//+rW0A=
Date: Wed, 24 Aug 2011 00:44:38 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048081B236E@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-3-git-send-email-kys@microsoft.com>
 <20110823224157.GA9641@kroah.com>
In-Reply-To: <20110823224157.GA9641@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.78]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Tuesday, August 23, 2011 6:42 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang
> Subject: Re: [PATCH 003/117] Staging: hv: Add struct hv_vmbus_device_id to
> mod_devicetable.h
> 
> On Fri, Jul 15, 2011 at 10:45:51AM -0700, K. Y. Srinivasan wrote:
> > In preparation for implementing vmbus aliases for auto-loading
> > Hyper-V drivers, define vmbus specific device ID.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > ---
> >  include/linux/mod_devicetable.h |    7 +++++++
> >  1 files changed, 7 insertions(+), 0 deletions(-)
> >
> > diff --git a/include/linux/mod_devicetable.h
> b/include/linux/mod_devicetable.h
> > index ae28e93..5a12377 100644
> > --- a/include/linux/mod_devicetable.h
> > +++ b/include/linux/mod_devicetable.h
> > @@ -405,6 +405,13 @@ struct virtio_device_id {
> >  };
> >  #define VIRTIO_DEV_ANY_ID	0xffffffff
> >
> > +/*
> > + * For Hyper-V devices we use the device guid as the id.
> > + */
> > +struct hv_vmbus_device_id {
> > +	__u8 guid[16];
> > +};
> 
> Why do you not need a driver_data pointer here?  Are you sure you aren't
> ever going to need it in the future?  Hint, I think you will...

I am not sure I am following you here; the guid is the device ID and it is 
guaranteed to remain the same. What is the driver _data pointer here 
you are referring to here.  While some device id have the _data pointer,
there are others that don't - for instance struct virtio_device_id. In 
our case, I am not sure how I would use this private pointer.

Regards,

K. Y
> 
> greg k-h

