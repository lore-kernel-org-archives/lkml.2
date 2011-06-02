Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab1FBV2y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 17:28:54 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:31570
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754311Ab1FBV2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 17:28:52 -0400
X-SpamScore: -3
X-BigFish: VS-3(zz98dKzz1202hzzz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4DE8008E.9030008@freescale.com>
Date: Thu, 2 Jun 2011 16:28:46 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110429 Fedora/3.6.17-1.fc13 Firefox/3.6.17
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <kumar.gala@freescale.com>, <benh@kernel.crashing.org>, <greg@kroah.com>,
        <akpm@kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-console@vger.kernel.org>
Subject: Re: [PATCH 7/7] [v2] drivers/misc: introduce Freescale hypervisor
 management driver
References: <1306953337-15698-1-git-send-email-timur@freescale.com> <201106012340.14237.arnd@arndb.de>
In-Reply-To: <201106012340.14237.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> I think drivers/misc is not the right place for this, but I'm not completely
> sure what is. drivers/firmware would be better at least, but virt/fsl might
> also be ok.

I don't think it's correct to think of a hypervisor as firmware, so I don't
think drivers/firmware is better.

I'm not sure that creating virt/fsl and putting the driver in there is a good
idea, because it will be the only driver in that directory.  Unlike KVM, this
driver is just a collection of front-ends to our hypervisor API.  The actual
hypervisor is completely separate.  That's why I put it in drivers/misc, because
it's just a single driver with a miscellaneous collection of interfaces.

We also don't want to have any Kconfig options that "turn on" hypervisor
support.  I've intentionally made support for the hypervisor part of the normal
platform code, and the device tree is used to determine whether that code is
active or not.

So virt/fsl seems like overkill to me.

> I'm not convinced that an ioctl interface is the right way to work with
> device tree properties. A more natural way would be to export it as
> a file system, or maybe as a flattened device tree blob (the latter option
> would require changing the hypervisor interface, which might not be
> possible).

As Scott said, this is just a front-end to the hypervisor API, and we already
have applications that depend on the ioctl interface.  Considering that this
driver is specific to the Freescale hypervisor, so I don't see any harm in using
ioctls.

> For an ioctl, please follow the normal pattern of defining a separate
> structure for each case, no union.

Ok.  This will break our existing applications, but it's a minor fix.

-- 
Timur Tabi
Linux kernel developer at Freescale

