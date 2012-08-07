Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756466Ab2HGUFy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 16:05:54 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50399 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755902Ab2HGUFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 16:05:51 -0400
MIME-Version: 1.0
X-Originating-IP: [95.23.159.17]
In-Reply-To: <1344344978-30453-1-git-send-email-fery@cypress.com>
References: <fery@cypress.com>
	<1344344978-30453-1-git-send-email-fery@cypress.com>
Date: Tue, 7 Aug 2012 22:05:51 +0200
Message-ID: <CABxcv=n-bTQ=91=f8jaCt7kgP+0WL6hbZyY40rHDxw8-VUjZvQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] Input: cyttsp4 - bus driver for Cypress TMA4XX
 touchscreen devices
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Ferruh Yigit <fery@cypress.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kevin McNeely <kev@cypress.com>, Henrik Rydberg <rydberg@euromail.se>,
        Shawn Landden <shawnlandden@gmail.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Olivier Sobrie <olivier@sobrie.be>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 7, 2012 at 3:09 PM, Ferruh Yigit <fery@cypress.com> wrote:
> From: Ferruh YIGIT <fery@cypress.com>
>
> This driver is for Cypress TrueTouch(tm) Standard Product controllers,
> Generation4 devices.
>
> Driver consist of four main modules:
>
> Bus driver: Linux bus driver implementation, binds other modules.
> Core driver: Core module that communicate with TTSP controller.
> MT driver: MultiTouch driver, converts touch information to host specific
> touch events
> Adapter driver: Communication adapter between host and controller, like
> I2C or SPI.
>
> This is Cyttsp4 TTSP Bus Driver,
> Provides binding between Adapter, Core, and TTSP Modules.
>
> A complete set of corresponding Adapter, Core, and TTSP module
> devices and drivers must be registered with the TTSP Bus handler
>

Hi Ferruh,

There is already a driver in the kernel that supports Cypress
TrueTouch(TM) Standard Product (TTSP) controllers Generation3 (Cypress
Txx3xx parts).

The driver has a similar architecture that yours and it has a generic
driver to control the device and a driver for each communication bus
used to communicate with the controller. Drivers for SPI and I2C data
buses are already implemented.

The drivers are:

drivers/input/touchscreen/cyttsp_core.c
drivers/input/touchscreen/cyttsp_i2c.c
drivers/input/touchscreen/cyttsp_spi.c

This driver was original developed by Kevin for Android and used
multi-touch protocol type A. Since the hardware is able to track
contacts by hardware I added protocol type B support and cleaned the
driver to be merged on mainline.

I wonder how big is the delta between cyttsp Gen3 and cyttsp Gen4 and
if both drivers could be merged or at least refactored to reuse some
common code. I don't have the specification for any of the device
families but by looking at your code it seems that this may be
possible.

Thanks a lot and best regards,
Javier
