Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab2BST4L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 14:56:11 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42288 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827Ab2BST4I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 14:56:08 -0500
MIME-Version: 1.0
In-Reply-To: <CAHR064jyOYaRUjZp370ewLGQSKAhhB7gZ4PS7Feb_AzBLGi1tA@mail.gmail.com>
References: <1326784098-3244-1-git-send-email-corentincj@iksaif.net>
	<CAHR064jyOYaRUjZp370ewLGQSKAhhB7gZ4PS7Feb_AzBLGi1tA@mail.gmail.com>
Date: Sun, 19 Feb 2012 20:56:05 +0100
Message-ID: <CAHR064iXr5Z1WNdD=rjn_ACDEX8EaRgrCg0hj1U=c=Lz9rN__A@mail.gmail.com>
Subject: Re: [PATCH] ACPI / Video: blacklist some samsung laptops
From: Corentin Chary <corentin.chary@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-kernel@vger.kernel.org,
        Andrzej Prochyra <andrzej@prochyra.name>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        David Herrmann <dh.herrmann@googlemail.com>,
        =?UTF-8?Q?Richard_Sch=C3=BCtz?= <r.schtz@t-online.de>,
        Seth Forshee <seth.forshee@canonical.com>, linux-acpi@vger.kernel.org,
        Corentin Chary <corentincj@iksaif.net>,
        platform-driver-x86@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 9:26 AM, Corentin Chary
<corentin.chary@gmail.com> wrote:
> On Tue, Jan 17, 2012 at 8:08 AM, Corentin Chary <corentincj@iksaif.net> wrote:
>> On these laptops, the ACPI video is not functional, and very unlikely
>> to be fixed by the vendor. Note that intel_backlight works for some
>> of these laptops, and the backlight from samsung-laptop always work.
>>
>> The good news is that newer laptops have functional ACPI video device
>> and won't end up growing this list.
>>
>> Signed-off-by: Corentin Chary <corentincj@iksaif.net>
>> ---
>>  drivers/acpi/video_detect.c |   49 +++++++++++++++++++++++++++++++++++++++++++
>>  1 files changed, 49 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
>> index 45d8097..66be45e 100644
>> --- a/drivers/acpi/video_detect.c
>> +++ b/drivers/acpi/video_detect.c
>> @@ -132,6 +132,53 @@ find_video(acpi_handle handle, u32 lvl, void *context, void **rv)
>>        return AE_OK;
>>  }
>>
>> +/* Force to use vendor driver when the ACPI device is known to be
>> + * buggy */
>> +static int video_detect_force_vendor(const struct dmi_system_id *d)
>> +{
>> +       acpi_video_support |= ACPI_VIDEO_BACKLIGHT_DMI_VENDOR;
>> +       return 0;
>> +}
>> +
>> +static struct dmi_system_id video_detect_dmi_table[] = {
>> +       {
>> +        .callback = video_detect_force_vendor,
>> +        .ident = "N150P",
>> +        .matches = {
>> +               DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
>> +               DMI_MATCH(DMI_PRODUCT_NAME, "N150P"),
>> +               DMI_MATCH(DMI_BOARD_NAME, "N150P"),
>> +               },
>> +       },
>> +       {
>> +        .callback = video_detect_force_vendor,
>> +        .ident = "N145P/N250P/N260P",
>> +        .matches = {
>> +               DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
>> +               DMI_MATCH(DMI_PRODUCT_NAME, "N145P/N250P/N260P"),
>> +               DMI_MATCH(DMI_BOARD_NAME, "N145P/N250P/N260P"),
>> +               },
>> +       },
>> +       {
>> +        .callback = video_detect_force_vendor,
>> +        .ident = "N150/N210/N220",
>> +        .matches = {
>> +               DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
>> +               DMI_MATCH(DMI_PRODUCT_NAME, "N150/N210/N220"),
>> +               DMI_MATCH(DMI_BOARD_NAME, "N150/N210/N220"),
>> +               },
>> +       },
>> +       {
>> +        .callback = video_detect_force_vendor,
>> +        .ident = "NF110/NF210/NF310",
>> +        .matches = {
>> +               DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
>> +               DMI_MATCH(DMI_PRODUCT_NAME, "NF110/NF210/NF310"),
>> +               DMI_MATCH(DMI_BOARD_NAME, "NF110/NF210/NF310"),
>> +               },
>> +       },
>> +};
>> +
>>  /*
>>  * Returns the video capabilities of a specific ACPI graphics device
>>  *
>> @@ -164,6 +211,8 @@ long acpi_video_get_capabilities(acpi_handle graphics_handle)
>>                 *              ACPI_VIDEO_BACKLIGHT_DMI_VENDOR;
>>                 *}
>>                 */
>> +
>> +               dmi_check_system(video_detect_dmi_table);
>>        } else {
>>                status = acpi_bus_get_device(graphics_handle, &tmp_dev);
>>                if (ACPI_FAILURE(status)) {
>> --
>> 1.7.5.4
>>
>
> Hi Len,
>
> Maybe this patch should go through your tree and not platform-drivers-x86 ?

Ping ?

-- 
Corentin Chary
http://xf.iksaif.net
