Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188Ab1HXA6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 20:58:42 -0400
Received: from smtp.microsoft.com ([131.107.115.215]:23302 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749Ab1HXA6h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 20:58:37 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 086/117] Staging: hv: storvsc: Leverage the spinlock to
 manage ref_cnt
Thread-Topic: [PATCH 086/117] Staging: hv: storvsc: Leverage the spinlock to
 manage ref_cnt
Thread-Index: AQHMQxTTgKIq9Plk/0mMzxNJa+Ov05UrwuAA//+oJ+A=
Date: Wed, 24 Aug 2011 00:58:36 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048081B239E@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-86-git-send-email-kys@microsoft.com>
 <20110823231028.GO9641@kroah.com>
In-Reply-To: <20110823231028.GO9641@kroah.com>
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
> Sent: Tuesday, August 23, 2011 7:10 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang
> Subject: Re: [PATCH 086/117] Staging: hv: storvsc: Leverage the spinlock to
> manage ref_cnt
> 
> On Fri, Jul 15, 2011 at 10:47:14AM -0700, K. Y. Srinivasan wrote:
> > Now that we have a spin lock protecting access to the stor device pointer,
> > use it manage the reference count as well.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > ---
> >  drivers/staging/hv/hyperv_storage.h |    8 ++++----
> >  drivers/staging/hv/storvsc.c        |   10 +++++-----
> >  2 files changed, 9 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/staging/hv/hyperv_storage.h
> b/drivers/staging/hv/hyperv_storage.h
> > index 53b65be..d946211 100644
> > --- a/drivers/staging/hv/hyperv_storage.h
> > +++ b/drivers/staging/hv/hyperv_storage.h
> > @@ -265,7 +265,7 @@ struct storvsc_device {
> >  	struct hv_device *device;
> >
> >  	/* 0 indicates the device is being destroyed */
> > -	atomic_t ref_count;
> > +	int	 ref_count;
> 
> Is this really needed?  Can't you rely on the reference count of the
> hv_device itself?

We don't have a reference count on the hv_device and this count is taken
to deal with racing unloads and incoming traffic on the channel from the 
host. 

Regards,

K. Y

