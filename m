Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757166Ab0GMRnO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 13:43:14 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:60641 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab0GMRnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 13:43:12 -0400
Message-ID: <4C3CA5A9.6000607@cs.helsinki.fi>
Date: Tue, 13 Jul 2010 20:43:05 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Setup early console as early as possible
References: <4C3A3B27.7020009@oracle.com> <4C3AD94C.7070807@cs.helsinki.fi> <4C3B38F7.1050400@zytor.com> <4C3B40F3.6070009@kernel.org>
In-Reply-To: <4C3B40F3.6070009@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yingahai,

Yinghai Lu wrote:
> On 07/12/2010 08:47 AM, H. Peter Anvin wrote:
>> On 07/12/2010 01:58 AM, Pekka Enberg wrote:
>>> Hi Yinghai,
>>>
>>> Yinghai Lu wrote:
>>>> Analyze "console=uart8250,io,0x3f8,115200n8" in
>>>> i386_start_kernel/x86_64_start_kernel,
>>>> and call setup_early_serial8250_console() to init early serial console.
>>>>
>>>> only can handle io port kind of 8250. because mmio need ioremap.
>>>>
>>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>> What's the purpose of this patch? Does it make my early boot I/O patch
>>> obsolete?
>>>
>>>             Pekka
>> No, they're complementary.  Your patch serial-port enables the RM
>> kernel, whereas Yinghai pushes the initialization earlier in the PM kernel.
> 
> yes. cover more range.
> 
> Can you consider to ask Pekka to anaylze "console=uart8250,io, 0x3f8,115200n8" instead?
> 
> it looks like we can remove "earlyprintk=ttyS0,115200", or "earlyprintk=serial" etc.
> 
> earlycon=uart8250 or console=uart8250 should be better than earlyprintk.
> because it is shared between different archs already.

So just to clarify: I wasn't ignoring your comment here. I simply 
followed hpa's recommendation on which I also happen to agree with 
completely. ;-)

			Pekka
