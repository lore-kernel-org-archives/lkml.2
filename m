Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab0GLPs2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 11:48:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52643 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756078Ab0GLPs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 11:48:26 -0400
Message-ID: <4C3B38F7.1050400@zytor.com>
Date: Mon, 12 Jul 2010 08:47:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Yinghai Lu <yinghai.lu@oracle.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Setup early console as early as possible
References: <4C3A3B27.7020009@oracle.com> <4C3AD94C.7070807@cs.helsinki.fi>
In-Reply-To: <4C3AD94C.7070807@cs.helsinki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2010 01:58 AM, Pekka Enberg wrote:
> Hi Yinghai,
> 
> Yinghai Lu wrote:
>> Analyze "console=uart8250,io,0x3f8,115200n8" in
>> i386_start_kernel/x86_64_start_kernel,
>> and call setup_early_serial8250_console() to init early serial console.
>>
>> only can handle io port kind of 8250. because mmio need ioremap.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> What's the purpose of this patch? Does it make my early boot I/O patch
> obsolete?
> 
>             Pekka

No, they're complementary.  Your patch serial-port enables the RM
kernel, whereas Yinghai pushes the initialization earlier in the PM kernel.

Incidentally, Yinghai: it would be possible to push even an MMIO
reference earlier by reserving a fixmap slot for the early console.  I'm
not sure if it's worth it, though.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

