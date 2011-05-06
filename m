Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab1EFRfF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 13:35:05 -0400
Received: from mail2.microsoft.com ([131.107.115.215]:49621 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab1EFRfD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 13:35:03 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: various vmbus review comments
Thread-Topic: various vmbus review comments
Thread-Index: AQHMCdM/6BBvI53KVEebJyh4jiWUR5R8ywQggACIZQCAAm/aIIAAmuYA//+TBJA=
Date: Fri, 6 May 2011 17:34:55 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481E07DE@TK5EX14MBXC124.redmond.corp.microsoft.com>
References: <20110503204641.GA11132@kroah.com>
 <6E21E5352C11B742B20C142EB499E0481DFCFA@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110504163228.GA19754@kroah.com>
 <6E21E5352C11B742B20C142EB499E0481E0694@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110506145944.GA11871@kroah.com>
In-Reply-To: <20110506145944.GA11871@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.24]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Friday, May 06, 2011 11:00 AM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org
> Subject: Re: various vmbus review comments
> 
> On Fri, May 06, 2011 at 01:10:38PM +0000, KY Srinivasan wrote:
> > > No, I am referring to the module reference counting of the bus drivers
> > > that register with the vmbus core.  You aren't doing that at all, and
> > > you probably need to make sure that this isn't needed.  That is
> > > concentrating on the vmbus driver.
> >
> > I audited the block and the net drivers. As part of their exit routine,
> > they invoke vmbus_child_driver_unregister() after properly cleaning
> > up all the devices they are managing. Do you still see an issue with
> > regards to module reference counting.
> 
> I will look again, the next time I review the vmbus code.

Thank you.

> 
> > > > I will also address your comment on static initialization hv_driver instances
> > > > as part of other driver cleanup.
> > >
> > > No, please do this now as it will show how to properly interact with the
> > > vmbus core code in the correct manner.  Hopefully that will be correct,
> > > but I have a feeling that it will show you some places in the API that
> > > need to be changed...
> >
> > As opposed to run-time initialization of fields such as probe, etc; I have
> > initialized them statically. For instance, in the blkvsc driver:
> >
> > /* The one and only one */
> > static  struct storvsc_driver blkvsc_drv = {
> >         .base.probe =  blkvsc_probe,
> >         .base.remove =  blkvsc_remove,
> >         .base.shutdown = blkvsc_shutdown,
> > };
> >
> > Is this what you had in mind.
> 
> Close.  The format is correct.
> 
> But what's with that ".base." crud?  That shows that something is wrong
> as no USB or PCI or any other bus driver has to mess with a ".base"
> subpointer in a driver structure.
> 
> See, I told you that when you converted to use this format the problems
> would pop out at you :)
> 
> Please fix that.

I will. I am incrementally cleaning up the drivers, I will cleanup the ".base" 
crud as part of additional cleanup that I will do.

Regards,

K. Y

