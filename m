Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759394Ab1LOTKL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 14:10:11 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:51322 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751300Ab1LOTKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 14:10:08 -0500
X-Sasl-enc: fgjaplDP6rTW6RBAEWT9atnZ86CZZEcpyeALdQjp/4N8 1323976207
Date: Thu, 15 Dec 2011 11:09:54 -0800
From: Greg KH <greg@kroah.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the driver-core tree
Message-ID: <20111215190954.GA23633@kroah.com>
References: <20111215173754.87103f66f6188693933cb539@canb.auug.org.au>
 <20111215072103.GA13747@kroah.com>
 <CAPXgP102rHBUAik0pBZuMVG0JVqHeJ8cNgSOzGWci3MBDoRUSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPXgP102rHBUAik0pBZuMVG0JVqHeJ8cNgSOzGWci3MBDoRUSg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 11:10:26AM +0100, Kay Sievers wrote:
> On Thu, Dec 15, 2011 at 08:21, Greg KH <greg@kroah.com> wrote:
> > On Thu, Dec 15, 2011 at 05:37:54PM +1100, Stephen Rothwell wrote:
> >> After merging the driver-core tree, today's linux-next build (x86_64
> >> allmodconfig) failed like this:
> >>
> >> drivers/xen/xen-selfballoon.c:305:36: error: expected ')' before '(' token
> >> drivers/xen/xen-selfballoon.c:327:42: error: expected ')' before '(' token
> >> drivers/xen/xen-selfballoon.c:349:48: error: expected ')' before '(' token
> >>
> >> etc ...
> >>
> >> [Along with many warnings like:
> >>
> >> drivers/xen/xen-selfballoon.c:284:8: warning: 'struct device_attribute' declared inside parameter list [enabled by default]
> >> ]
> >>
> >> Presumably caused by commit drivers/xen/xen-selfballoon.c ("xen-balloon:
> >> convert sysdev_class to a regular subsystem").
> >
> > Ick, Kay, can you make a fix-up patch?
> >
> > And here I thought I built xen in my test kernel, crap, sorry about
> > that.
> 
> It seems it's a compiler version issue, or similar. I'm unable to
> reproduce it here, allmodconfig and the Xen part gets through without
> any problems.
> 
> I guess we both have very recent systems again. :)
> 
> I expect adding a device.h include will fix it. I'll send you a patch.

Yeah, that fixed it (I was able to duplicate this on my laptop, odd that
my build machine didn't show it.)

Now pushed out to my tree.

thanks,

greg k-h
