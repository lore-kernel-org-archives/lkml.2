Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016Ab0F1XWJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 19:22:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:26607 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108Ab0F1XWG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 19:22:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,499,1272870000"; 
   d="scan'208";a="531117132"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>,
       "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 28 Jun 2010 16:22:03 -0700
Subject: RE: problem: Re: [PATCH] input: fixup X86_MRST selects
Thread-Topic: problem: Re: [PATCH] input: fixup X86_MRST selects
Thread-Index: AcsXE4KgHqofjGyoQq6ZAE+WOuq6DwAAh/qQ
Message-ID: <43F901BD926A4E43B106BF17856F0755EA339200@orsmsx508.amr.corp.intel.com>
References: <20100609133443.38f1f957.sfr@canb.auug.org.au>
 <201006101204.45709.dmitry.torokhov@gmail.com> <4C28F210.7030909@oracle.com>
 <201006281318.16377.dmitry.torokhov@gmail.com> <4C2904D0.3000409@oracle.com>
 <43F901BD926A4E43B106BF17856F0755EA339079@orsmsx508.amr.corp.intel.com>
 <20100628224440.GA19087@core.coreip.homeip.net>
In-Reply-To: <20100628224440.GA19087@core.coreip.homeip.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no DMI support yet in MRST FW.
We have a new x86 HW subarch ID in boot_param, then we use it to select x86_init abstractions. Both boot_param and x86_init are x86 arch specific so I guess we can use them in 8042 driver under CONFIG_X86. Not sure if it is possible to move x86 i8042_platform_init under x86_init (the x86 part).

>-----Original Message-----
>From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
>Sent: Monday, June 28, 2010 3:45 PM
>To: Pan, Jacob jun
>Cc: Randy Dunlap; Stephen Rothwell; linux-next@vger.kernel.org; LKML;
>linux-input@vger.kernel.org; akpm; chuck.lever@oracle.com; H. Peter
>Anvin
>Subject: Re: problem: Re: [PATCH] input: fixup X86_MRST selects
>
>On Mon, Jun 28, 2010 at 02:12:03PM -0700, Pan, Jacob jun wrote:
>> >
>> We do intend to maintain binary compatibility between generic kernel
>and Moorestown.
>> I guess the challenge is not having enumeration of i8042 pass to the
>driver. Do you
>> prefer abort i8042_platform_init() based on #define CONFIG_X86_MRST?
>It is no safe
>> to probe HW on Moorestown, unfortunately.
>
>Any check based on CONFIG_X86_MRST means that kernel is not generic.
>We'd need a runtime check (but not necessarily one that bangs ports). Is
>there something in processor flags, or DMI, or similar that woudl allow
>i8042 to see that it runs on Moorestown?
>
>--
>Dmitry
