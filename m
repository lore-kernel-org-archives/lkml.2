Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab2KCKq1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 06:46:27 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:47555 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524Ab2KCKq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 06:46:26 -0400
Message-ID: <5094F5C5.1000000@ahsoftware.de>
Date: Sat, 03 Nov 2012 11:45:25 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Subject: Re: AMD A10: MCE Instruction Cache Error
References: <5093A592.9070605@ahsoftware.de> <5093D069.20901@ahsoftware.de> <20121103044929.GB21829@liondog.tnic>
In-Reply-To: <20121103044929.GB21829@liondog.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 03.11.2012 05:49, schrieb Borislav Petkov:
> On Fri, Nov 02, 2012 at 02:53:45PM +0100, Alexander Holler wrote:
>> Am 02.11.2012 11:50, schrieb Alexander Holler:
>>> Hello,
>>>
>>> I've just got the following on an AMD A10 5800K:
>>>
>>> ------
>>> [ 8395.999581] [Hardware Error]: CPU:0
>>> MC1_STATUS[-|CE|MiscV|-|AddrV|-|-]: 0x8c00002000010151
>>> [ 8395.999586] [Hardware Error]:        MC1_ADDR: 0x0000ffffa00e1203
>>> [ 8395.999588] [Hardware Error]: Instruction Cache Error: Parity error
>>> during data load from IC.
>>> [ 8395.999590] [Hardware Error]: cache level: L1, tx: INSN, mem-tx: IRD
>>> ------
>>>
>>> Kernel is 3.6.5, MB is an Asus F2A85-M with BIOS 5103 (the latest).
>>>
...
>> So now I have two question:
>>
>> - First, if the error is something I should ask AMD about,
>
> Not really, it is a single bit flip which got corrected, simply watch
> out if you get more of those.
>
>> - Second, if the kernel could mention that it is an recoverable
>> error. And if so and if such errors aren't something to get panic
>> (e.g. it isn't unusual to receive such), if the kernel could output
>> that message with another priority.
>
> As I said above, it got corrected. If it were critical, it would've
> either panicked or you wouldnt've seen it at all (probably only after
> reboot).

Hmm, exactly that just happened twice in a row. Unfortunately the screen 
was already disabled (screen saving mode), so I couldn't see any 
message, if there was any. Just a dead box (not overclocked, I don't do 
such, I even had enabled the power saving mode in the BIOS, which seems 
to mean max. 3800 MHz). I think I should start getting nervous. :(

What I meant with another priority is using something else than 
pr_emerg(), because pr_emerge() causes the message to become displayed 
on every console, at least on my F17 with default settings.

Of course, I'm happy it was displayed using pr_emerg() so I haven't 
missed it. Now I know that even if ECC isn't available for users which 
don't want or need power hungry and loud servers, at least some parity 
is used to verify the operations with the internal memory (cache).

But on the other way, if that message isn't really critical, something 
else than pr_emerge() should be used.

Thanks for the answer.

Regards,

Alexander

