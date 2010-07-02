Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872Ab0GBG1o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 02:27:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36606 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755922Ab0GBG1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 02:27:41 -0400
Message-ID: <4C2D86C1.1060007@zytor.com>
Date: Thu, 01 Jul 2010 23:27:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>,
       "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, kphillisjr@gmail.com
Subject: Re: problem: Re: [PATCH] input: fixup X86_MRST selects
References: <20100609133443.38f1f957.sfr@canb.auug.org.au> <201006101204.45709.dmitry.torokhov@gmail.com> <4C28F210.7030909@oracle.com> <201006281318.16377.dmitry.torokhov@gmail.com> <4C2904D0.3000409@oracle.com> <43F901BD926A4E43B106BF17856F0755EA339079@orsmsx508.amr.corp.intel.com> <20100628224440.GA19087@core.coreip.homeip.net> <43F901BD926A4E43B106BF17856F0755EA339200@orsmsx508.amr.corp.intel.com> <20100702044607.GA1203@core.coreip.homeip.net>
In-Reply-To: <20100702044607.GA1203@core.coreip.homeip.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2010 09:46 PM, Dmitry Torokhov wrote:
> On Mon, Jun 28, 2010 at 04:22:03PM -0700, Pan, Jacob jun wrote:
>> There is no DMI support yet in MRST FW.  We have a new x86 HW subarch
>> ID in boot_param, then we use it to select x86_init abstractions. Both
>> boot_param and x86_init are x86 arch specific so I guess we can use
>> them in 8042 driver under CONFIG_X86. Not sure if it is possible to
>> move x86 i8042_platform_init under x86_init (the x86 part).
>>
> 
> Moving i8042_platform_init() into platform code is quite invasive,
> how about we to the following?
> 
> Thanks.
> 

Uck, no!

	----
Moorestown does not have legacy hardware (i8042, i8259) and does not
like legacy ports being poked by drivers. Instead of playing with
Kconfig selections let's check if we set up dummy (null) legacy PIC
during startup and abort i8042 initialization as well. This should
fix the following bug:
	----

The presence of 8042 and 8259 are orthogonal.  In fact, there are quite
a few systems on the market which have 8259 but not 8042, and at least
having the ability to handle that correctly instead of just assuming
that those I/O ports are safe is pretty key.

So please don't commingle these completely unrelated platform attributes.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

