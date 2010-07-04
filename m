Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab0GDFjJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 01:39:09 -0400
Received: from troy.hostgo.com ([64.62.143.130]:58479 "EHLO troy.hostgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888Ab0GDFjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 01:39:07 -0400
From: Thomas Fjellstrom <tfjellstrom@strangesoft.net>
To: linux-kernel@vger.kernel.org
Subject: Re: SH-D163C
Date: Sat, 3 Jul 2010 23:38:56 -0600
User-Agent: KMail/1.13.3 (Linux/2.6.34-0.dmz.10-liquorix-amd64; KDE/4.4.4; x86_64; ; )
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
       Jacek Poplawski <jacekpoplawski@gmail.com>,
       Ondrej Zary <linux@rainbow-software.org>
References: <AANLkTinZfXXALWmmVPMHe-iJehQif7KC4tQCDdGge6g4@mail.gmail.com> <AANLkTik0hjeYmOvO4hzDqfezN5vCRVw3qHSrxc1R93pz@mail.gmail.com> <4C301782.9080306@gmail.com>
In-Reply-To: <4C301782.9080306@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007032338.57331.tfjellstrom@strangesoft.net>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - troy.hostgo.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - strangesoft.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On July 3, 2010, Justin P. Mattock wrote:
> On 07/03/2010 07:46 PM, Jacek Poplawski wrote:
> > On Sun, Jul 4, 2010 at 2:07 AM, Justin P. Mattock
> > 
> > <justinmattock@gmail.com>  wrote:
> >>>> The problem is that it really is a DVD-ROM:
> >>>> http://www.google.com/search?q=%22SH-D163C%22+site%3Asamsung.com
> >>> 
> >>> You are right, now I understand why it was so cheap :) Sorry :)
> >> 
> >> so creating a patch is not worth it then!?.. was hoping you did..
> > 
> > It works as a DVD reader without problems, I was just wondering why I
> > can't burn anything :)
> > Sorry again.
> 
> no reason to say sorry.. as for not burning tough to say, could be
> software cdio, dvdrw-tools, etc... but then again could be kernel. heres
> what I came up with(keep in mind mind could be totally wrong)

Apparently the drive in question isn't a DVDR/DVDRW. Just a plain old 
DVDROM.

> _totally_ _un-tested_
> 
> 
> 
>  From b95d7b285344300b850112eb2777611fb8bae248 Mon Sep 17 00:00:00 2001
> From: Justin P. Mattock <justinmattock@gmail.com>
> Date: Sat, 3 Jul 2010 11:23:19 -0700
> Subject: [PATCH] SH-D163C
> 
>   Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> ---
>   drivers/ata/libata-core.c |    1 +
>   drivers/ide/ide-iops.c    |    1 +
>   2 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index ddf8e48..22c99f2 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -4304,6 +4304,7 @@ static const struct ata_blacklist_entry
> ata_device_blacklist [] = {
>          { "QUANTUM FIREBALLlct10 05", "A03.0900", ATA_HORKAGE_IVB, },
>          /* Maybe we should just blacklist TSSTcorp... */
>          { "TSSTcorp CDDVDW SH-S202H", "SB00",     ATA_HORKAGE_IVB, },
> +       { "TSSTcorp CDDVDW SH-D163C", "SB00",     ATA_HORKAGE_IVB, },
>          { "TSSTcorp CDDVDW SH-S202H", "SB01",     ATA_HORKAGE_IVB, },
>          { "TSSTcorp CDDVDW SH-S202J", "SB00",     ATA_HORKAGE_IVB, },
>          { "TSSTcorp CDDVDW SH-S202J", "SB01",     ATA_HORKAGE_IVB, },
> diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
> index 376f2dc..70a6bd6 100644
> --- a/drivers/ide/ide-iops.c
> +++ b/drivers/ide/ide-iops.c
> @@ -212,6 +212,7 @@ static const struct drive_list_entry ivb_list[] = {
>          { "QUANTUM FIREBALLlct10 05"    , "A03.0900"    },
>          { "QUANTUM FIREBALLlct20 30"    , "APL.0900"    },
>          { "TSSTcorp CDDVDW SH-S202J"    , "SB00"        },
> +       { "TSSTcorp CDDVDW SH-D163C"    , "SB00"        },
>          { "TSSTcorp CDDVDW SH-S202J"    , "SB01"        },
>          { "TSSTcorp CDDVDW SH-S202N"    , "SB00"        },
>          { "TSSTcorp CDDVDW SH-S202N"    , "SB01"        },


-- 
Thomas Fjellstrom
tfjellstrom@strangesoft.net
