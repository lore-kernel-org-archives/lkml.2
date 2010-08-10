Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211Ab0HJPgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 11:36:37 -0400
Received: from 70.mail-out.ovh.net ([91.121.185.63]:44114 "HELO
	70.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932070Ab0HJPgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 11:36:33 -0400
Message-ID: <4C6171FC.6060305@example.com>
Date: Tue, 10 Aug 2010 17:36:28 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100620 Icedove/3.0.5
MIME-Version: 1.0
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
CC: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Heinz Diehl <htd@fancy-poultry.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: BUG: scheduling while atomic: swapper/0/0x10000002
References: <20100810142951.GA7156@arch.tripp.de> <4C616DF9.1070309@example.com> <20100810153538.GB5466@swordfish.minsk.epam.com>
In-Reply-To: <20100810153538.GB5466@swordfish.minsk.epam.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 8213721297129664824
X-Ovh-Remote: 95.49.243.143 (afjj143.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.08.2010 17:35, Sergey Senozhatsky wrote:
> On (08/10/10 17:19), Piotr Hosowicz wrote:
>> None of them works for me. I do:
>>
>> cat patch.txt | patch -p1
>>
>> And get:
>>
>> aapi205:/usr/src/linux# cat ../smp-bug.txt | patch -p1
>> patching file include/acpi/platform/aclinux.h
>> Hunk #1 FAILED at 152.
>> 1 out of 1 hunk FAILED -- saving rejects to file
>> include/acpi/platform/aclinux.h.rej
>>
>> Help me please.
>>
>
> Can we see your:
> include/acpi/platform/aclinux.h(.rej)
>
> ?

aapi205:/usr/src/linux# cat include/acpi/platform/aclinux.h.rej
--- include/acpi/platform/aclinux.h
+++ include/acpi/platform/aclinux.h
@@ -152,7 +152,7 @@
  #include <linux/hardirq.h>
  #define ACPI_PREEMPTION_POINT() \
         do { \
-               if (!in_atomic_preempt_off() && !irqs_disabled()) \
+               if (!in_atomic() && !irqs_disabled()) \
                         cond_resched(); \
         } while (0)

> (did you `git pull`?)

No, I just downloaded bz2 patch from kernel.org.

Regards,

Piotr Hosowicz

-- 
Z cyklu "Uroki demokracji", czyli pytania i odpowiedzi w teledurniejach:
- W którym mie¶cie europejskim powsta³a pierwsza opera?
- Sydney.
NP: Peter Green Splinter Group - Heart Of Stone
NB: 2.6.35-git9
