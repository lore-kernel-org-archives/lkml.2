Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668Ab2KEBil (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 20:38:41 -0500
Received: from mga09.intel.com ([134.134.136.24]:21080 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756Ab2KEBij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 20:38:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,712,1344236400"; 
   d="scan'208";a="237143583"
From: "Zhang, Jun" <jun.zhang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] crash dump: don't delete non-E820_RAM during init
Thread-Topic: [PATCH] crash dump: don't delete non-E820_RAM during init
Thread-Index: AQHNuRhj9jwtrkjpzUKPlXSE5m+kWZfadb7w
Date: Mon, 5 Nov 2012 01:37:54 +0000
Message-ID: <88DC34334CA3444C85D647DBFA962C270FD7F4B6@SHSMSX102.ccr.corp.intel.com>
References: <88DC34334CA3444C85D647DBFA962C270FD7EAD3@SHSMSX102.ccr.corp.intel.com>
 <50909120.3040101@zytor.com>
 <88DC34334CA3444C85D647DBFA962C270FD7EB0B@SHSMSX102.ccr.corp.intel.com>
 <5090AB3C.5050405@zytor.com>
 <88DC34334CA3444C85D647DBFA962C270FD7EB3A@SHSMSX102.ccr.corp.intel.com>
 <5090B966.4040605@zytor.com>
 <88DC34334CA3444C85D647DBFA962C270FD7EF68@SHSMSX102.ccr.corp.intel.com>
 <c6a025f9-0ac5-45d7-bda9-7f9bc8eaf9ab@email.android.com>
 <88DC34334CA3444C85D647DBFA962C270FD7F039@SHSMSX102.ccr.corp.intel.com>
 <5093F6DA.7040709@zytor.com>
In-Reply-To: <5093F6DA.7040709@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qA51cqvX005630

Hello, Gortmaker
I will modify my subject. Thanks!

Hello, Anvin
from our three options, I think third option is better. But in 3) option, there are two choose, 3.1) is like memmap=REMOVERAM, 3.2) is memmap=CRASHKDUMP.
In 3.1) we maybe need ifdef/endif within the { } of the function (like exactmap).
In 3.2) we can remove the ifdef/endif. 
Which one is the better? Maybe you have a better solution, please share it. 
Thanks!

Next is our three option.
1)  my patch.
2)  modify kexec, only pass two parameters -- memmap=544K@64K 
    memmap=64964K@32768K, in kernel setup_memory_map, we can remove RAM 
    range.
3)  add extra optional, 3.1) like memmap=REMOVERAM
                   3.2) like memmap=CRASHKDUMP

Best Regards!

Jun Zhang
Inet: 8821-4273
Dir.Tel: 86-21-6116-4273
Email: jun.zhang@intel.com

-----Original Message-----
From: H. Peter Anvin [mailto:hpa@zytor.com] 
Sent: Saturday, November 03, 2012 12:38 AM
To: Zhang, Jun
Cc: Thomas Gleixner; Ingo Molnar; x86@kernel.org; Andrew Morton; Fleming, Matt; Paul Gortmaker; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] To crash dump, we need keep other memory type except E820_RAM, because other type come from BIOS or firmware is used by other code(for example: PCI_MMCONFIG).

On 11/01/2012 01:49 AM, Zhang, Jun wrote:
> Hello, Anvin
> 
> Thank for your advice.
> 
> Hello, All
> 
> the next patch is made by 2), please review it. Thanks!
> 

No, it is not.

You are still modifying the behavior of the kernel depending on CONFIG_CRASH_DUMP.

CONFIG_CRASH_DUMP doesn't mean "we are doing a crash dump".  It means "it is possible to use this kernel to do a crash dump".

Either you are using standard kernel parameters in a standard way which is what option 2 was supposed to be -- it should require no kernel changes! -- or you have to put something in a code path specific to a crash dump.

	-hpa

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
