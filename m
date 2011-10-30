Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934310Ab1J3RYI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 13:24:08 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:55619 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934285Ab1J3RYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 13:24:07 -0400
Message-ID: <4EAD8832.9090509@xenotime.net>
Date: Sun, 30 Oct 2011 10:24:02 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RESEND] media: tea5764: reconcile Kconfig symbol and
 macro
References: <1319976530.14409.17.camel@x61.thuisdomein>	 <4EAD7E9F.6050709@xenotime.net> <1319994738.14409.37.camel@x61.thuisdomein>
In-Reply-To: <1319994738.14409.37.camel@x61.thuisdomein>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/11 10:12, Paul Bolle wrote:
> On Sun, 2011-10-30 at 09:43 -0700, Randy Dunlap wrote:
>> On 10/30/11 05:08, Paul Bolle wrote:
>>> The Kconfig symbol RADIO_TEA5764_XTAL is unused. The code does use a
>>> RADIO_TEA5764_XTAL macro, but does that rather peculiar. But there seems
>>> to be a way to keep both. (The easiest way out would be to rip out both
>>> the Kconfig symbol and the macro.)
>>>
>>> Note there's also a module parameter 'use_xtal' to influence all this.
>>
>> It's curious that the module parameter is only available when the driver
>> is builtin (=y) but not built as a loadable module (=m):
> 
> As far as I can see the module parameter is available in both cases but
> defaults to different values when builtin and when loadable. 

Ah, you are correct.  Thanks.

>> config RADIO_TEA5764_XTAL
>> 	bool "TEA5764 crystal reference"
>> 	depends on RADIO_TEA5764=y
>> 	default y
> 
> 0) I've noticed similar dependencies (while doing some other Kconfig
> related clean up) with a number of other config entries in that same
> Kconfig file:
>     $ git grep -n "depends on.*=y" drivers/media/radio/
>     drivers/media/radio/Kconfig:60: depends on RADIO_RTRACK=y
>     drivers/media/radio/Kconfig:83: depends on RADIO_RTRACK2=y
>     drivers/media/radio/Kconfig:106:        depends on RADIO_AZTECH=y
>     drivers/media/radio/Kconfig:135:        depends on RADIO_GEMTEK=y
>     drivers/media/radio/Kconfig:147:        depends on RADIO_GEMTEK=y
>     drivers/media/radio/Kconfig:239:        depends on RADIO_TERRATEC=y
>     drivers/media/radio/Kconfig:257:        depends on RADIO_TRUST=y
>     drivers/media/radio/Kconfig:280:        depends on RADIO_TYPHOON=y
>     drivers/media/radio/Kconfig:287:        depends on RADIO_TYPHOON=y
>     drivers/media/radio/Kconfig:314:        depends on RADIO_ZOLTRIX=y
>     drivers/media/radio/Kconfig:385:        depends on RADIO_TEA5764=y 
> 
> 1) It seems the logic behind those config symbols is mostly like this:
> - if the driver for a radio is builtin: default some setting for that
>   radio to a sane value, but allow overriding of that setting on the
>   kernel commandline (through a module parameter)
> - if the driver for a radio is a module: default that same setting to
>   something invalid and _force_ the use of module parameters to get a
>   sane value
> 
> This logic isn't implemented flawless but it does look to me that this
> is intentional.
> 
> 2) I'm not sure why things are done that way. Why can't builtin drivers
> and loadable drivers default to identical values? But perhaps I'm just
> misunderstanding the code.

They could default to identical values.  Maybe someone thinks that
it's more difficult to pass parameters to builtin drivers so they
just try to use some sane defaults for them instead, whereas it's
easy (easier) to pass parameters to loadable modules.  ??


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
