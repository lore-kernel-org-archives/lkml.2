Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760703Ab0JGPRr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 11:17:47 -0400
Received: from senator.holtmann.net ([87.106.208.187]:53078 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab0JGPRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 11:17:46 -0400
Subject: RE: [PATCH 1/2] drivers:bluetooth: TI_ST bluetooth driver
From: Marcel Holtmann <marcel@holtmann.org>
To: "Savoy, Pavan" <pavan_savoy@ti.com>
Cc: "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
        "greg@kroah.com" <greg@kroah.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <19F8576C6E063C45BE387C64729E739404AA21D19E@dbde02.ent.ti.com>
References: <1286404493-23816-1-git-send-email-pavan-savoy@ti.com>
	 <1286404493-23816-2-git-send-email-pavan-savoy@ti.com>
	 <1286445948.6145.70.camel@aeonflux>
	 <19F8576C6E063C45BE387C64729E739404AA21D19E@dbde02.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 17:17:39 +0200
Message-ID: <1286464659.6145.144.camel@aeonflux>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavan,

> > Registering the Bluetooth HCI driver in module_init/module_exit is not
> > acceptable. Turn your shared transport into a proper bus.
> 
> Yes, you did comment on it before, I remember, I did prototype the driver as
> a bus driver, However I didn't find any advantages by converting it to a bus
> driver.
> As in, currently the shared transport driver is a line discipline driver because
> it is the only way it can communicate over TTY without being tightly coupled with the UART driver.
> 
> > We want to be able to have generic kernels where this module is enabled,
> > but no Shared Transport is available.
> 
> Oh if this is the reason I cannot have hci_register/_unregister in module_init/_exit, Can I do this module "depends" on TI_ST, Then it would not
> even be visible to build if TI_ST is not selected.

this is not helping either. Then TI_ST can not be selected and so you
still end up with some weird platform specific kernels. We don't want
that. We want generic kernels that can detect the hardware they are
running on.

As I said, I will not accept this driver if it registers HCI device in
module_init. No other driver is doing this and it is in general a really
really really bad idea.

Regards

Marcel


