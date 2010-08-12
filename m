Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887Ab0HLVFp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 17:05:45 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37579 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755011Ab0HLVFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 17:05:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=PH0pFnmYMOYXEbqzfb5F23XFBcR7ofqsaJDjdnEbHrrkUVHtVcBPmbDUjb6sTIDOUs
         3F+gfLnZu7rEbKaWsGNS8NLPz96tDIubwyynrX70VIplUjYR1oUG96kXhWsXrtknLLdg
         owgzdKcc/mg5XyGuVSxrtsQDm5MsurhjS7D2k=
Message-ID: <4C646110.1040104@gmail.com>
Date: Thu, 12 Aug 2010 23:01:04 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Pekka Enberg <penberg@kernel.org>, Thomas Meyer <thomas@m3y3r.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.36: Sound stop working
References: <201008122200.05598.thomas@m3y3r.de>	<AANLkTikZ4wA4jJ0AnWMXYmgWVBShRW=Yu67J0QvebRx0@mail.gmail.com> <s5hpqxntw64.wl%tiwai@suse.de>
In-Reply-To: <s5hpqxntw64.wl%tiwai@suse.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2010 10:26 PM, Takashi Iwai wrote:
> At Thu, 12 Aug 2010 23:10:15 +0300,
> Pekka Enberg wrote:
>>
>> On Thu, Aug 12, 2010 at 11:00 PM, Thomas Meyer <thomas@m3y3r.de> wrote:
>>> My sound card stop to work since a few commits. I tried to bisect it and ended up with this:
>>>
>>> There are only 'skip'ped commits left to test.
>>> The first bad commit could be any of:
>>> 3bcf3860a4ff9bbc522820b4b765e65e4deceb3e
>>> c1e5c954020e123d30b4abf4038ce501861bcf9f
>>> We cannot bisect more!
>>>
>>> any ideas what to do now?
>>
>> Takashi, maybe this is related to Linus' problem?
> 
> Yeah, I guess so, since I couldn't see any obvious problem in sound/*.
> 
> PulseAudio uses inotify in udev-detection module, at least.
> It's possible that inotify change may hit the sound in the end.

Probably I got into this problem yesterday. Found out that PA fails to
open /dev/snd/pcmC0D0p _second_ time. It opens it, then closes, then
opens it again and gets EBUSY. aplay is OK.

(If this is the same issue.)

-- 
js
