Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab2JBM6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 08:58:24 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40021 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751667Ab2JBM6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 08:58:22 -0400
Date: Tue, 2 Oct 2012 13:58:20 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Felipe Balbi <balbi@ti.com>
Cc: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        b-cousson@ti.com, santosh.shilimkar@ti.com, sameo@linux.intel.com
Subject: Re: [PATCHv3 1/4] mfd: smsc: Add support for smsc gpio io/keypad
 driver
Message-ID: <20121002125819.GY4360@opensource.wolfsonmicro.com>
References: <1349089282-22105-1-git-send-email-sourav.poddar@ti.com>
 <CAAe_U6+zEGuwMC1yn7O=LXE6PhPvPc2i7DCF0EAprkE8s+-iEw@mail.gmail.com>
 <20121001114454.GA9170@sirena.org.uk>
 <CAAe_U6JX9QDWvWA3KH7E9sOv0EHGkozVONuXDgn+a2MZ4GTE7Q@mail.gmail.com>
 <20121001120907.GK4360@opensource.wolfsonmicro.com>
 <CAAe_U6K6nAjsZUOk2rBFweWHtJmcLF7EJDpu9O6FXrq3tzv3yg@mail.gmail.com>
 <20121002123856.GX4360@opensource.wolfsonmicro.com>
 <20121002124321.GD30762@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121002124321.GD30762@arwen.pp.htv.fi>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 03:43:22PM +0300, Felipe Balbi wrote:

> BTW, OTOH writing all children into the DT actually describes the HW,
> no ? And depending on the device I feel it'd be better to write that

Well, it depends on the hardware.  Some hardware has a bunch of nice,
neat IPs which can usefully be reproduced and which map sensibly onto OS
abstractions but a lot of it doesn't and frequently the abstractions
which Linux wants to use don't bear a huge resemblance to the hardware
(and Linux's ideas can change over time, as with the clock API being
factored out for example).

> data to DT. Think of twlxxxx (TI's PMICs), we might have completely
> unrelated drivers using one of TWL's GPIO lines as an interrupt source.

> If that particular children isn't listed in DT, it can't be used as an
> interrupt-parent, right ?

You can have the interrupt controller there without having to list every
IP in the device, just make the parent device the interrupt controller
to DT.
