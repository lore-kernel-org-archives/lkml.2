Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab1L2LqI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 06:46:08 -0500
Received: from mailout05.t-online.de ([194.25.134.82]:34810 "EHLO
	mailout05.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab1L2LqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 06:46:07 -0500
Message-ID: <4EFC52F0.1010709@t-online.de>
Date: Thu, 29 Dec 2011 12:45:52 +0100
From: =?ISO-8859-1?Q?Richard_Sch=FCtz?= <r.schtz@t-online.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111224 Thunderbird/9.0.1
MIME-Version: 1.0
To: Corentin Chary <corentin.chary@gmail.com>
CC: David Herrmann <dh.herrmann@googlemail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Andrzej Prochyra <andrzej@prochyra.name>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Zhang, Rui" <rui.zhang@intel.com>
Subject: Re: [PATCH] Platform: samsung-laptop: add DMI information for Samsung
 N150 Plus
References: <87ty4ss0z4.fsf@prochyra.name> <CAHR064h7a=RQq=p1J+gKpC5_6ow8ChUFFkC39HwtmerHaMksjw@mail.gmail.com> <87ty4qdpna.fsf@prochyra.name> <20111224142028.GA32171@srcf.ucam.org> <CANq1E4S+Sa1BERtR6aNH-ypRo+oJ1fRXkuVa+tREy5qVodv2pw@mail.gmail.com> <CAHR064jyubYf5d_KekB8+wqmGXcm8v4Gg9jVt3W9Kx_Ljh++GA@mail.gmail.com> <CANq1E4T9LtrBgAxhZAcZZc_gN5yuBm0Yn1ukYiWFvH84hKavBA@mail.gmail.com> <4EFC3FA8.6020401@gmail.com>
In-Reply-To: <4EFC3FA8.6020401@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-ID: bHFwbuZrZhHz+6iXlyTFaKeSRZgH2KLjm2jhTSW85e9RxPi83XuNnK5JeuB5pUvQLz
X-TOI-MSGID: ef7e8f9f-6891-42c2-a84b-61cf859c5072
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 29.12.2011 11:23, schrieb Corentin Chary:
> On 12/26/2011 11:22 AM, David Herrmann wrote:
>> On Mon, Dec 26, 2011 at 10:49 AM, Corentin Chary
>> <corentin.chary@gmail.com> wrote:
>>> On Sat, Dec 24, 2011 at 3:28 PM, David Herrmann
>>> <dh.herrmann@googlemail.com> wrote:
>>>> On Sat, Dec 24, 2011 at 3:20 PM, Matthew
>>>> Garrett<mjg59@srcf.ucam.org> wrote:
>>>>> On Sat, Dec 24, 2011 at 02:12:57PM +0000, Andrzej Prochyra wrote:
>>>>>> 'acpi_video0' not functional. Brightness can be controlled through
>>>>>> intel_backlight interface. There are 21 brightness levels and the
>>>>>> backlight can be turned off.
>>>>>
>>>>> If acpi_video0 doesn't work then we either need to work out why
>>>>> it's not
>>>>> working or make it vanish completely, so this patch isn't the correct
>>>>> approach.
>>>>
>>>> Just to make clear, intel_backlight isn't working properly either. If
>>>> my laptop boots with backlight at 50% then intel_backlight will only
>>>> work in the range 0%-50% on my machine. If I use the samsung module to
>>>> set it to 100% then intel_backlight works correctly in the range
>>>> 0-100% until next reboot/suspend.

The same problem exists on my N145 Plus, too.

>>>> So I'd recommend staying with the samsung module and disabling the
>>>> acpi_backlight entirely. The samsung module is the only backlight
>>>> control which works properly.
>>>
>>> Can I take a look at the DSDT to see how it's broken ?
>>> If it's really not functional, then it should be added to the
>>> blacklist in video_detect.c
>>
>> Raw and disassembled dsdt is attached.
>
> Took a quick look but didn't find anything obvious. What happens exactly
> with acpi_video0 ?

Either Samsung's ACPI is totally broken [ACPI Warning: _BQC returned an 
invalid level (20110623/video-472)] or they just don't support backlight 
setting via ACPI at all. Therefore it's implemented in the SABI stuff. 
So every device that needs SABI should be blacklisted in video_detect.

-- 
Regards,
Richard Schütz
