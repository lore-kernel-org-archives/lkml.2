Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab1F3XYO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 19:24:14 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52188 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab1F3XYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 19:24:13 -0400
Message-ID: <4E0D0595.5070205@gmail.com>
Date: Fri, 01 Jul 2011 09:24:05 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: Bill Gatliff <bgat@billgatliff.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        viresh kumar <viresh.kumar@st.com>, Shawn Guo <shawn.guo@linaro.org>,
        Ryan Mallon <ryan@bluewatersys.com>
Subject: Re: [PATCH 1/3] PWM: add pwm framework support
References: <1309430517-23821-1-git-send-email-s.hauer@pengutronix.de> <1309430517-23821-2-git-send-email-s.hauer@pengutronix.de> <BANLkTikQGFA7XcuAtEEi7_4m-j6-00sZ6Q@mail.gmail.com> <201106301441.24493.arnd@arndb.de> <BANLkTin_htv2z3D9Bbf6N8Y7UKFRvPtvOg@mail.gmail.com> <20110630170229.GP6069@pengutronix.de>
In-Reply-To: <20110630170229.GP6069@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/11 03:02, Sascha Hauer wrote:
> Bill,
>
> On Thu, Jun 30, 2011 at 11:17:54AM -0500, Bill Gatliff wrote:
>> Guys:
>>
>> On Thu, Jun 30, 2011 at 7:41 AM, Arnd Bergmann<arnd@arndb.de>  wrote:
>>
>>> A lot of people want to see a framework get merged, and I think it's
>>> great that Sascha has volunteered to do the work to push that
>>> through this time, especially since you have not been able to
>>> finish your work.
>> Sascha is wasting his time by reinventing the wheel.  He's traveling
>> over exactly the same path I have already covered.  In fact, some of
>> his reviewer comments are almost word-for-word the same as those I
>> have received and addressed in the past.
>>
>> My patches were always kept current in this mailing list and others,
>> and Sascha clearly has the skills necessary to make improvements and
>> corrections should he have chosen to do so.
> I think that you made the fundamental mistake to completly ignore the
> existing pwm API and its users. With a competing api we are basically
> stuck. We can't convert the existing hardware drivers to the new API
> because leds-pwm.c, pwm_bl.c and others still depend on the old API and
> boards using it would break.

I don't think this is really a blocker to Bill's patches. There are 
three (that I can see) pwm users currently:
drivers/video/backlight/pwm_bl.c
drivers/leds/leds-pwm.c
drivers/input/misc/pwm-beeper.c

All of those drivers are trivial and good easily be updated to work with 
Bill's patches. Bill already provided a leds-pwm driver.

There is also the interesting case of the Atmel pwm driver, which does 
not fit the current pwm api and has its own backlight and leds drivers. 
Bill's patches addressed this, Sasha's patches do not. If we merge 
Sasha's patches then we are going to be in the same position as Bill's 
patches at some point in that we need to change the pwm api (and all its 
users) to meet the needs of the Atmel (and any similar hardware) pwm device.

The ep93xx pwm driver (drivers/misc/ep93xx-pwm.c) also does not fit the 
current api (though it could), but instead provides a sysfs interface to 
user-space. Again, this was addressed by Bill's patches.

> We can't convert the function drivers
> either because again this would break boards for which only an old style
> pwm driver exists.  So the logical thing to do is to put a step in
> between: Consolidate the existing drivers and *then* change the API
> atomically so that nothing breaks. Your patches don't do this, so I
> don't think at all that what I did is duplication of work.

You have to modify the drivers anyway match the new pwm core. The Atmel 
and ep93xx drivers are going to be difficult to merge into the new api, 
and seeing as there are only about seven pwm drivers total in the kernel 
I think its a significant portion. Any pwm api patchset could easily 
convert all of the existing pwm drivers without becoming overly massive.

If we merge Sasha's api, then we can move most of the existing drivers 
and maybe add some new ones, but we will still have the unconsolidated 
outliers. When (if?) we try to fix those we will probably need to change 
the pwm api and therefore all of the drivers to. So its basically a case 
of do the effort now (Bill's patches) or do it later. Doing it later 
will probably require more effort.

> Given the current rush to move drivers out of arch/ it probably won't
> take long until all pwm drivers are moved to drivers/pwm/ and converted
> to use the framework, and then you have a good base to put your work onto.
> So please don't complain too much: We are currently only doing the work
> you didn't want to do.
>

You can move all of the drivers out of arch now if you want. You just 
need to make sure you are only compiling one of them in. The real job in 
consolidating means making sure that the api meets the needs of all of 
the drivers. The in kernel Atmel pwm driver at least is not going to 
convert easily to this api.

Also, please not my change of email address for future emails.

Thanks,
~Ryan


