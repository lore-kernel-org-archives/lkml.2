Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934047Ab1IJUdU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 16:33:20 -0400
Received: from mail2.microsoft.com ([131.107.115.215]:41005 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933495Ab1IJUdT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 16:33:19 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: Greg KH <greg@kroah.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 10/25] Staging: hv: vmbus: Return proper error code in
 vmbus_remove()
Thread-Topic: [PATCH 10/25] Staging: hv: vmbus: Return proper error code in
 vmbus_remove()
Thread-Index: AQHMbjAU595ywkxixESd2JJsXOcWvpVF+yOAgACx6dCAALw6AP//q5mQ
Date: Sat, 10 Sep 2011 20:33:18 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048081DC530@TK5EX14MBXC128.redmond.corp.microsoft.com>
References: <1315491843-9513-1-git-send-email-kys@microsoft.com>
 <1315491876-9554-1-git-send-email-kys@microsoft.com>
 <1315491876-9554-10-git-send-email-kys@microsoft.com>
 <20110909204309.GG19127@kroah.com>
 <6E21E5352C11B742B20C142EB499E048081DC4B3@TK5EX14MBXC128.redmond.corp.microsoft.com>
 <20110910183336.GB30865@suse.de>
In-Reply-To: <20110910183336.GB30865@suse.de>
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
> Sent: Saturday, September 10, 2011 2:34 PM
> To: KY Srinivasan
> Cc: Greg KH; linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> virtualization@lists.osdl.org; Haiyang Zhang
> Subject: Re: [PATCH 10/25] Staging: hv: vmbus: Return proper error code in
> vmbus_remove()
> 
> On Sat, Sep 10, 2011 at 02:22:22PM +0000, KY Srinivasan wrote:
> >
> >
> > > -----Original Message-----
> > > From: Greg KH [mailto:greg@kroah.com]
> > > Sent: Friday, September 09, 2011 4:43 PM
> > > To: KY Srinivasan
> > > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> > > devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang
> > > Subject: Re: [PATCH 10/25] Staging: hv: vmbus: Return proper error code in
> > > vmbus_remove()
> > >
> > > On Thu, Sep 08, 2011 at 07:24:21AM -0700, K. Y. Srinivasan wrote:
> > > > Return proper error code in vmbus_remove().
> > > >
> > > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > > > ---
> > > >  drivers/staging/hv/vmbus_drv.c |    4 ++--
> > > >  1 files changed, 2 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/drivers/staging/hv/vmbus_drv.c
> b/drivers/staging/hv/vmbus_drv.c
> > > > index b9aeb76..95d33a4 100644
> > > > --- a/drivers/staging/hv/vmbus_drv.c
> > > > +++ b/drivers/staging/hv/vmbus_drv.c
> > > > @@ -325,7 +325,7 @@ static int vmbus_probe(struct device *child_device)
> > > >   */
> > > >  static int vmbus_remove(struct device *child_device)
> > > >  {
> > > > -	int ret;
> > > > +	int ret = 0;
> > >
> > > As remove functions can't fail, why return anything at all?
> > >
> > > Doesn't make sense, please fix.
> >
> > Greg,
> >
> > Looking at the struct bus_type, the remove function is not a void function.
> 
> Yeah, but it's never checked, and most bus types just use a void
> function as the function can not fail (or, it's not allowed to at
> least.)
> 
> > I was just fixing something that was broken in this function.
> 
> That's fine, then you can add it to the list of things to change :)

Ok; I will do what is done in pci_device_remove().

Regards,

K. Y

