Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758488Ab0EURdG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 13:33:06 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:39464 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753567Ab0EURdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 13:33:04 -0400
Message-ID: <4BF6C303.7030804@euromail.se>
Date: Fri, 21 May 2010 19:29:39 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Ping Cheng <pinglinux@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Peter Hutterer <peter.hutterer@who-t.net>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Rafi Rubin <rafi@seas.upenn.edu>, Michael Poole <mdpoole@troilus.org>
Subject: Re: [PATCH 2/2] input: mt: Document the MT event slot protocol (rev3)
References: <1274457354-5570-1-git-send-email-rydberg@euromail.se> <AANLkTikBWzgRmso0oQNXcTxeExdKZORXYbIwK9CcMl85@mail.gmail.com> <4BF6B673.1080507@euromail.se> <20100521165218.GA26439@core.coreip.homeip.net> <4BF6BB43.2020405@euromail.se> <20100521172222.GB26439@core.coreip.homeip.net>
In-Reply-To: <20100521172222.GB26439@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OFW2X-00041k-9J.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1OFW2X-00041k-9J 915101c3cd3b9aaca76074ef71fd4041
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> On Fri, May 21, 2010 at 06:56:35PM +0200, Henrik Rydberg wrote:
>> Dmitry Torokhov wrote:
>>> On Friday 21 May 2010 09:36:03 am Henrik Rydberg wrote:
>>>> Ping Cheng wrote:
>>>>> Hi Henrik,
>>>>>
>>>>> Thank you for your quick turnaround. Two minor comments in line.
>>>>>
>>>>> Ping
>>>> Thanks for those, yes, both mistakes. Dmitry, in case you find these last
>>>> versions acceptable, perhaps one could change them manually:
>>>>
>>>> 1. Patch description: s/SYN_MT_SLOT/ABS_SLOT/
>>> Not ABS_MT_SLOT?
>> I wrote an argument for ABS_SLOT in the first patch, in short there is a
>> namespace clash I would like to avoid.
>>
> 
> Hm, I am not sure I follow that argument. While you are saying that slot
> is not an MT event it is certainly not an ST event either. I would even
> say that slot _is_ an MT event since it signals current "slot" or group
> of MT data to userspace. Am I missing something?
> 

It is really a SYN or control event, since it sets which slot is currently being
updated. However, as argued earlier in this thread, since the presence and value
range of the slot variable is needed in user space, converting it to an ABS
event makes sense. But ABS_SLOT is not a property of the slot, and is thus not
an MT event in that respect. Currently, all ABS_MT events are either bypassing
filtering altogether, or (with these patches) being routed via a slot. The
naming convention ABS_MT is the only clue to user space that this is event will
appear once per slot. I think it should remain that way.

Henrik

