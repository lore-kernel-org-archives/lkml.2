Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760652Ab0HLVTX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 17:19:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57192 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752441Ab0HLVTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 17:19:22 -0400
MIME-Version: 1.0
In-Reply-To: <4C646110.1040104@gmail.com>
References: <201008122200.05598.thomas@m3y3r.de> <AANLkTikZ4wA4jJ0AnWMXYmgWVBShRW=Yu67J0QvebRx0@mail.gmail.com>
 <s5hpqxntw64.wl%tiwai@suse.de> <4C646110.1040104@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 Aug 2010 14:18:54 -0700
Message-ID: <AANLkTi=-2U3PXeUEXzGDdXti_j5yGbfG3yci909MKEHX@mail.gmail.com>
Subject: Re: 2.6.36: Sound stop working
To: Jiri Slaby <jirislaby@gmail.com>, Eric Paris <eparis@redhat.com>
Cc: Takashi Iwai <tiwai@suse.de>, Pekka Enberg <penberg@kernel.org>,
        Thomas Meyer <thomas@m3y3r.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric needs to be cc'd.. Sorry for the extra quoting.

                      Linus
---
On Thu, Aug 12, 2010 at 2:01 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 08/12/2010 10:26 PM, Takashi Iwai wrote:
>> At Thu, 12 Aug 2010 23:10:15 +0300,
>> Pekka Enberg wrote:
>>>
>>> On Thu, Aug 12, 2010 at 11:00 PM, Thomas Meyer <thomas@m3y3r.de> wrote:
>>>> My sound card stop to work since a few commits. I tried to bisect it and ended up with this:
>>>>
>>>> There are only 'skip'ped commits left to test.
>>>> The first bad commit could be any of:
>>>> 3bcf3860a4ff9bbc522820b4b765e65e4deceb3e
>>>> c1e5c954020e123d30b4abf4038ce501861bcf9f
>>>> We cannot bisect more!
>>>>
>>>> any ideas what to do now?
>>>
>>> Takashi, maybe this is related to Linus' problem?
>>
>> Yeah, I guess so, since I couldn't see any obvious problem in sound/*.
>>
>> PulseAudio uses inotify in udev-detection module, at least.
>> It's possible that inotify change may hit the sound in the end.
>
> Probably I got into this problem yesterday. Found out that PA fails to
> open /dev/snd/pcmC0D0p _second_ time. It opens it, then closes, then
> opens it again and gets EBUSY. aplay is OK.
>
> (If this is the same issue.)
>
> --
> js
>
