Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab0DEDmz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 23:42:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:1879 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754113Ab0DEDmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 23:42:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,364,1267430400"; 
   d="scan'208";a="610207286"
Message-ID: <4BB95C33.1050706@linux.intel.com>
Date: Sun, 04 Apr 2010 20:42:43 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dominik Brodowski <linux@dominikbrodowski.net>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Adam Belay <abelay@novell.com>, Len Brown <len.brown@intel.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: A few questions and issues with dynticks, NOHZ and powertop
References: <20100403223328.GA4507@comet.dominikbrodowski.net> <20100403235326.GA23445@core.coreip.homeip.net> <20100404104708.GA5922@comet.dominikbrodowski.net>
In-Reply-To: <20100404104708.GA5922@comet.dominikbrodowski.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/4/2010 3:47, Dominik Brodowski wrote:
> Hey,
>
> On Sat, Apr 03, 2010 at 04:53:26PM -0700, Dmitry Torokhov wrote:
>> On Sun, Apr 04, 2010 at 12:33:28AM +0200, Dominik Brodowski wrote:
>>>
>>> 4) SynPS/2 touchpad:
>>> Why does moving the touchpad lead to sooo many IRQs? I can't look as fast
>>> as the mouse pointer seems to get new data:
>>>    62,5% (473,1)<interrupt>  : PS/2 keyboard/mouse/touchpad
>>>
>>
>> 80 pps @ 6 bytes/packet = 480 interrupts/sec.
>>
>> You can try using psmouse.rate=40 to limit it to 40 pps which should
>> bring it to the rate of standard PS/2 mouse at the expense of
>> sensitivity...
>
> as a sidenote: if we know -- like here -- that the next IRQ will be issued
> soon, in approximately 1.75 ms (well, at least on my system), might it make
> sense to make tick_nohz_get_sleep_length() smarter to know about this?

yes and no.

if you are very sure (95%+ or so) then absolutely it needs to know about this
so that the C state selection code can make a better decision.
Right now it tries to look at history to guess this delay.

Unfortunately we do not currently have such a concept in the code to make this
work... but it'd be really nice to have.
