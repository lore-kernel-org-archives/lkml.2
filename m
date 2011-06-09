Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028Ab1FIUd1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 16:33:27 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:61461 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab1FIUdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 16:33:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Timur Tabi <timur@freescale.com>
Subject: Re: [PATCH 7/7] [v5] drivers/virt: introduce Freescale hypervisor management driver
Date: Thu, 9 Jun 2011 22:33:07 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: linuxppc-dev@lists.ozlabs.org, alan@lxorguk.ukuu.org.uk,
        kumar.gala@freescale.com, benh@kernel.crashing.org, greg@kroah.com,
        akpm@kernel.org, cmetcalf@tilera.com, konrad.wilk@oracle.com,
        linux-kernel@vger.kernel.org, linux-console@vger.kernel.org,
        virtualization@lists.linux-foundation.org
References: <1307646794-26374-1-git-send-email-timur@freescale.com> <201106092213.13755.arnd@arndb.de> <4DF12A94.6070605@freescale.com>
In-Reply-To: <4DF12A94.6070605@freescale.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106092233.08030.arnd@arndb.de>
X-Provags-ID: V02:K0:gsRGxxKG14p1Qphubr0q+mR2TqyLb4W5yZmrJ5KBWBd
 bDIKsmYEVtEAJEVDlNAsbX0MgezIT9KHBevIzUspLBgizNgNh5
 exbXmkL794ITDkPirXz+3ISLGMGQgabuKDbqpMJA5/w9v/fzIW
 MFIz53yZlW4FTKLr8kaaJmP1Vy/G/DETtHwalI/PT4VX+KyKuz
 z0dvGMejfY9OL3wtOEcOQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 June 2011 22:18:28 Timur Tabi wrote:
> > More importantly, the code you have chose (0) conflicts with existing drivers
> > (frame buffer, scsi and wavefront among others). Please chose a free one and
> > add it to Documentation/ioctl/ioctl-number.txt in the same patch.
> 
> Ok, I was really hoping to avoid doing this.  Like I said, binary compatibility
> is important, and changing the type will break my existing apps.  Are you
> insisting that I pick a new number?

I definitely insist that you have a proper interface in the driver at the
time that it gets merged, and that probably includes a collision-free
ioctl code.

You can probably make the driver support both the traditional and the
new interface, but I would prefer if you kept that as a private patch
on top a clean kernel driver. It's also a good idea to keep the header
file clean and only define the new interface there, to ensure that all
applications that are built in the future have to use the new interface.

When you make the patch to add backwards compat support, just add it
to the driver itself, not to the header.

	Arnd
