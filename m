Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab0GDFIy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 01:08:54 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35026 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab0GDFIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 01:08:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=VeYiDUZ2SlziH+YFjYrVBfVvW5hV5Tiu/hHidg1PBmvTQTRt4hHpIQZp0b3/jxjZBq
         S6vQlpZI5hR2en62PfczZbBESjOdsEXfF+teMojAwfyC6N12YD1CLbdqOnI+zEGguJLW
         +SFlR7qGSfbuXjfQTwk4kfxn9lp7JU3EFfAY0=
Message-ID: <4C301782.9080306@gmail.com>
Date: Sat, 03 Jul 2010 22:09:22 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Jacek Poplawski <jacekpoplawski@gmail.com>
CC: Ondrej Zary <linux@rainbow-software.org>, linux-kernel@vger.kernel.org
Subject: Re: SH-D163C
References: <AANLkTinZfXXALWmmVPMHe-iJehQif7KC4tQCDdGge6g4@mail.gmail.com>	<201007032302.41796.linux@rainbow-software.org>	<AANLkTiki_vUhyJzVW1ywwlFKnllpP05nGRkjYtlUaMDP@mail.gmail.com>	<4C2FD0B5.3020004@gmail.com> <AANLkTik0hjeYmOvO4hzDqfezN5vCRVw3qHSrxc1R93pz@mail.gmail.com>
In-Reply-To: <AANLkTik0hjeYmOvO4hzDqfezN5vCRVw3qHSrxc1R93pz@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2010 07:46 PM, Jacek Poplawski wrote:
> On Sun, Jul 4, 2010 at 2:07 AM, Justin P. Mattock
> <justinmattock@gmail.com>  wrote:
>>>> The problem is that it really is a DVD-ROM:
>>>> http://www.google.com/search?q=%22SH-D163C%22+site%3Asamsung.com
>>>
>>> You are right, now I understand why it was so cheap :) Sorry :)
>>
>> so creating a patch is not worth it then!?.. was hoping you did..
>
> It works as a DVD reader without problems, I was just wondering why I
> can't burn anything :)
> Sorry again.
>

no reason to say sorry.. as for not burning tough to say, could be 
software cdio, dvdrw-tools, etc... but then again could be kernel. heres 
what I came up with(keep in mind mind could be totally wrong)

_totally_ _un-tested_



 From b95d7b285344300b850112eb2777611fb8bae248 Mon Sep 17 00:00:00 2001
From: Justin P. Mattock <justinmattock@gmail.com>
Date: Sat, 3 Jul 2010 11:23:19 -0700
Subject: [PATCH] SH-D163C

  Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
  drivers/ata/libata-core.c |    1 +
  drivers/ide/ide-iops.c    |    1 +
  2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index ddf8e48..22c99f2 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4304,6 +4304,7 @@ static const struct ata_blacklist_entry 
ata_device_blacklist [] = {
         { "QUANTUM FIREBALLlct10 05", "A03.0900", ATA_HORKAGE_IVB, },
         /* Maybe we should just blacklist TSSTcorp... */
         { "TSSTcorp CDDVDW SH-S202H", "SB00",     ATA_HORKAGE_IVB, },
+       { "TSSTcorp CDDVDW SH-D163C", "SB00",     ATA_HORKAGE_IVB, },
         { "TSSTcorp CDDVDW SH-S202H", "SB01",     ATA_HORKAGE_IVB, },
         { "TSSTcorp CDDVDW SH-S202J", "SB00",     ATA_HORKAGE_IVB, },
         { "TSSTcorp CDDVDW SH-S202J", "SB01",     ATA_HORKAGE_IVB, },
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index 376f2dc..70a6bd6 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -212,6 +212,7 @@ static const struct drive_list_entry ivb_list[] = {
         { "QUANTUM FIREBALLlct10 05"    , "A03.0900"    },
         { "QUANTUM FIREBALLlct20 30"    , "APL.0900"    },
         { "TSSTcorp CDDVDW SH-S202J"    , "SB00"        },
+       { "TSSTcorp CDDVDW SH-D163C"    , "SB00"        },
         { "TSSTcorp CDDVDW SH-S202J"    , "SB01"        },
         { "TSSTcorp CDDVDW SH-S202N"    , "SB00"        },
         { "TSSTcorp CDDVDW SH-S202N"    , "SB01"        },
-- 
1.6.5.2.180.gc5b3e


keep in mind something might need to be added, and/or this is totally 
wrong and the kernel already supports your device, and your hitting 
something with userpspace etc..

hope this gets you up and running..

Justin P. Mattock
