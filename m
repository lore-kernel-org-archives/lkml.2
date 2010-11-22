Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558Ab0KVV6k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 16:58:40 -0500
Received: from mx0.vr-web.de ([195.200.35.198]:37161 "EHLO mx0.vr-web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757110Ab0KVV6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 16:58:39 -0500
From: Andreas Hartmann <andihartmann@01019freenet.de>
X-Newsgroups: linux.kernel
Subject: Re: missing 700 MB of RAM
Date: Mon, 22 Nov 2010 22:58:44 +0100
Organization: privat
Message-ID: <icep09$2hd$1@ID-44327.news.uni-berlin.de>
References: <fRnsu-1X9-15@gated-at.bofh.it> <fRrcJ-8j1-3@gated-at.bofh.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.15) Gecko/20101026 SUSE/2.0.10-1.1 SeaMonkey/2.0.10
In-Reply-To: <fRrcJ-8j1-3@gated-at.bofh.it>
To: linux-kernel@vger.kernel.org
X-BitDefender-Scanner: Clean, Agent: BitDefender Courier 3.0.2 on
 vrwf203, sigver: 7.28621
X-BitDefender-CF-Stamp: none
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> On 11/21/2010 08:02 PM, Andreas Hartmann wrote:
>> I've got 8 GB RAM installed, but linux reports 7,3 GB. Where is the
>> missing RAM (700 MB)?
> ...
>> The motherboard is a GA-MA78GM-S2H (64bit, AMD) with a on board Radeon
>> HD 3200 VGA card. The card uses 256 MB of RAM - so 444 MB of RAM are
>> missing. Where are they gone?
> 
> Hi, ask your BIOS:
> 
>> BIOS-provided physical RAM map:
>> BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
>> BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
>> BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
>> BIOS-e820: 0000000000100000 - 00000000afde0000 (usable)
>> BIOS-e820: 00000000afde0000 - 00000000afde3000 (ACPI NVS)
>> BIOS-e820: 00000000afde3000 - 00000000afdf0000 (ACPI data)
>> BIOS-e820: 00000000afdf0000 - 00000000afe00000 (reserved)
>> BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
>> BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
>> BIOS-e820: 0000000100000000 - 0000000230000000 (usable)
> 
> It reports 7677M of usable mem. Or maybe your loader is cheating on you?
> I doubt so...

Ok. That's right. Anyway, I'm wondering about the difference to free:

            total       used       free     shared    buffers     cached
Mem:      7706580    5271096    2435484          0      79232    3049120

which is 7526M. This means, there are missing 151M of usable RAM?!

I would have expected, that free reprots the same amount as the kernel
reports to be usable.

On the other hand, I would have expected, that the amount, reported by
free + gfx-memory should nearly be 8 GB. Here it is: 7782. Thus there
are missing 410 MB between the installed hardware and free + gfx-memory.

Does anybody kown, where to find them?


Removing the difference between free and physical ram map (410 - 151),
~259 MB are remaing. This is nearly the amount for the gfx-card, which
has already been removed. Could it be, that the gfx-memory is reserved
twice - once by the bios and another time by the kernel?!


Kind regards,
Andreas
