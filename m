Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab2CII02 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 03:26:28 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41620 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab2CII01 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 03:26:27 -0500
MIME-Version: 1.0
In-Reply-To: <20120305120743.GE3224@opensource.wolfsonmicro.com>
References: <CAJ0PZbRsh_Cnqy8Vtf1FWLajBr=R5iQ=Jog+w+qPE-uKrh5XQA@mail.gmail.com>
	<20120228164413.GA11021@kroah.com>
	<20120228165727.GO3683@opensource.wolfsonmicro.com>
	<20120228170246.GA11415@kroah.com>
	<20120228174505.GP3683@opensource.wolfsonmicro.com>
	<CAJ0PZbT=yD3SFBVYbcL37Dgyc3UVzk2LRQ_VWABW4cY_hfDuHA@mail.gmail.com>
	<20120229123511.GA7730@opensource.wolfsonmicro.com>
	<CAJ0PZbQVO-NMO_DxuSuY5xU3zXus=x+x3SFpXZEcA7n-CGX9Uw@mail.gmail.com>
	<20120305120743.GE3224@opensource.wolfsonmicro.com>
Date: Fri, 9 Mar 2012 17:26:26 +0900
Message-ID: <CAJ0PZbQ3nJXUnzVrKa8qWa852FawJtzZVSANG=ry_Sy0-JuFVg@mail.gmail.com>
Subject: Re: [PULL-REQUEST] EXTCON Patches (Re: [PATCH v6 0/5] Introduce
 External Connector Class (extcon))
From: MyungJoo Ham <myungjoo.ham@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>,
        LKML <linux-kernel@vger.kernel.org>, NeilBrown <neilb@suse.de>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnevag?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        John Stultz <john.stultz@linaro.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 5, 2012 at 9:07 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Mon, Mar 05, 2012 at 04:59:42PM +0900, MyungJoo Ham wrote:
>> On Wed, Feb 29, 2012 at 9:35 PM, Mark Brown
>
>> > For things like headphone detection the actual switch they're providing
>> > has issues too even just within the switch API - it's called "h2w" with
>> > magic values.
>
>> Reading an H2W switch device driver
>> (http://git.ziggy471.com/frankenstine.git/plain/arch/arm/mach-msm/htc_headset_mgr.c),
>> I don't see why it won't be compatible after replacing the name from
>
> That's not the only such driver, that's one example of a machine
> specific accessory detection driver.  There's others out there such as
> the sec_jack driver which you converted into the ADC driver in your
> patches (if you look at how that gets deployed the overwhelming majority
> of users are headsets).
>
> The issue is the combination of the naming (h2w isn't very meaningful
> and only works with a single jack) and the magic numbers used for
> reporting state, plus the registration collisions.  Existing code can be
> ported over fairly easily but it's got issues as an ABI which we'd want
> to fix.

The ABI of simply ported (only with API name changes) ex-switch extcon
device won't be changed:

sprintf(buf, "%u\n", edev->state);

is kept used if edev->max_supported == 0, which means that it is not
using extcon-native multi-state features, which is true for any simply
ported ex-switch extcon device drivers because they won't provide
"supported_cable" array with extcon_dev struct.


Or, do you mean that extcon class should support not ex-swtich extcon
device drivers such as adc-jack.c (not ported from oldies) to support
"legacy" userspace application that is aware of only switch interface?

Then, we may simply let state's read ABI to use sprintf(buf, "%u\n",
edev->state); only regardless of device drivers. How do you think
about this?
(simply removing line 119, 121-130 of extcon_class.c)


Cheers!
MyungJoo.
-- 
MyungJoo Ham, Ph.D.
System S/W Lab, S/W Center, Samsung Electronics
