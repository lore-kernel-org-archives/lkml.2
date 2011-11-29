Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab1K2XNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 18:13:54 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:40632 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756530Ab1K2XNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 18:13:51 -0500
X-Sasl-enc: H3AW7I9FL9TaJ28dkE10kz/M1TADnUn35iCPorEX1bbg 1322608429
Date: Wed, 30 Nov 2011 07:55:52 +0900
From: Greg KH <greg@kroah.com>
To: Anand Kanaginhal <anand_dk@hotmail.com>
Cc: Linux PCI mailing <linux-pci@vger.kernel.org>,
        linux kernel mailing <linux-kernel@vger.kernel.org>,
        linux hotplug mailing <linux-hotplug@vger.kernel.org>
Subject: Re: PCIe Hotplugging not working
Message-ID: <20111129225552.GB27909@kroah.com>
References: <BAY163-W52E309F419E3588206D889FBB30@phx.gbl>
 <BAY163-W47DD39095DA3EB108AA3F2FBB30@phx.gbl>
 <20111129142214.GC14845@kroah.com>
 <BAY163-W63C79C972B0F87A46B0FDCFBB30@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BAY163-W63C79C972B0F87A46B0FDCFBB30@phx.gbl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 09:50:41AM -0800, Anand Kanaginhal wrote:
> 
> Resending as earlier sends failed

You can not send html messages to vger.kernel.org mailing lists.

> > Why is a pci driver a "char" driver?  Do you have a pointer to the
> > source of this?
> 
> I am doing an test before putting it in its right place. Another
> reason is that I am treating it as character device and using IOCTLs
> for various operations.  I have attached the framework code here.

Just a note, but your framework is backwards, you should allocate your
character device in your probe function, not in the module init
function.

Also, what type of driver is this, why do you need ioctls for it?

> > > 2. I run depmod and "modules.pcimap" also got updated with my module. 
> > > 
> > > However
> > >  if I unplug and plug in the endpoint, my driver .probe and .remove functions
> > >  are not being invoked. Is there something more to be done at the bus 
> > > level to get the driver to hot plug ?
> > 
> > You need a pci hotplug controller driver, is that loaded?  That is what
> > is responsible for eventually calling your remove function.
> 
> How do I figure out if a pci hotplug controller driver is installed? 

How do you know that your hardware supports PCI hotplugging at all?

You need a PCI hotplug controller in the system, generally if you have
one, the driver will be loaded for it, but if you are using a custom
kernel, you might have to build and install it yourself.

> > > I have tried various kernel version, Currently I am trying on 2.6.38.12 (UBUNTU flavor).
> > 
> > We can't help you with distro-specific kernels, please use a kernel.org
> > kernel and we will be glad to help you out.
> 
> I have tried with vanilla kernel as well with the same results.

What release did you try?

greg k-h
