Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab2FMGYB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 02:24:01 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:40679 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab2FMGYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 02:24:00 -0400
Date: Wed, 13 Jun 2012 09:23:35 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 8/8] staging: comedi: cleanup comedi_alloc_subdevices
Message-ID: <20120613062334.GS13539@mwanda>
References: <201206121159.55522.hartleys@visionengravers.com>
 <20120612194940.GZ4400@mwanda>
 <ADE657CA350FB648AAC2C43247A983F0020698DBC78B@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F0020698DBC78B@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 03:20:32PM -0500, H Hartley Sweeten wrote:
> On Tuesday, June 12, 2012 12:50 PM, Dan Carpenter wrote:
> > On Tue, Jun 12, 2012 at 11:59:55AM -0700, H Hartley Sweeten wrote:
> >>  	for (i = 0; i < num_subdevices; ++i) {
> >> -		dev->subdevices[i].device = dev;
> >> -		dev->subdevices[i].async_dma_dir = DMA_NONE;
> >> -		spin_lock_init(&dev->subdevices[i].spin_lock);
> >> -		dev->subdevices[i].minor = -1;
> >> +		s = dev->subdevices + i;
> >
> > You don't have to resend, but I think this would look better as:
> >
> > 		s = &dev->subdevices[i];
> 
> I don't disagree but the "dev->subdevices +i" format is consistently
> used in all the comedi stuff. If the format above is preferred we
> should probably update everything,

To me the one is way more clear than the other.  If we wanted we
could write any array in terms of pointer math, but arrays are
easier to understand.

regards,
dan carpenter

