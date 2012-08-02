Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab2HBQgb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 12:36:31 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:51812 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754025Ab2HBQg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 12:36:28 -0400
Message-ID: <501AAC42.4030103@xenotime.net>
Date: Thu, 02 Aug 2012 09:35:14 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg@redhat.com>,
        platform-driver-x86@vger.kernel.org
Subject: Re: linux-next: Tree for Aug 2 (drivers/platform/x86/apple-gmux.c)
References: <20120802141505.d30da7f7113e955679383acb@canb.auug.org.au> <501AA5A8.1070607@xenotime.net> <20120802161504.GG32395@thinkpad-t410> <501AA892.70207@xenotime.net> <20120802163154.GH32395@thinkpad-t410>
In-Reply-To: <20120802163154.GH32395@thinkpad-t410>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2012 09:31 AM, Seth Forshee wrote:

> On Thu, Aug 02, 2012 at 09:19:30AM -0700, Randy Dunlap wrote:
>> On 08/02/2012 09:15 AM, Seth Forshee wrote:
>>
>>> On Thu, Aug 02, 2012 at 09:07:04AM -0700, Randy Dunlap wrote:
>>>> On 08/01/2012 09:15 PM, Stephen Rothwell wrote:
>>>>
>>>>> Hi all,
>>>>>
>>>>> Please do not add anything to linux-next included branches/series that is
>>>>> destined for v3.7 until after v3.6-rc1 is released.
>>>>>
>>>>> Reminder: do not rebase your branches before asking Linus to pull them ...
>>>>>
>>>>> Changes since 20120731:
>>>>>
>>>>
>>>>
>>>> when CONFIG_ACPI is not enabled: (on i386)
>>>>
>>>> drivers/platform/x86/apple-gmux.c: In function 'gmux_probe':
>>>> drivers/platform/x86/apple-gmux.c:196:2: error: implicit declaration of function 'acpi_video_dmi_promote_vendor'
>>>> drivers/platform/x86/apple-gmux.c: In function 'gmux_remove':
>>>> drivers/platform/x86/apple-gmux.c:219:2: error: implicit declaration of function 'acpi_video_dmi_demote_vendor'
>>>>
>>>>
>>>> Full randconfig file is attached.
>>>
>>> I sent Matthew a patch that should fix this [1], but he doesn't seem to
>>> have picked it up yet.
>>>
>>> Seth
>>>
>>> [1] https://lkml.org/lkml/2012/7/2/257
>>>
>>
>>
>> That patch does not fix this build error.
>> There is still an implicit assumption in Kconfig and
>> the driver source that ACPI is enabled.
> 
> The functions in question are built or not based off of ACPI_VIDEO,
> which in turn depends on ACPI. So if ACPI=n, then ACPI_VIDEO=n and you
> can't configure APPLE_GMUX=(m|y). Is that right, or am I missing
> something?


This?

config APPLE_GMUX
	tristate "Apple Gmux Driver"
	depends on PNP
	depends on BACKLIGHT_CLASS_DEVICE
	depends on BACKLIGHT_APPLE=n || BACKLIGHT_APPLE
	depends on ACPI_VIDEO=n || ACPI_VIDEO
	^^^^^^^^^^^^^^^^^^^^^^^




-- 
~Randy
