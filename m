Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072Ab0FFGkq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 02:40:46 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45400 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab0FFGkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 02:40:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=MY3co7XEh9BDwODHGQH1kjhJNs8zu+nNJ5sZ61BVoIdCjwdLMdBD6dScEJ1oypjwre
         ldAPyAeFzsETMCAY5MGD+uex1tt8YGm2bmHwimkKqYCSqAF9ALVI3V27zwIKdnHA6w0L
         9t49hrD5N7OqReCo9BtdK+pN0G4pCTO9UNcgk=
Message-ID: <4C0B4300.7060701@gmail.com>
Date: Sat, 05 Jun 2010 23:41:04 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       linux-video@atrey.karlin.mff.cuni.cz
Subject: Re: BUG kmalloc-4096: Poison overwritten
References: <4C0B3C5B.5040703@gmail.com> <4C0B3FDF.6080303@gmail.com>
In-Reply-To: <4C0B3FDF.6080303@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2010 11:27 PM, Jiri Slaby wrote:
> On 06/06/2010 08:12 AM, Justin P. Mattock wrote:
>> =============================================================================
>>
>> [    0.002046] BUG kmalloc-4096: Poison overwritten
>> [    0.002051]
>> -----------------------------------------------------------------------------
>>
>> [    0.002052]
>> [    0.002063] INFO: 0xffff88003ec09e00-0xffff88003ec09e9f. First byte
>> 0x20 instead of 0x6b
>> [    0.002073] INFO: Slab 0xffffea0000dba1c0 objects=7 used=1
>> fp=0xffff88003ec09048 flags=0x40000000000040c3
>> [    0.002082] INFO: Object 0xffff88003ec09048 @offset=4168
>> fp=0xffff88003ec0a090
>> [    0.002083]
>> [    0.002093] Bytes b4 0xffff88003ec09038:  00 00 00 00 00 00 00 00 5a
>> 5a 5a 5a 5a 5a 5a 5a ........ZZZZZZZZ
>> [    0.002114]   Object 0xffff88003ec09048:  6b 6b 6b 6b 6b 6b 6b 6b 6b
>> 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> ...
>> 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>> [    0.002999]   Object 0xffff88003ec09df8:  6b 6b 6b 6b 6b 6b 6b 6b 20
>> 07 20 07 20 07 20 07 kkkkkkkk........
>> [    0.002999]   Object 0xffff88003ec09e08:  20 07 20 07 20 07 20 07 20
>> 07 20 07 20 07 20 07 ................
>> [    0.002999]   Object 0xffff88003ec09e18:  20 07 20 07 20 07 20 07 20
>> 07 20 07 20 07 20 07 ................
>> [    0.002999]   Object 0xffff88003ec09e28:  20 07 20 07 20 07 20 07 20
>> 07 20 07 20 07 20 07 ................
>> [    0.002999]   Object 0xffff88003ec09e38:  20 07 20 07 20 07 20 07 20
>> 07 20 07 20 07 20 07 ................
>> [    0.002999]   Object 0xffff88003ec09e48:  20 07 20 07 20 07 20 07 20
>> 07 20 07 20 07 20 07 ................
>> [    0.002999]   Object 0xffff88003ec09e58:  20 07 20 07 20 07 20 07 20
>> 07 20 07 20 07 20 07 ................
>> [    0.002999]   Object 0xffff88003ec09e68:  20 07 20 07 20 07 20 07 20
>> 07 20 07 20 07 20 07 ................
>> [    0.002999]   Object 0xffff88003ec09e78:  20 07 20 07 20 07 20 07 20
>> 07 20 07 20 07 20 07 ................
>> [    0.002999]   Object 0xffff88003ec09e88:  20 07 20 07 20 07 20 07 20
>> 07 20 07 20 07 20 07 ................
>> [    0.002999]   Object 0xffff88003ec09e98:  20 07 20 07 20 07 20 07 6b
>> 6b 6b 6b 6b 6b 6b 6b ........kkkkkkkk
>> [    0.002999]   Object 0xffff88003ec09ea8:  6b 6b 6b 6b 6b 6b 6b 6b 6b
>
> Just guessing, grey spaces which should go to video ram?
>

not sure if it's grey spaces etc.. one thing I know is this seem's 
reproducible i.g. rebooted 3/4 time's and every boot this showed
up.. I will do a bisect..(keep in mind it's late right now,
and am a bit sauced..will do in the morning)

Justin P. Mattock
