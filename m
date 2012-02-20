Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290Ab2BTO1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 09:27:09 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39039 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab2BTO1F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 09:27:05 -0500
MIME-Version: 1.0
In-Reply-To: <CANq1E4TQ0qUrOTNQOmC2K+3zC2_7Om3TcRH=w78VReHat=36+w@mail.gmail.com>
References: <1326784098-3244-1-git-send-email-corentincj@iksaif.net>
	<CAHR064jyOYaRUjZp370ewLGQSKAhhB7gZ4PS7Feb_AzBLGi1tA@mail.gmail.com>
	<CAHR064iXr5Z1WNdD=rjn_ACDEX8EaRgrCg0hj1U=c=Lz9rN__A@mail.gmail.com>
	<CANq1E4TQ0qUrOTNQOmC2K+3zC2_7Om3TcRH=w78VReHat=36+w@mail.gmail.com>
Date: Mon, 20 Feb 2012 15:27:00 +0100
Message-ID: <CAHR064jHMk0WM69xK7_qD5VoGeU6vi88yRkGwGiY1f2R6AQ+Xg@mail.gmail.com>
Subject: Re: [PATCH] ACPI / Video: blacklist some samsung laptops
From: Corentin Chary <corentin.chary@gmail.com>
To: David Herrmann <dh.herrmann@googlemail.com>
Cc: Len Brown <lenb@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        linux-kernel@vger.kernel.org, Andrzej Prochyra <andrzej@prochyra.name>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        =?UTF-8?Q?Richard_Sch=C3=BCtz?= <r.schtz@t-online.de>,
        Seth Forshee <seth.forshee@canonical.com>, linux-acpi@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 12:06 PM, David Herrmann
<dh.herrmann@googlemail.com> wrote:
> Hi Len
>
> On Sun, Feb 19, 2012 at 8:56 PM, Corentin Chary
> <corentin.chary@gmail.com> wrote:
>> On Mon, Jan 30, 2012 at 9:26 AM, Corentin Chary
>> <corentin.chary@gmail.com> wrote:
>>> On Tue, Jan 17, 2012 at 8:08 AM, Corentin Chary <corentincj@iksaif.net> wrote:
>>>> On these laptops, the ACPI video is not functional, and very unlikely
>>>> to be fixed by the vendor. Note that intel_backlight works for some
>>>> of these laptops, and the backlight from samsung-laptop always work.
>>>>
>>>> The good news is that newer laptops have functional ACPI video device
>>>> and won't end up growing this list.
>>>>
>>>> Signed-off-by: Corentin Chary <corentincj@iksaif.net>
>>>> ---
>>>>  drivers/acpi/video_detect.c |   49 +++++++++++++++++++++++++++++++++++++++++++
>>>>  1 files changed, 49 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
>>>> index 45d8097..66be45e 100644
>>>> --- a/drivers/acpi/video_detect.c
>>>> +++ b/drivers/acpi/video_detect.c
>>>> @@ -132,6 +132,53 @@ find_video(acpi_handle handle, u32 lvl, void *context, void **rv)
>>>>        return AE_OK;
>>>>  }
>>>>
>>>> +/* Force to use vendor driver when the ACPI device is known to be
>>>> + * buggy */
>>>> +static int video_detect_force_vendor(const struct dmi_system_id *d)
>>>> +{
>>>> +       acpi_video_support |= ACPI_VIDEO_BACKLIGHT_DMI_VENDOR;
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +static struct dmi_system_id video_detect_dmi_table[] = {
>>>> +       {
>>>> +        .callback = video_detect_force_vendor,
>>>> +        .ident = "N150P",
>>>> +        .matches = {
>>>> +               DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
>>>> +               DMI_MATCH(DMI_PRODUCT_NAME, "N150P"),
>>>> +               DMI_MATCH(DMI_BOARD_NAME, "N150P"),
>>>> +               },
>>>> +       },
>>>> +       {
>>>> +        .callback = video_detect_force_vendor,
>>>> +        .ident = "N145P/N250P/N260P",
>>>> +        .matches = {
>>>> +               DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
>>>> +               DMI_MATCH(DMI_PRODUCT_NAME, "N145P/N250P/N260P"),
>>>> +               DMI_MATCH(DMI_BOARD_NAME, "N145P/N250P/N260P"),
>>>> +               },
>>>> +       },
>>>> +       {
>>>> +        .callback = video_detect_force_vendor,
>>>> +        .ident = "N150/N210/N220",
>>>> +        .matches = {
>>>> +               DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
>>>> +               DMI_MATCH(DMI_PRODUCT_NAME, "N150/N210/N220"),
>>>> +               DMI_MATCH(DMI_BOARD_NAME, "N150/N210/N220"),
>>>> +               },
>>>> +       },
>>>> +       {
>>>> +        .callback = video_detect_force_vendor,
>>>> +        .ident = "NF110/NF210/NF310",
>>>> +        .matches = {
>>>> +               DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
>>>> +               DMI_MATCH(DMI_PRODUCT_NAME, "NF110/NF210/NF310"),
>>>> +               DMI_MATCH(DMI_BOARD_NAME, "NF110/NF210/NF310"),
>>>> +               },
>>>> +       },
>>>> +};
>>>> +
>>>>  /*
>>>>  * Returns the video capabilities of a specific ACPI graphics device
>>>>  *
>>>> @@ -164,6 +211,8 @@ long acpi_video_get_capabilities(acpi_handle graphics_handle)
>>>>                 *              ACPI_VIDEO_BACKLIGHT_DMI_VENDOR;
>>>>                 *}
>>>>                 */
>>>> +
>>>> +               dmi_check_system(video_detect_dmi_table);
>>>>        } else {
>>>>                status = acpi_bus_get_device(graphics_handle, &tmp_dev);
>>>>                if (ACPI_FAILURE(status)) {
>>>> --
>>>> 1.7.5.4
>>>>
>>>
>>> Hi Len,
>>>
>>> Maybe this patch should go through your tree and not platform-drivers-x86 ?
>>
>> Ping ?
>
> This is actually a regression on Samsung notebooks as the backlight is
> no longer working with linux-3.2. It would be really nice to see this
> in the stable branch or at least in linux-3.3.
>
> The samsung driver disables its own backlight driver if ACPI core
> handles the backlight since linux-3.2. If you don't want to pickup
> this patch it would be nice to see the samsung driver fixing this
> issue.
>
> Regards
> David

David, please note that non of my changes are merged in 3.2 or 3.3,
they are still in the platform-x86 tree.
But you are right, if they are merged in 3.4 (and I really hope so)
then we will need this patch or there will be a regression.
Anyway, this patch can, and should, be merged as soon as possible
because DE or even xrandr may want to use the non functionnal acpi
backlight instead of others.

Thanks,


-- 
Corentin Chary
http://xf.iksaif.net
