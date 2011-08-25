Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab1HYCq1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 22:46:27 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:52872 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753143Ab1HYCq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 22:46:26 -0400
X-Sasl-enc: l+XEyCksM6WFXjzxgdkQzOZgM8rSuqpYYjKQahKZeSy1 1314240385
Date: Wed, 24 Aug 2011 19:38:32 -0700
From: Greg KH <greg@kroah.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 003/117] Staging: hv: Add struct hv_vmbus_device_id to
 mod_devicetable.h
Message-ID: <20110825023832.GA6131@kroah.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-3-git-send-email-kys@microsoft.com>
 <20110823224157.GA9641@kroah.com>
 <6E21E5352C11B742B20C142EB499E048081B236E@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20110824025913.GC30779@kroah.com>
 <6E21E5352C11B742B20C142EB499E048081B27B9@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20110824201144.GA28667@kroah.com>
 <6E21E5352C11B742B20C142EB499E048081B29C8@TK5EX14MBXC126.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E048081B29C8@TK5EX14MBXC126.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 09:51:00PM +0000, KY Srinivasan wrote:
> > It would allow you, in your probe function, to do something different
> > depending on the guid that the probe function was matching on.  So you
> > would not have to check the guid again to do that, just use the data
> > pointed in that void pointer and away you go.
> > 
> > As an example, look at drivers/usb/class/cdc-acm.c, the acm_ids[]
> > variable which uses the driver_info field to contain a quirk for the
> > device.
> 
> Ok; this makes sense. But I currently don't have any quirks to support!

That was just an example.

> The util driver is not even a driver in the true sense. I made it a driver and
> added the probe function just to support auto-loading with the vmbus ID space
> that I am trying to implement here - the probe function does nothing.

As you can tell, I'm trying to say that is wrong :)

the hv_util.c driver should have a pointer in each of the driver_info
that describes what it is, and then in the probe function, you use that
to hook up the correct things needed.

None of this hard-coded mess like you currently have.

Trust me, you want that pointer, put it in, and if you never use it,
I'll buy you a beer.  But if I send you a patch using it, well...

> > > I looked at the usage of this in PCI and it appears to be for supporting
> > > dynamic  IDs for existing drivers.
> > 
> > No, that's exactly wrong.  dynamic ids play havoc with this pointer,
> > making some drivers not be able to handle dynamic ids because they rely
> > on it for some driver-specific information to be passed in it, which
> > dynamic ids can not handle.
> > 
> > Oh, have you remembered to turn off dynamic ids for these devices?  Or
> > do you support them properly?
> 
> I don't support dynamic IDs. What would I need to do to turn it off.

Ah, nevermind, that is something that busses add in their core if they
want it.  I added it for PCI and USB, maybe I should move that to the
driver core so that others can get it automatically one of these days...

thanks,

greg k-h
