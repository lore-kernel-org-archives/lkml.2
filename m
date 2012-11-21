Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932342Ab2KVS5u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:57:50 -0500
Received: from mga14.intel.com ([143.182.124.37]:58768 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932287Ab2KVS5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:57:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,295,1352102400"; 
   d="scan'208";a="171176701"
From: "Blower, Melanie" <melanie.blower@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "avi@redhat.com" <avi@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: PROBLEM: compilation issue, inline assembly
 arch/x86/kvm/emulate.c fails at -O0
Thread-Topic: PROBLEM: compilation issue, inline assembly
 arch/x86/kvm/emulate.c fails at -O0
Thread-Index: Ac3CnVCLy1S7HLd7SEaFDxv+y/0FtQF1c5uAAA7ythA=
Date: Wed, 21 Nov 2012 22:31:11 +0000
Message-ID: <B3584E72CFEBED439A3ECA9BCE67A4EF1B17F909@FMSMSX107.amr.corp.intel.com>
References: <B3584E72CFEBED439A3ECA9BCE67A4EF1B17AF90@FMSMSX107.amr.corp.intel.com>
 <50AD4907.5040102@zytor.com>
In-Reply-To: <50AD4907.5040102@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.200.107]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qAMIw8C7004741

Thank you so much, this patch solves the compilation errors that I was seeing in the Intel compiler, and with gcc -O0
BTW, my charter is to compile the kernel with the Intel compiler, and my testing stops short of verifying that the kernel build actually works.
Best regards, Melanie Blower

-----Original Message-----
From: H. Peter Anvin [mailto:hpa@zytor.com] 
Sent: Wednesday, November 21, 2012 4:35 PM
To: Blower, Melanie
Cc: tglx@linutronix.de; mingo@redhat.com; avi@redhat.com; x86@kernel.org; kvm@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: compilation issue, inline assembly arch/x86/kvm/emulate.c fails at -O0

On 11/14/2012 11:45 AM, Blower, Melanie wrote:
> [1.] gcc -O0 assembly arch/x86/kvm/emulate.c gets compilation failure 
> -- incorrect register restrictions [2.] Full description of the problem/report:
> I'm trying to compile this file at -O0, but gcc chokes in register allocation at the inline assembly.
> 
> In the ordinary Linux build, this file compiles with gcc at -O2, without compilation errors.
> 
> At -O0, gcc chokes with this message: 
> gcc  -w -c ./emulateE.c               // (using preprocessed file)
> ./emulateE.c: In function `em_mul_ex':
> ./emulateE.c:1918:5: error: can't find a register in class `AREG' while reloading `asm'
> ./emulateE.c:1918:5: error: `asm' operand has impossible constraints
> 
> Explanation:
> The file contains an inline asm of a kind:
> 
>     __asm__ __volatile__ ( " ..... " :
> 
>  "=m" ((ctxt)->eflags), "=&r" (_tmp), "+a" (*rax), "+d" (*rdx), "+qm"(ex) :
>  "i" (11), "m" ((ctxt)->src . val), "a" (*rax), "d" (*rdx));
> 
> Note that "+a" in inputs already means that eax is the return value. An then "a" is used as an output constraint too.
> 

Hi Melanie,

Can you test the attached patch?

	-hpa


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
