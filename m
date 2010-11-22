Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325Ab0KVWhy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 17:37:54 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46132 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932281Ab0KVWhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 17:37:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=gqDEI7DfGLOJb5ns8dvwXnjBlMnx9hZCWMYupJVZoZKNT9Qvc6YJ7DI9qsVlEJ9Y7R
         NU1DbEtXKg+YY3o9ml9NRSXP7F6jtjZKU+gJzXQBcdgbSwNemdQVUvD4V/Bm7Pplqu9r
         Hu0jOshLQTF/+Xf07kIoyvseoZcK35ur0I1jg=
Message-ID: <4CEAF0B9.5020401@gmail.com>
Date: Mon, 22 Nov 2010 23:37:45 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: Andreas Hartmann <andihartmann@01019freenet.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: missing 700 MB of RAM
References: <fRnsu-1X9-15@gated-at.bofh.it> <fRrcJ-8j1-3@gated-at.bofh.it> <icep09$2hd$1@ID-44327.news.uni-berlin.de>
In-Reply-To: <icep09$2hd$1@ID-44327.news.uni-berlin.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You should reply-to-all.

On 11/22/2010 10:58 PM, Andreas Hartmann wrote:
> Jiri Slaby wrote:
>> On 11/21/2010 08:02 PM, Andreas Hartmann wrote:
>>> I've got 8 GB RAM installed, but linux reports 7,3 GB. Where is the
>>> missing RAM (700 MB)?
>> ...
>>> The motherboard is a GA-MA78GM-S2H (64bit, AMD) with a on board Radeon
>>> HD 3200 VGA card. The card uses 256 MB of RAM - so 444 MB of RAM are
>>> missing. Where are they gone?
>>
>> Hi, ask your BIOS:
>>
>>> BIOS-provided physical RAM map:
>>> BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
>>> BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
>>> BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
>>> BIOS-e820: 0000000000100000 - 00000000afde0000 (usable)
>>> BIOS-e820: 00000000afde0000 - 00000000afde3000 (ACPI NVS)
>>> BIOS-e820: 00000000afde3000 - 00000000afdf0000 (ACPI data)
>>> BIOS-e820: 00000000afdf0000 - 00000000afe00000 (reserved)
>>> BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
>>> BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
>>> BIOS-e820: 0000000100000000 - 0000000230000000 (usable)
>>
>> It reports 7677M of usable mem. Or maybe your loader is cheating on you?
>> I doubt so...
> 
> Ok. That's right. Anyway, I'm wondering about the difference to free:
> 
>             total       used       free     shared    buffers     cached
> Mem:      7706580    5271096    2435484          0      79232    3049120
> 
> which is 7526M. This means, there are missing 151M of usable RAM?!

Yes, and if you look into dmesg, you will see:
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 32 MB of RAM
Mapping aperture over 32768 KB of RAM @ 20000000

Then there is some kernel code+data (11M), mem_map (108M) etc.
7677-108-32-11=7526

> I would have expected, that free reprots the same amount as the kernel
> reports to be usable.
> 
> On the other hand, I would have expected, that the amount, reported by
> free + gfx-memory should nearly be 8 GB. Here it is: 7782. Thus there
> are missing 410 MB between the installed hardware and free + gfx-memory.

Since the BIOS is not reporting the memory, kernel can do only a little
about that.

> Removing the difference between free and physical ram map (410 - 151),
> ~259 MB are remaing. This is nearly the amount for the gfx-card, which
> has already been removed. Could it be, that the gfx-memory is reserved
> twice - once by the bios and another time by the kernel?!

I don't understand where you got the numbers...

regards,
-- 
js
