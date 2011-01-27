Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab1A0UpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 15:45:08 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:33556 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753330Ab1A0UpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 15:45:06 -0500
Message-ID: <4D41D963.6020509@bluewatersys.com>
Date: Fri, 28 Jan 2011 09:45:23 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mandeep Singh Baines <msb@chromium.org>
CC: Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>, olofj@chromium.org
Subject: Re: [PATCH] printk: allow setting DEFAULT_MESSAGE_LEVEL via Kconfig
References: <20110125235700.GR8008@google.com> <20110126144910.ce0646ec.akpm@linux-foundation.org> <20110126145703.a0f5add5.rdunlap@xenotime.net> <20110126151017.ed9e627c.akpm@linux-foundation.org> <20110127082718.GA4748@p183.telecom.by> <20110127155754.GB8520@google.com>
In-Reply-To: <20110127155754.GB8520@google.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2011 04:57 AM, Mandeep Singh Baines wrote:
> Alexey Dobriyan (adobriyan@gmail.com) wrote:
>> On Wed, Jan 26, 2011 at 03:10:17PM -0800, Andrew Morton wrote:
>>> On Wed, 26 Jan 2011 14:57:03 -0800
>>> Randy Dunlap <rdunlap@xenotime.net> wrote:
>>>
>>>>> I'm a bit surprised that this wasn't already tunable at boot-time
>>>>> and/or at runtime.
>>>>
>>>>
>>>> As WANG Cong replied:
>>>>
>>>> Why? We already have "loglevel=" kernel parameter.
>>>
>>> That's different.
>>>
>>> Mandeep's patch addresses printks which didn't have a facility level. 
>>
>> For those, we have ignore_loglevel kernel parameter.
> 
> That's a little different. ignore_loglevel will print ALL kernel messages
> to the console. What we would like to do is look at all messages that
> are KERN_WARNING (and higher in priority) very closely. Bugs lie there;)
> Problem is that DEFAULT_MESSAGE_LEVEL is KERN_WARNING so there is too
> much noise at KERN_WARNING. So we'd like to be able to set
> DEFAULT_MESSAGE_LEVEL (default_message_loglevel) to something lower in,
> priority, at boot or earlier. You can set it via /proc/sys/kernel/printk
> (takes an int_vec) but that's too late. A ton of stuff has already been
> logged by the time we're able to change a sysctl.

Why not make printk prefix messages that have no log level with
"[NO_LOG_LEVEL]" or similar? That way the can easily be grepped out, and
it provides and incentive for people to fix them :-).

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
