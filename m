Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023Ab2HHFxM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 01:53:12 -0400
Received: from relay.ihostexchange.net ([66.46.182.51]:3694 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756250Ab2HHFxL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 01:53:11 -0400
Message-ID: <5021FEBF.7050803@cypress.com>
Date: Wed, 8 Aug 2012 08:53:03 +0300
From: Ferruh Yigit <fery@cypress.com>
Organization: Cypress
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Javier Martinez Canillas <javier@dowhile0.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kevin McNeely <kev@cypress.com>, Henrik Rydberg <rydberg@euromail.se>,
        Shawn Landden <shawnlandden@gmail.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Olivier Sobrie <olivier@sobrie.be>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] Input: cyttsp4 - bus driver for Cypress TMA4XX touchscreen
 devices
References: <fery@cypress.com> <1344344978-30453-1-git-send-email-fery@cypress.com> <CABxcv=n-bTQ=91=f8jaCt7kgP+0WL6hbZyY40rHDxw8-VUjZvQ@mail.gmail.com>
In-Reply-To: <CABxcv=n-bTQ=91=f8jaCt7kgP+0WL6hbZyY40rHDxw8-VUjZvQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Javier,

We needed a new modular driver mechanism so that we can handle the very
flexible new generation of Cypress multi-touch devices (TMA4XX and TMA5XX).

With this initial set of patches we are providing the primary function
of multi-touch processing, according to protocol B, as the foundation
for future enhancements and future generations of our parts.

We plan to submit patches in the near future for additional modules such
as handling of integrated button codes and firmware class loader
capability.

The Gen3 memory map is very different from the Gen4 and Gen5 products,
however it is not difficult to upgrade the current Gen3 code into a new
set of modules that can fit into this model.

Adding a module patchset for Gen3 also will allow us to add Gen2 support
in that module as well.

Thanks and Best Regards,
ferruh

On 08/07/2012 11:05 PM, Javier Martinez Canillas wrote:
> On Tue, Aug 7, 2012 at 3:09 PM, Ferruh Yigit <fery@cypress.com> wrote:
>> From: Ferruh YIGIT <fery@cypress.com>
>>
>> This driver is for Cypress TrueTouch(tm) Standard Product controllers,
>> Generation4 devices.
>>
>> Driver consist of four main modules:
>>
>> Bus driver: Linux bus driver implementation, binds other modules.
>> Core driver: Core module that communicate with TTSP controller.
>> MT driver: MultiTouch driver, converts touch information to host specific
>> touch events
>> Adapter driver: Communication adapter between host and controller, like
>> I2C or SPI.
>>
>> This is Cyttsp4 TTSP Bus Driver,
>> Provides binding between Adapter, Core, and TTSP Modules.
>>
>> A complete set of corresponding Adapter, Core, and TTSP module
>> devices and drivers must be registered with the TTSP Bus handler
>>
> Hi Ferruh,
>
> There is already a driver in the kernel that supports Cypress
> TrueTouch(TM) Standard Product (TTSP) controllers Generation3 (Cypress
> Txx3xx parts).
>
> The driver has a similar architecture that yours and it has a generic
> driver to control the device and a driver for each communication bus
> used to communicate with the controller. Drivers for SPI and I2C data
> buses are already implemented.
>
> The drivers are:
>
> drivers/input/touchscreen/cyttsp_core.c
> drivers/input/touchscreen/cyttsp_i2c.c
> drivers/input/touchscreen/cyttsp_spi.c
>
> This driver was original developed by Kevin for Android and used
> multi-touch protocol type A. Since the hardware is able to track
> contacts by hardware I added protocol type B support and cleaned the
> driver to be merged on mainline.
>
> I wonder how big is the delta between cyttsp Gen3 and cyttsp Gen4 and
> if both drivers could be merged or at least refactored to reuse some
> common code. I don't have the specification for any of the device
> families but by looking at your code it seems that this may be
> possible.
>
> Thanks a lot and best regards,
> Javier


This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
