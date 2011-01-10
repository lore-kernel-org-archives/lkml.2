Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135Ab1AJWzR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 17:55:17 -0500
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:3644 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755083Ab1AJWzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 17:55:15 -0500
Message-ID: <4D2B8E50.9030308@gmail.com>
Date: Mon, 10 Jan 2011 23:55:12 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101211 Lanikai/3.1.7
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: eric.dumazet@gmail.com, torvalds@linux-foundation.org,
        alex.arnautu96@gmail.com, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: Kernel 2.6.37-rc5 rc7 Oops
References: <1293652965.7150.13.camel@edumazet-laptop>	<20110110.000650.124002380.davem@davemloft.net>	<4D2B7550.5000008@gmail.com> <20110110.131257.212413498.davem@davemloft.net>
In-Reply-To: <20110110.131257.212413498.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 10 Jan 2011 22:55:12.0940 (UTC) FILETIME=[7077F6C0:01CBB119]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/11 22:12, David Miller wrote:
> From: Gertjan van Wingerde <gwingerde@gmail.com>
> Date: Mon, 10 Jan 2011 22:08:32 +0100
> 
>> On 01/10/11 09:06, David Miller wrote:
>>> From: Eric Dumazet <eric.dumazet@gmail.com>
>>> Date: Wed, 29 Dec 2010 21:02:45 +0100
>>>
>>>> Le mercredi 29 décembre 2010 à 11:23 -0800, Linus Torvalds a écrit :
>>>>> On Wed, Dec 29, 2010 at 4:26 AM, Alex Arnautu <alex.arnautu96@gmail.com> wrote:
>>>>>>
>>>>>> I get an oops with 2.6.37-rc5 and 2.6.37-rc7-git1.
>>>>>> http://www.fotoshack.us/fotos/19044P271210_15.14_[01].jpg
>>>>>
>>>>> Hmm. Davem added to the list of people involved. This _may_ be fixed
>>>>> by the "always clone skbs" commit in -rc8 (commit 173021072), but
>>>>> David can make a better judgment call.
>>>>>
>>>>
>>>> Very unlikely, as commit 173021072 only fix a bug in case mirred is
>>>> used.
>>>
>>> This should be taken to the wireless list (now CC:'d) as the rt2xxx
>>> driver and the wireless stack are both in that backtrace.
>>
>> Hmmm, the jpg images of the oops don't seem to be available anymore
>> (a 404 not found is returned on the URL.
>> Does anybody still have the backtrace? Otherwise it will be very hard to look
>> into this.
> 
> You must have copy-and-paste'd it wrong, the URL works perfectly fine
> for me.
> 
> I also put up a copy at:
> 
> http://vger.kernel.org/~davem/crash.jpg
> 

OK. Got it now. My Unix/Linux twisted mind took the [01] in the file name as a
slick indication that there were two pictures, one with 0 there and one with 1
there. It never occurred to me that it was literally the file name ;-) :-(

Anyway, I wonder if this particular oops is fixed by commit:

20ed3166c84d145589a89d8cde12aa32cf2d17f4 mac80211/rt2x00: add ieee80211_tx_status_ni()

which got into Linus' tree after 2.6.37-rc7 but is part of 2.6.37 final.

It looks a lot like the symptoms that that patch was fixing.

---
Gertjan.
