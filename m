Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab1DBQgM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 12:36:12 -0400
Received: from adelie.canonical.com ([91.189.90.139]:55070 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225Ab1DBQgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 12:36:09 -0400
Message-ID: <4D975072.1040507@canonical.com>
Date: Sat, 02 Apr 2011 12:36:02 -0400
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110307 Thunderbird/3.1.9
MIME-Version: 1.0
To: Jeffrey Brown <jeffbrown@android.com>
CC: Jiri Kosina <jkosina@suse.cz>, Henrik Rydberg <rydberg@euromail.se>,
        Simon Budig <simon@budig.de>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] hid-magicmouse: Increase evdev buffer size
References: <1301691819-2090-1-git-send-email-chase.douglas@canonical.com> <AANLkTim-tN=siA8tJVCzNZHs+oM0hN-N8Ckc+9ynnNpb@mail.gmail.com>
In-Reply-To: <AANLkTim-tN=siA8tJVCzNZHs+oM0hN-N8Ckc+9ynnNpb@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2011 07:51 PM, Jeffrey Brown wrote:
> I've got another change in the works that fixes this problem more
> systematically.

That would be great :). I still would like to see this patch added so
it's released with the 2.6.39 kernel and backported to earlier stable
releases. I hope that's not a problem.

Thanks,

-- Chase

> On Fri, Apr 1, 2011 at 2:03 PM, Chase Douglas
> <chase.douglas@canonical.com> wrote:
>> The evdev buffer isn't big enough when you get many fingers on the
>> device. Bump up the buffer to a reasonable size, matching what other
>> multitouch devices use. Without this change, events may be discarded in
>> the evdev buffer before they are read.
>>
>> Reported-by: Simon Budig <simon@budig.de>
>> Cc: Henrik Rydberg <rydberg@euromail.se>
>> Cc: Jiri Kosina <jkosina@suse.cz>
>> Cc: stable@kernel.org
>> Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
>> ---
>> Forgot to Cc the mailing lists on the first send.
>>
>>  drivers/hid/hid-magicmouse.c |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
>> index 698e645..404dcbc 100644
>> --- a/drivers/hid/hid-magicmouse.c
>> +++ b/drivers/hid/hid-magicmouse.c
>> @@ -418,6 +418,8 @@ static void magicmouse_setup_input(struct input_dev *input, struct hid_device *h
>>                        input_set_abs_params(input, ABS_MT_POSITION_Y, -2456,
>>                                2565, 4, 0);
>>                }
>> +
>> +               input_set_events_per_packet(input, 60);
>>        }
>>
>>        if (report_undeciphered) {
>> --
>> 1.7.4.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-input" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 

