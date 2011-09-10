Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933863Ab1IJSf5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 14:35:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37548 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933673Ab1IJSfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 14:35:55 -0400
Date: Sat, 10 Sep 2011 20:33:36 +0200
From: Greg KH <gregkh@suse.de>
To: KY Srinivasan <kys@microsoft.com>
Cc: Greg KH <greg@kroah.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 10/25] Staging: hv: vmbus: Return proper error code in
 vmbus_remove()
Message-ID: <20110910183336.GB30865@suse.de>
References: <1315491843-9513-1-git-send-email-kys@microsoft.com>
 <1315491876-9554-1-git-send-email-kys@microsoft.com>
 <1315491876-9554-10-git-send-email-kys@microsoft.com>
 <20110909204309.GG19127@kroah.com>
 <6E21E5352C11B742B20C142EB499E048081DC4B3@TK5EX14MBXC128.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E048081DC4B3@TK5EX14MBXC128.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 10, 2011 at 02:22:22PM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:greg@kroah.com]
> > Sent: Friday, September 09, 2011 4:43 PM
> > To: KY Srinivasan
> > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang
> > Subject: Re: [PATCH 10/25] Staging: hv: vmbus: Return proper error code in
> > vmbus_remove()
> > 
> > On Thu, Sep 08, 2011 at 07:24:21AM -0700, K. Y. Srinivasan wrote:
> > > Return proper error code in vmbus_remove().
> > >
> > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > > ---
> > >  drivers/staging/hv/vmbus_drv.c |    4 ++--
> > >  1 files changed, 2 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
> > > index b9aeb76..95d33a4 100644
> > > --- a/drivers/staging/hv/vmbus_drv.c
> > > +++ b/drivers/staging/hv/vmbus_drv.c
> > > @@ -325,7 +325,7 @@ static int vmbus_probe(struct device *child_device)
> > >   */
> > >  static int vmbus_remove(struct device *child_device)
> > >  {
> > > -	int ret;
> > > +	int ret = 0;
> > 
> > As remove functions can't fail, why return anything at all?
> > 
> > Doesn't make sense, please fix.
> 
> Greg,
> 
> Looking at the struct bus_type, the remove function is not a void function.

Yeah, but it's never checked, and most bus types just use a void
function as the function can not fail (or, it's not allowed to at
least.)

> I was just fixing something that was broken in this function.

That's fine, then you can add it to the list of things to change :)

greg k-h
