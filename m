Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab2IFHIe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 03:08:34 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35181 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab2IFHId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 03:08:33 -0400
Message-ID: <50484BEB.4020103@gmail.com>
Date: Thu, 06 Sep 2012 09:08:27 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Markus Trippelsdorf <markus@trippelsdorf.de>
CC: Takashi Iwai <tiwai@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Subject: Re: snd-usb: "delay: estimated 0, actual 352"
References: <s5hmx1526mg.wl%tiwai@suse.de> <20120906060220.GA252@x4> <504843BA.2040808@gmail.com> <s5hehmfir46.wl%tiwai@suse.de> <20120906065340.GA257@x4>
In-Reply-To: <20120906065340.GA257@x4>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.09.2012 08:53, Markus Trippelsdorf wrote:
> On 2012.09.06 at 08:48 +0200, Takashi Iwai wrote:
>> At Thu, 06 Sep 2012 08:33:30 +0200,
>> Daniel Mack wrote:
>>>
>>> On 06.09.2012 08:02, Markus Trippelsdorf wrote:
>>>> On 2012.09.04 at 16:40 +0200, Takashi Iwai wrote:
>>>>> ----------------------------------------------------------------
>>>>> Sound fixes for 3.6-rc5
>>>>>
>>>>> There are nothing scaring, contains only small fixes for HD-audio and
>>>>> USB-audio:
>>>>> - EPSS regression fix and GPIO fix for HD-audio IDT codecs
>>>>> - A series of USB-audio regression fixes that are found since 3.5 kernel
>>>>>
>>>>> ----------------------------------------------------------------
>>>>> Daniel Mack (4):
>>>>>       ALSA: snd-usb: Fix URB cancellation at stream start
>>>>>       ALSA: snd-usb: restore delay information
>>>>         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ 
>>>> The commit fbcfbf5f above causes the following lines to be printed
>>>> whenever I start a new song:
>>>
>>> Copied Pierre-Louis Bossart - he wrote the code in 294c4fb8 which this
>>> patch (fbcfbf5f) brings back now.
>>>
>>>> delay: estimated 0, actual 352
>>>> delay: estimated 353, actual 705
>>>>
>>>> (44.1 * 8 = 352.8)
>>>>
>>>> This happens with an USB-DAC that identifies itself as "C-Media USB
>>>> Headphone Set".
>>>
>>> And you didn't you see these lines with 3.4?
>>
>> Maybe the difference of start condition?
>>
>> Markus, does the patch below fix anything?
> 
> Unfortunately no.
> However reverting the following fixes the problem:
> 
> commit 245baf983cc39524cce39c24d01b276e6e653c9e
> Author: Daniel Mack <zonque@gmail.com>
> Date:   Thu Aug 30 18:52:30 2012 +0200
> 
>     ALSA: snd-usb: fix calls to next_packet_size
> 

No, this one certainly fixes a problem and does the right thing by
restoring the original code.

If you wouldn't state that you didn't see the same effect with 3.4(!),
before the refactoring done in 3.5, I would believe the device is simply
slightly off in its feedback rate and the tighter delay code complains
about it while compensating, just as it did before.

Are there any more than these two lines? And is audio working at all? Is
it distorted in any way?

Pierre-Louis, could you check whether I did the right thing when I
ported over your delay bits to the new endpoint logic? Maybe I'm missing
something here, but I currently don't see it.


Thanks,
Daniel

