Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab2AHMgt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 07:36:49 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60589 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab2AHMgr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 07:36:47 -0500
MIME-Version: 1.0
In-Reply-To: <20120108104630.GA4354@ubuntu-mba>
References: <20120105150832.GA25386@ubuntu-macmini>
	<1325945558-4661-1-git-send-email-corentincj@iksaif.net>
	<20120108104630.GA4354@ubuntu-mba>
Date: Sun, 8 Jan 2012 13:36:45 +0100
Message-ID: <CAHR064h287UFd4bBnWCJz61qw-wZBYRrF=5FKAmFg8YwaWN1Zw@mail.gmail.com>
Subject: Re: [PATCH] ACPI / Video: blacklist some samsung laptops
From: Corentin Chary <corentin.chary@gmail.com>
To: Corentin Chary <corentincj@iksaif.net>,
        platform-driver-x86@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        linux-kernel@vger.kernel.org, Andrzej Prochyra <andrzej@prochyra.name>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        David Herrmann <dh.herrmann@googlemail.com>,
        =?UTF-8?Q?Richard_Sch=C3=BCtz?= <r.schtz@t-online.de>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 8, 2012 at 11:46 AM, Seth Forshee
<seth.forshee@canonical.com> wrote:
> On Sat, Jan 07, 2012 at 03:12:38PM +0100, Corentin Chary wrote:
>> On these laptops, the ACPI video is not functional, and very unlikely
>> to be fixed by the vendor. Note that intel_backlight works for some
>> of these laptops, and the backlight from samsung-laptop always work.
>>
>> The good news is that newer laptops have functional ACPI video device
>> and won't end up growing this list.
>>
>> Signed-off-by: Corentin Chary <corentincj@iksaif.net>
>> ---
>>
>> Could the concerned people test this patch and check that it correctly
>> disable the acpi_video backlight ?
>>
>>  drivers/acpi/video_detect.c |   40 ++++++++++++++++++++++++++++++++++++++++
>>  1 files changed, 40 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
>> index 45d8097..376bce2 100644
>> --- a/drivers/acpi/video_detect.c
>> +++ b/drivers/acpi/video_detect.c
>> @@ -132,6 +132,44 @@ find_video(acpi_handle handle, u32 lvl, void *context, void **rv)
>>       return AE_OK;
>>  }
>>
>> +/* Force to use vendor driver when the ACPI device is known to be
>> + * buggy */
>> +static int video_detect_force_vendor(const struct dmi_system_id *d)
>> +{
>> +     acpi_video_support |= ACPI_VIDEO_BACKLIGHT_DMI_VENDOR;
>> +     return 0;
>> +}
>> +
>> +static struct dmi_system_id video_detect_dmi_table[] = {
>> +     {
>> +      .callback = video_detect_force_vendor,
>> +      .ident = "N150P",
>> +      .matches = {
>> +             DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
>> +             DMI_MATCH(DMI_PRODUCT_NAME, "N150P"),
>> +             DMI_MATCH(DMI_BOARD_NAME, "N150P"),
>> +             },
>> +     },
>> +     {
>> +      .callback = video_detect_force_vendor,
>> +      .ident = "N145P/N250P/N260P",
>> +      .matches = {
>> +             DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
>> +             DMI_MATCH(DMI_PRODUCT_NAME, "N145P/N250P/N260P"),
>> +             DMI_MATCH(DMI_BOARD_NAME, "N145P/N250P/N260P"),
>> +             },
>> +     },
>> +     {
>> +      .callback = video_detect_force_vendor,
>> +      .ident = "N150/N210/N220",
>> +      .matches = {
>> +             DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
>> +             DMI_MATCH(DMI_PRODUCT_NAME, "N150/N210/N220"),
>> +             DMI_MATCH(DMI_BOARD_NAME, "N150/N210/N220"),
>> +             },
>> +     },
>> +};
>> +
>
> I don't see NF110/NF210/NF310 in this list. Was that an oversight?

Ooops. Could you add it and try the patch, then send me lines you added ?
Thanks,

-- 
Corentin Chary
http://xf.iksaif.net
