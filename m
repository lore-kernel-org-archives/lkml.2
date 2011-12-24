Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab1LXONI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Dec 2011 09:13:08 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:43755 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887Ab1LXONG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Dec 2011 09:13:06 -0500
X-Originating-IP: 217.70.178.139
X-Originating-IP: 86.186.9.152
From: Andrzej Prochyra <andrzej@prochyra.name>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: mjg@redhat.com, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Platform: samsung-laptop: add DMI information for Samsung N150 Plus
References: <87ty4ss0z4.fsf@prochyra.name>
	<CAHR064h7a=RQq=p1J+gKpC5_6ow8ChUFFkC39HwtmerHaMksjw@mail.gmail.com>
Date: Sat, 24 Dec 2011 14:12:57 +0000
In-Reply-To: <CAHR064h7a=RQq=p1J+gKpC5_6ow8ChUFFkC39HwtmerHaMksjw@mail.gmail.com>
	(Corentin Chary's message of "Fri, 23 Dec 2011 15:15:23 +0100")
Message-ID: <87ty4qdpna.fsf@prochyra.name>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corentin Chary <corentin.chary@gmail.com> writes:

> On Thu, Dec 22, 2011 at 11:19 PM, Andrzej Prochyra
> <andrzej@prochyra.name> wrote:
>> From: Andrzej Prochyra <andrzej@prochyra.name>
>>
>> Adds DMI information for Samsung N150 Plus which identifies itself as
>> "N150P" so that the driver loads and the 'acpi_backlight=vendor'
>> parameter does not need to be used in order for backlight control to
>> work.
>>
>> Signed-off-by: Andrzej Prochyra <andrzej@prochyra.name>
>> ---
>>  drivers/platform/x86/samsung-laptop.c |   10 ++++++++++
>>  1 files changed, 10 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/platform/x86/samsung-laptop.c b/drivers/platform/x86/samsung-laptop.c
>> index 09e26bf..e3a496a 100644
>> --- a/drivers/platform/x86/samsung-laptop.c
>> +++ b/drivers/platform/x86/samsung-laptop.c
>> @@ -780,6 +780,16 @@ static struct dmi_system_id __initdata samsung_dmi_table[] = {
>>                },
>>                .callback = dmi_check_cb,
>>        },
>> +       {
>> +               .ident = "N150P",
>> +               .matches = {
>> +                       DMI_MATCH(DMI_SYS_VENDOR,
>> +                                       "SAMSUNG ELECTRONICS CO., LTD."),
>> +                       DMI_MATCH(DMI_PRODUCT_NAME, "N150P"),
>> +                       DMI_MATCH(DMI_BOARD_NAME, "N150P"),
>> +               },
>> +               .callback = dmi_check_cb,
>> +       },
>>        { },
>>  };
>>  MODULE_DEVICE_TABLE(dmi, samsung_dmi_table);
>> --
>> 1.7.4.1
>
> Hi,
> On top of what is based this patch ?

The patch is against the mainline kernel from
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

(The MAINTAINERS file gives the git tree
git://git.kernel.org/pub/scm/linux/kernel/git/mjg59/platform-drivers-x86.git
in the X86 PLATFORM DRIVERS section but this does not seem to exist.)

> 
> Could you try
> https://github.com/iksaif/platform-drivers-x86/tree/samsung-laptop or
> https://github.com/iksaif/samsung-laptop-dkms ?  Are both ACPI and VGA
> backlight non-fonctional ? What's in /sys/class/backlight/ ?  Thanks

I have tried:

* The mainline kernel
* The mainline kernel with my patch applied
* https://github.com/iksaif/platform-drivers-x86/tree/samsung-laptop

Here are my results:

MAINLINE KERNEL
---------------

'samsung-laptop' module not loaded.

    $ ls /sys/class/backlight
    acpi_video0 intel_backlight

'acpi_video0' not functional.  Brightness can be controlled through
intel_backlight interface.  There are 21 brightness levels and the
backlight can be turned off.


WITH MY PATCH APPLIED
---------------------

'samsung-laptop' module now loaded.

    $ ls /sys/class/backlight
    acpi_video0 intel_backlight samsung

Backlight can be controlled through intel_backlight and samsung
interfaces.  The samsung interface has only 9 brightness levels and 0
does not turn the backlight off.


SAMSUNG-LAPTOP BRANCH
---------------------

'samsung-laptop' module loaded.

    $ ls /sys/class/backlight
    acpi_video0 intel_backlight

Brightness can be controlled through intel_backlight.

With 'acpi_backlight=vendor':

    $ ls /sys/class/backlight
    intel_backlight samsung

Brightness can be controlled as with my patch.


CONCLUSION
----------

For kernel versions where 'intel_backlight' is available, samsung-laptop
is not needed for backlight control on this machine?  
-- 
Andrzej Prochyra
<andrzej@prochyra.name>
