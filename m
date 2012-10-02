Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab2JBMjC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 08:39:02 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41965 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752772Ab2JBMi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 08:38:59 -0400
Date: Tue, 2 Oct 2012 13:38:56 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
Cc: Sourav Poddar <sourav.poddar@ti.com>, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        b-cousson@ti.com, balbi@ti.com, santosh.shilimkar@ti.com,
        sameo@linux.intel.com
Subject: Re: [PATCHv3 1/4] mfd: smsc: Add support for smsc gpio io/keypad
 driver
Message-ID: <20121002123856.GX4360@opensource.wolfsonmicro.com>
References: <1349089282-22105-1-git-send-email-sourav.poddar@ti.com>
 <CAAe_U6+zEGuwMC1yn7O=LXE6PhPvPc2i7DCF0EAprkE8s+-iEw@mail.gmail.com>
 <20121001114454.GA9170@sirena.org.uk>
 <CAAe_U6JX9QDWvWA3KH7E9sOv0EHGkozVONuXDgn+a2MZ4GTE7Q@mail.gmail.com>
 <20121001120907.GK4360@opensource.wolfsonmicro.com>
 <CAAe_U6K6nAjsZUOk2rBFweWHtJmcLF7EJDpu9O6FXrq3tzv3yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAe_U6K6nAjsZUOk2rBFweWHtJmcLF7EJDpu9O6FXrq3tzv3yg@mail.gmail.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 08:54:23PM +0530, ABRAHAM, KISHON VIJAY wrote:
> On Mon, Oct 1, 2012 at 5:39 PM, Mark Brown

> > Why would that be helpful?  Most platforms don't support DT at all, and

> I'm not sure how to put it correctly. All I'm trying to tell is mfd is
> a framework that exposes a set of API's to create and remove a device
> among others. If a mfd child device is not created using mfd API,
> it'll be unfair to expect that child be removed properly using mfd
> API. Like in this patch, the device is created using
> of_platform_populate (not a mfd API) but is removed using
> mfd_remove_devices (mfd API) [which should result in an abort].

That doesn't sound terribly clever, no, though it's not immediately
clear to me if the non-clever bit is using mfd_remove_devices() or
of_platform_populate().

> This means mfd framework does not have an API to create a device from
> dt data or so do I think since of_platform_populate() is used. Thats
> why I suggested the idea of extending mfd_add_devices() (or adding a
> new API in mfd framework) to create child devices from dt data so that
> we'll have API's in mfd framework to both create and delete a device.

The trouble that always exists with representing MFD children in DT is
that unless you've got a usefully reusable IP block which is clearly
separate from the chip integration you end up essentially just dumping
the Linux data structures into DT which often doesn't leave you with
something which describes the hardware.
