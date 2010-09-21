Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab0IULVY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 07:21:24 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:59321 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab0IULVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 07:21:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] oprofile: Add Support for Intel CPU Family 6 / Model 29
Date: Tue, 21 Sep 2010 13:21:05 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: robert.richter@amd.com, linux-kernel@vger.kernel.org,
        oprofile-list@lists.sourceforge.net, tdm.rhbz@gmail.com
References: <1285053995-3811-1-git-send-email-jolsa@redhat.com>
In-Reply-To: <1285053995-3811-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009211321.06172.arnd@arndb.de>
X-Provags-ID: V02:K0:cV9UAbb2KG4uisujLZt8xt0ZHU4We3Dpo4+kDcarEEl
 1wcclZbrcUKvYOcDS6YtQE1F2tZL3nEAhnJHSkFee1VgLIWbCR
 RNNsbRQgai5lEiGaox5Ua/ZWtYssGhsXV6tIHgjXM5TrdNalUs
 Wp/Gn65zpH3xPTpeqDHDrGb9W2agMxg6a92NtEO9bDi+6tvWUx
 P+xM3xW7MRfYc1bBEu14g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 September 2010, Jiri Olsa wrote:
> --- a/arch/x86/oprofile/nmi_int.c
> +++ b/arch/x86/oprofile/nmi_int.c
> @@ -674,6 +674,7 @@ static int __init ppro_init(char **cpu_type)
>         case 0x0f:
>         case 0x16:
>         case 0x17:
> +       case 0x1d:
>                 *cpu_type = "i386/core_2";
>                 break;
>         case 0x1a:

Just curious about the other missing IDs: this now supports all Core
microarchitecture CPUs, but only some Nehalem/Westmere ones.

There is support for 0x1a (Bloomfield/Gainestown) and 0x2e (Beckton), but
not for the much more common 0x1e (Lynnfield/Clarksfield/Jasper Forest),
0x25 (Clarkdale/Arrandale) and 0x26 (Gulftown/Westmere-EP).

Shouldn't those be added as well?

When you're there, it probably also wouldn't hurt to fill in the blanks
of some of the older CPUs like Tolopai (0x15) and newer Atoms (0x1c).

	Arnd
