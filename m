Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab1LIXp4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 18:45:56 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:54791 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751890Ab1LIXpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 18:45:53 -0500
X-Sasl-enc: ibRmbiFdyKQB95hzQZypJesOsfiBWWyC4Rsn7r68ujF2 1323474352
Date: Fri, 9 Dec 2011 15:45:22 -0800
From: Greg KH <greg@kroah.com>
To: Anand Kanaginhal <anand_dk@hotmail.com>
Cc: mjg59@srcf.ucam.org, bhelgaas@google.com,
        Linux PCI mailing <linux-pci@vger.kernel.org>,
        linux kernel mailing <linux-kernel@vger.kernel.org>,
        linux hotplug mailing <linux-hotplug@vger.kernel.org>
Subject: Re: PCIe Hotplugging not working
Message-ID: <20111209234522.GA6413@kroah.com>
References: <20111130182423.GA4831@srcf.ucam.org>
 <CAErSpo5SvHSJrdkWituFq11hMt=jbiobnxHeddN9Xf4DmK640g@mail.gmail.com>
 <BAY163-W600D6D6A04D4BAE8278907FBB90@phx.gbl>
 <20111209124524.GA3488@srcf.ucam.org>
 <BAY163-W45C53B9E3E9E0B8629B683FBB90@phx.gbl>
 <20111209180708.GA10768@kroah.com>
 <BAY163-W154A24444BB398F609767CFBB90@phx.gbl>
 <20111209222520.GA24786@kroah.com>
 <BAY163-W582FC4C5828B20E9487D3EFBB90@phx.gbl>
 <BAY163-W61A8DF92159F5C3E26103FBB90@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BAY163-W61A8DF92159F5C3E26103FBB90@phx.gbl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 09, 2011 at 03:24:00PM -0800, Anand Kanaginhal wrote:
> > Please make sure your pci hotplug driver is working first.  Try turning
> > on and off the power to the card slot (in the sysfs directory for the
> > slot) and see if that's working.
> When I do this, my driver probe and remove gets invoked. 

Then part of the pci hotplug controller driver is working, good.

> > You also have failed to say exactly what pci hotplug controller you have
> > in your system, what is it?  You have to have one, and the driver loaded
> > for it, for any of this to work at all.
> 
> We are using plx 8533 in our system,

What exactly is that?

> it hasnt provided controller driver for linux, however the support
> team insists that any hotplug controller driver which is compliant to
> PCI SIG, should work fine.My assumption was shpc in linux would work
> just fine. 

The PCI Hotplug SIG said that ACPI would be the way forward for "PCI"
hotplug capabilities.

For PCI Express, the pciehp driver should work for you, as that follows
the spec for PCI Express devices.

So it depends on your hardware, what pci hotplug driver do you have
loaded, and what does the kernel log messages say when you load it, and
then what does it say when you remove your device?

Remember, PCI devices are not supposed to be hot-removed, you have to
tell the OS ahead of time it is going to go away.  PCI Express is a bit
different, depending on the type of device (ExpressCard is allowed to be
removed without notifying the OS ahead of time, some other PCI Express
devices are not, see the spec for details.)

greg k-h
