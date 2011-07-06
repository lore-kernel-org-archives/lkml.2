Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab1GFDmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 23:42:42 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:41297 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755987Ab1GFDmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 23:42:40 -0400
X-Sasl-enc: cFPhItGqAZj6GKtVRsR5bKfy1VxxXNTFCJvdz5bCF2gb 1309923760
Date: Tue, 5 Jul 2011 20:42:28 -0700
From: Greg KH <greg@kroah.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH 15/77] Staging: hv: blkvsc: Add the appropriate
 MODULE_ALIAS() line
Message-ID: <20110706034228.GA4291@kroah.com>
References: <1308255393-3785-1-git-send-email-kys@microsoft.com>
 <1308255470-3826-1-git-send-email-kys@microsoft.com>
 <1308255470-3826-15-git-send-email-kys@microsoft.com>
 <20110705160621.GC7214@kroah.com>
 <6E21E5352C11B742B20C142EB499E0480816D27E@TK5EX14MBXC126.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0480816D27E@TK5EX14MBXC126.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 12:40:42AM +0000, KY Srinivasan wrote:
> > > diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
> > > index 5842db8..9496abe 100644
> > > --- a/drivers/staging/hv/blkvsc_drv.c
> > > +++ b/drivers/staging/hv/blkvsc_drv.c
> > > @@ -1027,5 +1027,6 @@ static void __exit blkvsc_exit(void)
> > >  MODULE_LICENSE("GPL");
> > >  MODULE_VERSION(HV_DRV_VERSION);
> > >  MODULE_DESCRIPTION("Microsoft Hyper-V virtual block driver");
> > > +MODULE_ALIAS("vmbus:hv_block");
> > 
> > No, these should be automagically generated with the MODULE_DEVICE_ID()
> > macro that you use in the module with the GUID there, instead of this.
> 
> I think you mean MODULE_DEVICE_TABLE()?

Yes, sorry for the typo.

> I actually went down that path first
> adding code  to  file2alias.c for parsing the vmbus ID table. Given that this approach
> would make it  impossible to support auto-loading of these drivers
> on many of the released kernels,

Wait, what?  What is a "released kernel"?  We are working on the
in-kernel patch, we don't care about older distros/releases for this
work at all.  Also, it doesn't make sense at all, why would the change I
asked for make any difference on older distros/kernels?

> I chose to go with the MODULE_ALIAS() macro that did not need any
> changes outside our drivers. In both methods, the formatting of the
> name is bus specific since I would be writing the code to parse the
> table in file2alias.c.

Yes, that is what is needed to be done.

> Granted, I have been quite unimaginative in my alias names, but I
> thought they were reasonably descriptive. If at all possible, for the
> reasons listed above, I would prefer to use the MODULE_ALIAS() macro
> (I could embed all or part of the guid in the alias). Let me know.

Please do the correct thing and use MODULE_DEVICE_TABLE().

thanks,

greg k-h
