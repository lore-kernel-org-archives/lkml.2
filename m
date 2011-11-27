Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796Ab1K0J06 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 04:26:58 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:54413 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750959Ab1K0J04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 04:26:56 -0500
X-Sasl-enc: 7UY+OuU+4dltixwNMAKc8pKcHpoiKXLxZqa1tVsVabtb 1322386013
Date: Sat, 26 Nov 2011 16:59:28 -0800
From: Greg KH <greg@kroah.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "joe@perches.com" <joe@perches.com>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "jkosina@suse.cz" <jkosina@suse.cz>
Subject: Re: [PATCH 3/3] Staging: hv: mousevsc: Use the KBUILD_MODNAME macro
Message-ID: <20111127005928.GA19088@kroah.com>
References: <1319839847-28959-1-git-send-email-kys@microsoft.com>
 <1319839888-29000-1-git-send-email-kys@microsoft.com>
 <1319839888-29000-3-git-send-email-kys@microsoft.com>
 <ADE657CA350FB648AAC2C43247A983F001F39DEE70F6@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F001F39DEE70F6@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 06:02:22PM -0500, H Hartley Sweeten wrote:
> On Friday, October 28, 2011 3:11 PM, K. Y. Srinivasan wrote:
> > 
> > Use the KBUILD_MODNAME macro.
> > 
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > ---
> >  drivers/staging/hv/hv_mouse.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
> > index c22f729..2c2e1b4 100644
> > --- a/drivers/staging/hv/hv_mouse.c
> > +++ b/drivers/staging/hv/hv_mouse.c
> > @@ -578,7 +578,7 @@ static const struct hv_vmbus_device_id id_table[] = {
> >  MODULE_DEVICE_TABLE(vmbus, id_table);
> >  
> >  static struct  hv_driver mousevsc_drv = {
> > -	.name = "mousevsc",
> > +	.name = KBUILD_MODNAME,
> >  	.id_table = id_table,
> >  	.probe = mousevsc_probe,
> >  	.remove = mousevsc_remove,
> 
> It's just my opinion, but I'm not sure this is better.
> 
> By changing the name to KBUILD_MODNAME you can no longer grep the source to
> find the driver based on it's name:

That's fine.

> $ grep -r name * | grep mousevsc
> drivers/staging/hv/hv_mouse.c:  .name = "mousevsc",
> 
> Also, doesn't this change the name of the driver from "mousevsc" to "hv_mouse"?

Yes.

> Does anything else need modified to handle the name change or is the matching
> handled strictly by the id_table?

No, this only shows up in sysfs, no other changes needed.

thanks,

greg k-h
