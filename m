Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933150Ab1IJObS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 10:31:18 -0400
Received: from mail3.microsoft.com ([131.107.115.214]:11691 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932659Ab1IJObQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 10:31:16 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 09/25] Staging: hv: util: Perform some service specific
 de-initialization in util_remove()
Thread-Topic: [PATCH 09/25] Staging: hv: util: Perform some service specific
 de-initialization in util_remove()
Thread-Index: AQHMbjBjoyTUjvs280+AE6L8BBQYEJVF+wAAgACz2VA=
Date: Sat, 10 Sep 2011 14:31:15 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048081DC4C7@TK5EX14MBXC128.redmond.corp.microsoft.com>
References: <1315491843-9513-1-git-send-email-kys@microsoft.com>
 <1315491876-9554-1-git-send-email-kys@microsoft.com>
 <1315491876-9554-9-git-send-email-kys@microsoft.com>
 <20110909204240.GF19127@kroah.com>
In-Reply-To: <20110909204240.GF19127@kroah.com>
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
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Friday, September 09, 2011 4:43 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang
> Subject: Re: [PATCH 09/25] Staging: hv: util: Perform some service specific de-
> initialization in util_remove()
> 
> On Thu, Sep 08, 2011 at 07:24:20AM -0700, K. Y. Srinivasan wrote:
> > In preparation for modifying the util driver to fully conform to the
> > Linux Driver Model, perform some service specific de-initialization in
> > util_remove() as opposed to in exit_hyperv_utils() as is currently done.
> >
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > ---
> >  drivers/staging/hv/hv_util.c |   29 ++++++++++++++++++++++++-----
> >  1 files changed, 24 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/staging/hv/hv_util.c b/drivers/staging/hv/hv_util.c
> > index b86128a..2475ab2 100644
> > --- a/drivers/staging/hv/hv_util.c
> > +++ b/drivers/staging/hv/hv_util.c
> > @@ -291,6 +291,30 @@ error:
> >  static int util_remove(struct hv_device *dev,
> >  			const struct hv_vmbus_device_id *dev_id)
> >  {
> > +	int service = dev_id->driver_data;
> > +
> > +	switch (service) {
> > +	case HV_SHUTDOWN:
> > +		kfree(shut_txf_buf);
> > +		break;
> 
> This switch and "static" pointers you need to free aren't needed at all
> if you do this code logic correctly (i.e. a per-device buffer.)
> 
> {sigh}
> 
> I'm stopping reviewing now, this is making me grumpy, someone owes me a
> bunch of beer...

Greg,

I will rework this to be more on the lines of what you had suggested; and yes,
I remember my original promise! I want to re-spin these patches and send it to 
you as soon as possible. Which tree can I clone to get your latest check-ins; kernel.org
still seems to have issues this morning. Have you checked in Olaf's patches.

Thanks,

K. Y

