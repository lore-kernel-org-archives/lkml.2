Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab0HBSkE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 14:40:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58047 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754298Ab0HBSkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 14:40:01 -0400
Message-ID: <4C5710C1.8020809@zytor.com>
Date: Mon, 02 Aug 2010 11:38:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v3 2/2] x86: more early console output from	compressed/misc.c
References: <4C56701B.1030000@kernel.org> <4C5670DA.2080703@zytor.com> <4C5680D2.4020302@kernel.org> <4C568D2B.205@kernel.org> <4C568D6F.3050004@kernel.org> <20100802174916.GD5544@lenovo>
In-Reply-To: <20100802174916.GD5544@lenovo>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2010 10:49 AM, Cyrill Gorcunov wrote:
> On Mon, Aug 02, 2010 at 02:18:39AM -0700, Yinghai Lu wrote:
>>
>> will get
>>
>> |Decompressing Linux... Parsing ELF... done.
>> |Booting the kernel.
>>
>> in serial console.
>>
>> reuse code from arch/x86/boot/
>> and we can use printf if needed
>>
>> -v2: define BOOT_BOOT_H to avoid include boot.h
>> -v3: early_serial_base need to be static in misc.c ?
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> ---
>>  arch/x86/boot/compressed/misc.c |   65 +++++++++++++++++++++++++++++++++++++++-
>>  arch/x86/boot/main.c            |    6 +--
>>  2 files changed, 66 insertions(+), 5 deletions(-)
>>
> 
> It seems eventually we just add ~80 lines of code in compare with what we had before,
> just to print "Decompressing..." by serial line. Not sure Yinghai if it worth
> it. Though having printf that early might be quite useful for those who debugging
> or developing new compressors/decompressors. If it would be small non-intrusive
> patch I would both hands for it but now I simply don't know (to be fair mine
> proposal based on your initial patch not better either ;)
> 

Decompressing... is one thing, and if it was only that, I'd just suggest
killing off the console I/O in boot/compressed.  Getting an error
message out when there is a decompression failure is another thing.

Processing the command line a novo is somewhat painful, but it does deal
better with bootloaders that use the 32-bit entry point by necessity
(kexec, EFI) or due to sheer stupidity (Grub2).

As such, I think it's a worthwhile addition, as long as the source code
can be cleanly shared with the boot/ directory.

	-hpa

