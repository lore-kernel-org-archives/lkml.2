Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab2D3Glu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 02:41:50 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:12148 "EHLO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab2D3Glt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 02:41:49 -0400
Message-ID: <4F9E3393.2020805@snapgear.com>
Date: Mon, 30 Apr 2012 16:39:15 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roland McGrath <roland@hack.frob.com>, Greg Ungerer <gerg@uclinux.org>
Subject: Re: [RFC] TIF_NOTIFY_RESUME, arch/*/*/*signal*.c and all such
References: <CA+55aFzuTspDyyLaOA-g-dTWydaUeeWo9uVGR+rZ=ZJzPW_Ocw@mail.gmail.com> <20120420180748.GI6871@ZenIV.linux.org.uk> <20120423180150.GA6871@ZenIV.linux.org.uk> <20120424072617.GB6871@ZenIV.linux.org.uk> <20120426183742.GA324@redhat.com> <20120426231942.GJ6871@ZenIV.linux.org.uk> <20120427172444.GA30267@redhat.com> <20120427184528.GL6871@ZenIV.linux.org.uk> <CAMuHMdXTR1ug3sOyJ_PA0Yub2GsO5NCdAd71EX0Y9osq1ei5KQ@mail.gmail.com> <20120427193413.GM6871@ZenIV.linux.org.uk> <20120429225100.GB6871@ZenIV.linux.org.uk>
In-Reply-To: <20120429225100.GB6871@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/04/12 08:51, Al Viro wrote:
> On Fri, Apr 27, 2012 at 08:34:13PM +0100, Al Viro wrote:
>> On Fri, Apr 27, 2012 at 09:14:53PM +0200, Geert Uytterhoeven wrote:
>>> On Fri, Apr 27, 2012 at 20:45, Al Viro<viro@zeniv.linux.org.uk>  wrote:
>>>>> The only comment I have,
>>>>> 38671a3e831ed7327affb24d715f98bb99c80e56 m68k: add TIF_NOTIFY_RESUME and handle it
>>>>> forgets to unexport do_signal().
>>>>
>>>> Meh... ??The thing is, there are _two_ of them. ??signal_mm.c and signal_no.c
>>>> badly need merging, with common stuff moved to signal.c. ??I really hate
>>>
>>> Greg recently posted a patch to merge them:
>>> http://www.spinics.net/lists/linux-m68k/msg04995.html
>>
>> Nice...  BTW, could you comment on
>>      m68k: don't open-code block_sigmask()
>>      m68k: use set_current_blocked in sigreturn/rt_sigreturn
>>      m68k-nommu: do_signal() is only called when returning to user mode
>>      m68k: add TIF_NOTIFY_RESUME and handle it.
>> in signal.git tree?  The last one is really interesting...
>>
>> Just pick the current tree - one that was there yesterday had a dumb typo
>> in thread_info.h part, so it wouldn't even compile (TIF_NOTIFE_RESUME
>> defined instead of TIF_NOTIFY_RESUME ;-/)
>
> BTW, Greg's patch put into the queue in the very beginning, everything rebased
> on top of it.

Those changes currently sitting in your signal tree look ok to me.

Acked-by: Greg Ungerer <gerg@uclinux.org>

Regards
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
