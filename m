Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab1GEGtm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 02:49:42 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37100 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775Ab1GEGtl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 02:49:41 -0400
MIME-Version: 1.0
In-Reply-To: <20110705061903.GD1625@opensource.wolfsonmicro.com>
References: <1309397507-24959-1-git-send-email-myungjoo.ham@samsung.com>
	<1309397507-24959-3-git-send-email-myungjoo.ham@samsung.com>
	<20110630052808.GA796@opensource.wolfsonmicro.com>
	<BANLkTikGR-HdVZ-5h3kW64wiFduuuiU6Vw@mail.gmail.com>
	<20110630055719.GA930@opensource.wolfsonmicro.com>
	<BANLkTin4sCfX1Ahb_Td6VWH28s7SukYN-g@mail.gmail.com>
	<20110630155634.GE3249@opensource.wolfsonmicro.com>
	<BANLkTikPOj6N=TQ=tayx7hTXcLAJd5zf7w@mail.gmail.com>
	<20110704171634.GD28726@opensource.wolfsonmicro.com>
	<CAJ0PZbST6Xp82HTxpspiSEbjPmSzUuiKaHsycUKfyBFPQsSA_Q@mail.gmail.com>
	<20110705061903.GD1625@opensource.wolfsonmicro.com>
Date: Tue, 5 Jul 2011 15:49:39 +0900
Message-ID: <CAJ0PZbSrB9Cc-2h0xGot6kYUGR-uu0f7GVq43c_fSEd5oTMEog@mail.gmail.com>
Subject: Re: [PATCH 3/3] MFD: MAX8997: IRQ definition moved to public header.
From: MyungJoo Ham <myungjoo.ham@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Donggeun Kim <dg77.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 5, 2011 at 3:19 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, Jul 05, 2011 at 02:57:54PM +0900, MyungJoo Ham wrote:
>> On Tue, Jul 5, 2011 at 2:16 AM, Mark Brown
>
>> > My understanding was that one of the goals of the power_supply subsystem
>> > was to support this sort of interaction? This (and your subsequent
>> > paragraphs) all sounds entirely sensible but it should be being dealt
>> > with at a higher level with the various charger drivers delivering
>> > events into a subsystem or board driver which coordinates them all.  It
>> > seems like the driver should be doing the work of dealing with the
>> > actual interrupts.
>
>> Yes, I also think that it is supposed to read and update attributes of
>> chargers. However, I don't see any ways to interconnect chargers and
>> related devices with power_supply subsystem.
>
> Nor do I, but this is just software so we should be able to make it do
> what's needed here.
>
>> If we let a user process interconnect the chargers and related
>> devices, we need to allow userland to access (both read and write)
>
> I didn't say anything about userspace, and I wouldn't expect userspace
> to do anything except policy here.
>

Ah.. then, I misunderstood "a higher level" in your previous reply was
userspace. Sorry, my bad.

I was just trying to say that
a) as long as we are connecting IRQ events of a device to another
device, the IRQ information is going to be needed as non-private, and
b) in the above case, we need to let the IRQ events of a device notify
other devices' drivers. (defined in a form of platform_data in the
case, specifying IRQ numbers for the notified devices requiring the
IRQ definitions to be included)

Anyway, I've been trying to implement some virtual device driver or
psuedo framework in kernel to interconnect charger related devices,
"charger manager". This code mentioned is to support that "charger
manager". It is sort of at a higher level of charger related devices,
taking device names of them as a platform data. The platform data
taking the IRQ numbers is the one for that "charger manager".



Thank you.

- MyungJoo

-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: 82-10-6714-2858
