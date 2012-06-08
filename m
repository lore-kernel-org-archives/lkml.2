Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761150Ab2FHPS4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 11:18:56 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:49340 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774Ab2FHPSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 11:18:55 -0400
Date: Fri, 8 Jun 2012 17:18:43 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Dominic Eschweiler <eschweiler@fias.uni-frankfurt.de>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uio_pci_generic does not export memory resources
Message-ID: <20120608151843.GA9705@local>
References: <1339156616.3870.9.camel@blech>
 <20120608130351.GB1964@redhat.com>
 <1339165738.3870.18.camel@blech>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339165738.3870.18.camel@blech>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 04:28:58PM +0200, Dominic Eschweiler wrote:
> Am Freitag, den 08.06.2012, 16:03 +0300 schrieb Michael S. Tsirkin:
> > Why is this needed?
> > What's wrong with mapping resources through
> >  /sys/bus/pci/devices/XXXXXresourceX
> > ?
> > 
> Mmmh ok, the problem here is, that the UIO documentation states:
> 
> "/dev/uioX is used to access the address space of the card. Just use
> mmap() to access registers or RAM locations of your card."
> 
> and
> 
> "From userspace, the different mappings are distinguished by adjusting
> the offset parameter of the mmap() call."
> 
> 
> This does not work and the "/sys/class/uio/uioX/maps/mapX/" directories
> do also not appear.

Then there's something fundamentally wrong in your driver. Check the return
value of uio_register_device().

> I was very confused when I tried UIO the first time
> and it did not behave like it is described in the documentation.

UIO is the mainline since 2007, and I can assure you it works like described.
Lots of people use it.

Try and fix your driver, then post it. If you absolutely don't get it working,
post a non-working version for review.

Thanks,
Hans

