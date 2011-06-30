Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029Ab1F3KSk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 06:18:40 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48280 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118Ab1F3KSe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 06:18:34 -0400
MIME-Version: 1.0
In-Reply-To: <4E0B360B.5050600@canonical.com>
References: <1309268154-6872-1-git-send-email-kengyu@canonical.com> <4E0B360B.5050600@canonical.com>
From: =?UTF-8?B?S2VuZy1Zw7wgTGlu?= <kengyu@canonical.com>
Date: Thu, 30 Jun 2011 11:17:52 +0100
X-Google-Sender-Auth: q3OHPII-10rO4BV6VuhV67WCruw
Message-ID: <BANLkTinwSHoV+BBG_jvLdg3c4o_uODNJvQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] ideapad-laptop: Ignore an unused VPC notification
To: Ike Panhc <ike.pan@canonical.com>
Cc: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, vanhoof@canonical.com,
        kent.lin@canonical.com, sylee@canonical.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 3:26 PM, Ike Panhc <ike.pan@canonical.com> wrote:
> On 06/28/2011 09:35 PM, Keng-Yu Lin wrote:
>> BIOS fires notifications in a constant period with VPC bit 1 set when the
>> power cord is unplugged.
>>
>> This event is not known yet to have any effect, but it makes the
>> call to sparse_keymap_report_event() and generates many KEY_UNKNOWNs.
>>
>> This causes the userspace (Gnome Power Manager in my case) unable
>> to enter the idle mode. As the result there is no screensaver showing up,
>> no dim backlight, etc.
>>
>> Signed-off-by: Keng-Yu Lin <kengyu@canonical.com>
>> ---
>>  drivers/platform/x86/ideapad-laptop.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
>> index bfdda33..820f013 100644
>> --- a/drivers/platform/x86/ideapad-laptop.c
>> +++ b/drivers/platform/x86/ideapad-laptop.c
>> @@ -463,7 +463,8 @@ static void ideapad_acpi_notify(struct acpi_device *adevice, u32 event)
>>                               ideapad_sync_rfk_state(adevice);
>>                       else if (vpc_bit == 4)
>>                               read_ec_data(handle, 0x12, &vpc2);
>> -                     else
>> +                     else if (vpc_bit == 1) {
>> +                     } else
>>                               ideapad_input_report(priv, vpc_bit);
>>               }
>>       }
>
> So far I know this event (coming with vpc_bit=1) is for Lenovo PM utility
> on Windows. For most of the machine this event is not implemented in BIOS.
>
> Its ok that we just ignore the event.
>
> I think it will be better if we can let sparse-keymap or any upper level
> application to ignore all unknown scancode or KEY_UNKNOWN but so far I do
> not know a better way then this patch.

I think sparse_keymap_report_event() sends the KEY_UNKNOWN on purpose
as a debugging aid.

We should prevent the call to it in ideapad-laptop. I think the patch
is probably the simplest way.

  Thanks,
-kengyu
