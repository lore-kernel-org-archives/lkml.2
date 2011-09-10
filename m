Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933075Ab1IJOWY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 10:22:24 -0400
Received: from smtp.microsoft.com ([131.107.115.215]:24937 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201Ab1IJOWX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 10:22:23 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 10/25] Staging: hv: vmbus: Return proper error code in
 vmbus_remove()
Thread-Topic: [PATCH 10/25] Staging: hv: vmbus: Return proper error code in
 vmbus_remove()
Thread-Index: AQHMbjAU595ywkxixESd2JJsXOcWvpVF+yOAgACx6dA=
Date: Sat, 10 Sep 2011 14:22:22 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048081DC4B3@TK5EX14MBXC128.redmond.corp.microsoft.com>
References: <1315491843-9513-1-git-send-email-kys@microsoft.com>
 <1315491876-9554-1-git-send-email-kys@microsoft.com>
 <1315491876-9554-10-git-send-email-kys@microsoft.com>
 <20110909204309.GG19127@kroah.com>
In-Reply-To: <20110909204309.GG19127@kroah.com>
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
> Subject: Re: [PATCH 10/25] Staging: hv: vmbus: Return proper error code in
> vmbus_remove()
> 
> On Thu, Sep 08, 2011 at 07:24:21AM -0700, K. Y. Srinivasan wrote:
> > Return proper error code in vmbus_remove().
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > ---
> >  drivers/staging/hv/vmbus_drv.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
> > index b9aeb76..95d33a4 100644
> > --- a/drivers/staging/hv/vmbus_drv.c
> > +++ b/drivers/staging/hv/vmbus_drv.c
> > @@ -325,7 +325,7 @@ static int vmbus_probe(struct device *child_device)
> >   */
> >  static int vmbus_remove(struct device *child_device)
> >  {
> > -	int ret;
> > +	int ret = 0;
> 
> As remove functions can't fail, why return anything at all?
> 
> Doesn't make sense, please fix.

Greg,

Looking at the struct bus_type, the remove function is not a void function.
I was just fixing something that was broken in this function.

Regards,

K. Y

