Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984Ab0HJUrZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 16:47:25 -0400
Received: from 8bytes.org ([88.198.83.132]:58777 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757970Ab0HJUrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 16:47:22 -0400
Date: Tue, 10 Aug 2010 22:47:21 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Sander Eikelenboom <linux@eikelenboom.it>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.35] AMD-Vi: Enabling IOMMU at 0000:00:00.2 cap 0x40  BUG:
	unable to handle kernel NULL pointer dereference at 0000000000000198
Message-ID: <20100810204721.GT23755@8bytes.org>
References: <1154489525.20100810164850@eikelenboom.it> <20100810162606.GQ23755@8bytes.org> <419601760.20100810185745@eikelenboom.it> <20100810180122.GR23755@8bytes.org> <1609756756.20100810200514@eikelenboom.it> <20100810202839.GS23755@8bytes.org> <618241473.20100810223635@eikelenboom.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <618241473.20100810223635@eikelenboom.it>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sander,

On Tue, Aug 10, 2010 at 10:36:35PM +0200, Sander Eikelenboom wrote:
> Errr which seperate usb controller ? .. it has actually:
> - 1 pci-e usb 2.0 controller
> - 2 pci-e usb 3.0 controller (one of which includes a sata controller as well)

The devices should be attached to this controler:

0a:01.0 USB Controller [0c03]: NEC Corporation USB [1033:0035] (rev 43) (prog-if 10 [OHCI])
0a:01.1 USB Controller [0c03]: NEC Corporation USB [1033:0035] (rev 43) (prog-if 10 [OHCI])
0a:01.2 USB Controller [0c03]: NEC Corporation USB 2.0 [1033:00e0] (rev 04) (prog-if 20 [EHCI])

The PCI devices associated with that controler alias to 0a:00.0 which
does not exist in your system (hence the crash). And the fact that these
devices have an alias makes me believe that the BIOS detects them as
legacy PCI devices. PCI-e does typically not has aliases. Can you send
lcpi -t output to see to which upstream bridge these devices are
connected to?

	Joerg

