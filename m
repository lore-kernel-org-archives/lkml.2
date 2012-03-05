Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357Ab2CEH7o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 02:59:44 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40642 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756204Ab2CEH7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 02:59:43 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of myungjoo.ham@gmail.com designates 10.43.44.202 as permitted sender) smtp.mail=myungjoo.ham@gmail.com; dkim=pass header.i=myungjoo.ham@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120229123511.GA7730@opensource.wolfsonmicro.com>
References: <CAJ0PZbRsh_Cnqy8Vtf1FWLajBr=R5iQ=Jog+w+qPE-uKrh5XQA@mail.gmail.com>
	<20120228164413.GA11021@kroah.com>
	<20120228165727.GO3683@opensource.wolfsonmicro.com>
	<20120228170246.GA11415@kroah.com>
	<20120228174505.GP3683@opensource.wolfsonmicro.com>
	<CAJ0PZbT=yD3SFBVYbcL37Dgyc3UVzk2LRQ_VWABW4cY_hfDuHA@mail.gmail.com>
	<20120229123511.GA7730@opensource.wolfsonmicro.com>
Date: Mon, 5 Mar 2012 16:59:42 +0900
Message-ID: <CAJ0PZbQVO-NMO_DxuSuY5xU3zXus=x+x3SFpXZEcA7n-CGX9Uw@mail.gmail.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 9:35 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, Feb 29, 2012 at 11:05:39AM +0900, MyungJoo Ham wrote:
>> On Wed, Feb 29, 2012 at 2:45 AM, Mark Brown
>
>> > Don't know if anyone has a specific plan at the moment, though there's
>> > enough people care that I'd imagine it'll happen if Android decides to
>> > use this stuff.
>
>> > That said I don't see this as a blocker myself - it's more like an
>> > afternoon or whatever of work than a serious development effort to do
>> > the updates, but a similar thing applies to most of the Android
>> > userspace updates.
>
>> I'm not sure which Android kernel devide drivers are going to be upstreamed.
>
> There's a lot of things that are just generic functionality and aren't
> at all Android specific, a lot of which is already upstream but just not
> exporting the switch API but instead using other existing kernel APIs.
>
>> However, if the swtich device driver writers decide to keep the
>> functionality limited to the original Android switch class by not
>> providing cable names additionally, the changes will probably be
>> limited to ":s/switch/extcon/g" for API calls and struct name.
>
> For things like headphone detection the actual switch they're providing
> has issues too even just within the switch API - it's called "h2w" with
> magic values.

Reading an H2W switch device driver
(http://git.ziggy471.com/frankenstine.git/plain/arch/arm/mach-msm/htc_headset_mgr.c),
I don't see why it won't be compatible after replacing the name from
switch to extcon except for one more parameter at
switch_dev_register() to extcon_dev_register(). This needs to add the
struct device* dev of the caller probe function:
switch_dev_register(&hi->sdev); should become
extcon_dev_register(&hi->sdev, &pdev->dev);

Because the probe function of this H2W driver keeps
hi->sdev->supported_cable NULL, which was not available in switch
class, any magic values with switch_set_state() and switch_get_state()
should not be affected. Besides, adding callbacks (print_name,
print_state) overrides the behavior of extcon as well as with switch.
I don't see elsewhere to keep any magic values within switch device
drivers.


Cheers!
MyungJoo.

-- 
MyungJoo Ham, Ph.D.
System S/W Lab, S/W Center, Samsung Electronics
