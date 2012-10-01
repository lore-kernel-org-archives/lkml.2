Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab2JAPY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 11:24:27 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:52666 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752497Ab2JAPYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 11:24:25 -0400
MIME-Version: 1.0
In-Reply-To: <20121001120907.GK4360@opensource.wolfsonmicro.com>
References: <1349089282-22105-1-git-send-email-sourav.poddar@ti.com>
	<CAAe_U6+zEGuwMC1yn7O=LXE6PhPvPc2i7DCF0EAprkE8s+-iEw@mail.gmail.com>
	<20121001114454.GA9170@sirena.org.uk>
	<CAAe_U6JX9QDWvWA3KH7E9sOv0EHGkozVONuXDgn+a2MZ4GTE7Q@mail.gmail.com>
	<20121001120907.GK4360@opensource.wolfsonmicro.com>
Date: Mon, 1 Oct 2012 20:54:23 +0530
Message-ID: <CAAe_U6K6nAjsZUOk2rBFweWHtJmcLF7EJDpu9O6FXrq3tzv3yg@mail.gmail.com>
Subject: Re: [PATCHv3 1/4] mfd: smsc: Add support for smsc gpio io/keypad driver
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Sourav Poddar <sourav.poddar@ti.com>, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        b-cousson@ti.com, balbi@ti.com, santosh.shilimkar@ti.com,
        sameo@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Oct 1, 2012 at 5:39 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Mon, Oct 01, 2012 at 05:23:15PM +0530, ABRAHAM, KISHON VIJAY wrote:
>> On Mon, Oct 1, 2012 at 5:14 PM, Mark Brown
>
>> > No, this is not at all sensible - if there's an mfd_remove_devices()
>> > function we really ought to be able to use it to remove the children.
>> > If we can't do that we should fix the API usability, not open code the
>> > same stuff in every user.
>
>> What makes more sense to me is extend mfd_add_devices to create child
>> devices from dt data. Then for removing devices, one can use
>> mfd_remove_devices().
>
> Why would that be helpful?  Most platforms don't support DT at all, and
I'm not sure how to put it correctly. All I'm trying to tell is mfd is
a framework that exposes a set of API's to create and remove a device
among others. If a mfd child device is not created using mfd API,
it'll be unfair to expect that child be removed properly using mfd
API. Like in this patch, the device is created using
of_platform_populate (not a mfd API) but is removed using
mfd_remove_devices (mfd API) [which should result in an abort].
This means mfd framework does not have an API to create a device from
dt data or so do I think since of_platform_populate() is used. Thats
why I suggested the idea of extending mfd_add_devices() (or adding a
new API in mfd framework) to create child devices from dt data so that
we'll have API's in mfd framework to both create and delete a device.

Thanks
Kishon
