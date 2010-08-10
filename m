Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994Ab0HJU5a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 16:57:30 -0400
Received: from vs244178.vserver.de ([62.75.244.178]:52818 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757919Ab0HJU52 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 16:57:28 -0400
Date: Tue, 10 Aug 2010 22:57:26 +0200
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <1893257730.20100810225726@eikelenboom.it>
To: Joerg Roedel <joro@8bytes.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [2.6.35] AMD-Vi: Enabling IOMMU at 0000:00:00.2 cap 0x40  BUG: unable to handle kernel NULL pointer dereference at 0000000000000198
In-Reply-To: <20100810204721.GT23755@8bytes.org>
References: <1154489525.20100810164850@eikelenboom.it> <20100810162606.GQ23755@8bytes.org> <419601760.20100810185745@eikelenboom.it> <20100810180122.GR23755@8bytes.org> <1609756756.20100810200514@eikelenboom.it> <20100810202839.GS23755@8bytes.org> <618241473.20100810223635@eikelenboom.it> <20100810204721.GT23755@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmmm the fun part seems to be .. that the usb devices on that usb2 controller seemed to work fine on Xen.
And i have some problems about xen not willing to passthrough things with the usb3 controllers (supposedly due to the (extra) bridges),
that are the controllers on 04:00.0 and 08:00.0

-[0000:00]-+-00.0
           +-00.2
           +-02.0-[0000:0d]--+-00.0
           |                 \-00.1
           +-05.0-[0000:0c]----00.0
           +-06.0-[0000:0b]----00.0
           +-0a.0-[0000:09-0a]----00.0-[0000:0a]--+-01.0
           |                                      +-01.1
           |                                      \-01.2
           +-0b.0-[0000:05-08]----00.0-[0000:06-08]--+-01.0-[0000:08]----00.0
           |                                         \-02.0-[0000:07]----00.0
           +-0d.0-[0000:04]----00.0
           +-11.0
           +-12.0
           +-12.2
           +-13.0
           +-13.2
           +-14.0
           +-14.3
           +-14.4-[0000:03]----06.0
           +-14.5
           +-15.0-[0000:02]--
           +-16.0
           +-16.2
           +-18.0
           +-18.1
           +-18.2
           +-18.3
           \-18.4

I had hoped things would become easier/better with my new mobo including iommu :-)
Doesn't seem that way yet. Previously i had 2 usb2.0 controllers(1x pci 1x pci-e) and 1 usb3.0(pci-e) passed through (with xen-swiotlb and no hardware iommu).. and that worked fine grabbing video 24/7 for several weeks.


But lets hope for the best :-)

--
Sander




Tuesday, August 10, 2010, 10:47:21 PM, you wrote:

> Hi Sander,

> On Tue, Aug 10, 2010 at 10:36:35PM +0200, Sander Eikelenboom wrote:
>> Errr which seperate usb controller ? .. it has actually:
>> - 1 pci-e usb 2.0 controller
>> - 2 pci-e usb 3.0 controller (one of which includes a sata controller as well)

> The devices should be attached to this controler:

> 0a:01.0 USB Controller [0c03]: NEC Corporation USB [1033:0035] (rev 43) (prog-if 10 [OHCI])
> 0a:01.1 USB Controller [0c03]: NEC Corporation USB [1033:0035] (rev 43) (prog-if 10 [OHCI])
> 0a:01.2 USB Controller [0c03]: NEC Corporation USB 2.0 [1033:00e0] (rev 04) (prog-if 20 [EHCI])

> The PCI devices associated with that controler alias to 0a:00.0 which
> does not exist in your system (hence the crash). And the fact that these
> devices have an alias makes me believe that the BIOS detects them as
> legacy PCI devices. PCI-e does typically not has aliases. Can you send
> lcpi -t output to see to which upstream bridge these devices are
> connected to?

>         Joerg




-- 
Best regards,
 Sander                            mailto:linux@eikelenboom.it

