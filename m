Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933809Ab0HLUUr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 16:20:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37455 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760530Ab0HLUUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 16:20:45 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTikZ4wA4jJ0AnWMXYmgWVBShRW=Yu67J0QvebRx0@mail.gmail.com>
References: <201008122200.05598.thomas@m3y3r.de> <AANLkTikZ4wA4jJ0AnWMXYmgWVBShRW=Yu67J0QvebRx0@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 Aug 2010 13:20:17 -0700
Message-ID: <AANLkTi=Sh=4mmV2B_VsQw-1+jHzf2jWZsYQkJmqWwms+@mail.gmail.com>
Subject: Re: 2.6.36: Sound stop working
To: Pekka Enberg <penberg@kernel.org>, Eric Paris <eparis@redhat.com>
Cc: Thomas Meyer <thomas@m3y3r.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 1:10 PM, Pekka Enberg <penberg@kernel.org> wrote:
> On Thu, Aug 12, 2010 at 11:00 PM, Thomas Meyer <thomas@m3y3r.de> wrote:
>> My sound card stop to work since a few commits. I tried to bisect it and ended up with this:
>>
>> There are only 'skip'ped commits left to test.
>> The first bad commit could be any of:
>> 3bcf3860a4ff9bbc522820b4b765e65e4deceb3e
>> c1e5c954020e123d30b4abf4038ce501861bcf9f
>> We cannot bisect more!
>>
>> any ideas what to do now?
>
> Takashi, maybe this is related to Linus' problem?

Yes, I'm 99% sure it is. I haven't bisected my problem all the way,
but I've bisected away all the sound changes (and as mentioned, doing
a 'cat' to /dev/audio works). And yes, the fanotify changes are right
in the middle of my bisect.

So I suspect it's not sound that is broken at all, but pulseaudio that
got broken by the fanotify changes.

Eric - over to you.

                               Linus
