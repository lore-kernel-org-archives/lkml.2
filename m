Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab2KEC5h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 21:57:37 -0500
Received: from mga03.intel.com ([143.182.124.21]:31521 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752317Ab2KEC5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 21:57:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,712,1344236400"; 
   d="scan'208";a="164480774"
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
Thread-Index: AQHNuv7N4munyjGOZ0uRUn1qUrJmJ5faiFUw
Date: Mon, 5 Nov 2012 02:57:24 +0000
Message-ID: <88DC34334CA3444C85D647DBFA962C270FD7F507@SHSMSX102.ccr.corp.intel.com>
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
 <88DC34334CA3444C85D647DBFA962C270FD7F4B6@SHSMSX102.ccr.corp.intel.com>
 <509726D0.4010606@zytor.com>
In-Reply-To: <509726D0.4010606@zytor.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qA52vgJC005748

Hello, Anvin
1) use "memmap=exactmap", which remove all ranges include ram and non-ram range. So my first patch reserve the non-ram range.
2)don't use " memmap=exactmap ", so it reserve all ranges. But we only need non-ram, so we need kernel to remove RAM, just as my second patch.


Best Regards!

Jun Zhang
Inet: 8821-4273
Dir.Tel: 86-21-6116-4273
Email: jun.zhang@intel.com


-----Original Message-----
From: H. Peter Anvin [mailto:hpa@zytor.com] 
Sent: Monday, November 05, 2012 10:39 AM
To: Zhang, Jun
Cc: Thomas Gleixner; Ingo Molnar; x86@kernel.org; Andrew Morton; Fleming, Matt; Paul Gortmaker; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crash dump: don't delete non-E820_RAM during init

On 11/05/2012 02:37 AM, Zhang, Jun wrote:
> Hello, Gortmaker
> I will modify my subject. Thanks!
> 
> Hello, Anvin
> from our three options, I think third option is better. But in 3) option, there are two choose, 3.1) is like memmap=REMOVERAM, 3.2) is memmap=CRASHKDUMP.
> In 3.1) we maybe need ifdef/endif within the { } of the function (like exactmap).
> In 3.2) we can remove the ifdef/endif. 
> Which one is the better? Maybe you have a better solution, please share it. 
> Thanks!
> 
> Next is our three option.
> 1)  my patch.
> 2)  modify kexec, only pass two parameters -- memmap=544K@64K 
>     memmap=64964K@32768K, in kernel setup_memory_map, we can remove RAM 
>     range.
> 3)  add extra optional, 3.1) like memmap=REMOVERAM
>                    3.2) like memmap=CRASHKDUMP
> 

Again, 2 would be better because it is a localized change to kexec.  If that works I don't see why there is any reason to change anything else.

	-hpa


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
