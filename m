Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab2JALxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 07:53:18 -0400
Received: from na3sys009aog136.obsmtp.com ([74.125.149.85]:43941 "EHLO
	na3sys009aog136.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752311Ab2JALxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 07:53:16 -0400
MIME-Version: 1.0
In-Reply-To: <20121001114454.GA9170@sirena.org.uk>
References: <1349089282-22105-1-git-send-email-sourav.poddar@ti.com>
	<CAAe_U6+zEGuwMC1yn7O=LXE6PhPvPc2i7DCF0EAprkE8s+-iEw@mail.gmail.com>
	<20121001114454.GA9170@sirena.org.uk>
Date: Mon, 1 Oct 2012 17:23:15 +0530
Message-ID: <CAAe_U6JX9QDWvWA3KH7E9sOv0EHGkozVONuXDgn+a2MZ4GTE7Q@mail.gmail.com>
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

On Mon, Oct 1, 2012 at 5:14 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Mon, Oct 01, 2012 at 05:00:06PM +0530, ABRAHAM, KISHON VIJAY wrote:
>> On Mon, Oct 1, 2012 at 4:31 PM, Sourav Poddar <sourav.poddar@ti.com> wrote:
>
> Delete irrelevant context from your replies, it makes it much easier to
> find new text.
>
>> > +static int smsc_i2c_remove(struct i2c_client *i2c)
>> > +{
>> > +       struct smsc *smsc = i2c_get_clientdata(i2c);
>> > +
>> > +       mfd_remove_devices(smsc->dev);
>
>> IMO, this should have resulted in an abort (hint: see
>> mfd_remove_devices_fn()). Trying to do mfd_remove_devices without
>> mfd_add_devices(). Use device_for_each_child here to remove the
>> device.
>
> No, this is not at all sensible - if there's an mfd_remove_devices()
> function we really ought to be able to use it to remove the children.
> If we can't do that we should fix the API usability, not open code the
> same stuff in every user.

What makes more sense to me is extend mfd_add_devices to create child
devices from dt data. Then for removing devices, one can use
mfd_remove_devices().

Thanks
Kishon
