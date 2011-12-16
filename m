Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759464Ab1LPONt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 09:13:49 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63896 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab1LPONk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 09:13:40 -0500
Message-ID: <4EEB521A.70602@lwfinger.net>
Date: Fri, 16 Dec 2011 08:13:46 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Arend van Spriel <arend@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Linville <linville@tuxdriver.com>
Subject: Re: unexpected taint message
References: <4EEB0EFC.5000302@broadcom.com>  (sfid-20111216_102800_182196_AFD2D6CF) <1324038636.3429.1.camel@jlt3.sipsolutions.net>  <4EEB4D61.80602@lwfinger.net> (sfid-20111216_145414_221850_EED1E4DE) <1324043939.3429.2.camel@jlt3.sipsolutions.net>
In-Reply-To: <1324043939.3429.2.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2011 07:58 AM, Johannes Berg wrote:
> On Fri, 2011-12-16 at 07:53 -0600, Larry Finger wrote:
>> On 12/16/2011 06:30 AM, Johannes Berg wrote:
>>> On Fri, 2011-12-16 at 10:27 +0100, Arend van Spriel wrote:
>>>> To whoever may know,
>>>>
>>>> Upon loading our driver module I get the following message:
>>>>
>>>> kernel: [  344.805106] Disabling lock debugging due to kernel taint
>>>>
>>>> What exactly are the criteria for tainting? Our driver locking strategy
>>>> is something we want to refactor and having lock debugging during that
>>>> transition may be a life safer.
>>>
>>> cat /proc/sys/kernel/tainted
>>
>> Please note that Documentation/sysctl/kernel.txt is missing the explanation for
>> two bits in the value printed:
>>
>> 2048 - The system is working around a severe firmware bug.
>> 4096 - An out-of-tree module has been loaded.
>>
>> On my system, bit 4096 is set due to loading the VirtualBox module, which
>> disables lock debugging lock debugging. I suspect that loading VMware would
>> cause the same condition.
>
> Hmm. I wish OOT didn't disable lockdep, we do a lot of development with
> modules OOT because the turnaround is faster/easier (for not so
> experienced developers). Worst case we can patch it out of the base
> kernel I guess...

Me too. Now I understand John's patch entitled "[RFC] modpost: add option to 
allow external modules to avoid taint". I doubt that it will be allowed 
upstream, but I think that I will add it as a local commit.

I had failed to notice that the VB module was disabling lock checking, and I 
ACKed a patch to rtlwifi that triggers a nested lock WARNING. Oh well, at least 
the bug was not released into the wild yet.

Larry
