Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab1FCPY7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 11:24:59 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:55442 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988Ab1FCPY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 11:24:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Timur Tabi <timur@freescale.com>
Subject: Re: [PATCH 7/7] [v2] drivers/misc: introduce Freescale hypervisor management driver
Date: Fri, 3 Jun 2011 17:24:44 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: kumar.gala@freescale.com, benh@kernel.crashing.org, greg@kroah.com,
        akpm@kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-console@vger.kernel.org
References: <1306953337-15698-1-git-send-email-timur@freescale.com> <201106012340.14237.arnd@arndb.de> <4DE8008E.9030008@freescale.com>
In-Reply-To: <4DE8008E.9030008@freescale.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106031724.44957.arnd@arndb.de>
X-Provags-ID: V02:K0:UK5ABNP4tlG6nff6uuFGALMnWhjSdIv7axeo2hrqvMw
 1NNvGpgONQIA8X4sWP0kvat7qu734v2itOBjWSX6RJGIKWzY50
 SKjWNGuiSawk2NToygnj17izcaZMlH1nrG3xIC9nDv2jx8PpMp
 K+g59nolCIymJ3DbroYuiLMj9i1Nz5WwCCp9GYAxXFuo8QtUgM
 TZNOvRK5gOn7JcMCmfHXw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 June 2011, Timur Tabi wrote:
> Arnd Bergmann wrote:
> > I think drivers/misc is not the right place for this, but I'm not completely
> > sure what is. drivers/firmware would be better at least, but virt/fsl might
> > also be ok.
> 
> I don't think it's correct to think of a hypervisor as firmware, so I don't
> think drivers/firmware is better.
> 
> I'm not sure that creating virt/fsl and putting the driver in there is a good
> idea, because it will be the only driver in that directory.  Unlike KVM, this
> driver is just a collection of front-ends to our hypervisor API.  The actual
> hypervisor is completely separate.  That's why I put it in drivers/misc, because
> it's just a single driver with a miscellaneous collection of interfaces.

Ok, fair enough. If nobody has a strong preference any other way, just make it
drivers/firmware then.

> We also don't want to have any Kconfig options that "turn on" hypervisor
> support.  I've intentionally made support for the hypervisor part of the normal
> platform code, and the device tree is used to determine whether that code is
> active or not.
> 
> So virt/fsl seems like overkill to me.

Ok. Obviously, you still have the option to move the code later if you require
more interfaces to talk to your hypervisor, and then you can still add virt/fsl,
so no problem.

> > I'm not convinced that an ioctl interface is the right way to work with
> > device tree properties. A more natural way would be to export it as
> > a file system, or maybe as a flattened device tree blob (the latter option
> > would require changing the hypervisor interface, which might not be
> > possible).
> 
> As Scott said, this is just a front-end to the hypervisor API, and we already
> have applications that depend on the ioctl interface.  Considering that this
> driver is specific to the Freescale hypervisor, so I don't see any harm in using
> ioctls.

Good interface design is always important, one of the reasons is serving as
an example for other people doing similar drivers. There are a lot of
companies writing hypervisors and they all need interfaces like this.

> > For an ioctl, please follow the normal pattern of defining a separate
> > structure for each case, no union.
> 
> Ok.  This will break our existing applications, but it's a minor fix.

Ok. Better to break it now than accidentally break it later because of
some side-effect of a strange interface, e.g. when the union would change in
size.

	Arnd
