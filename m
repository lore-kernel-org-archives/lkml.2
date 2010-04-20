Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab0DTECW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 00:02:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44851 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753698Ab0DTECR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 00:02:17 -0400
Message-ID: <4BCD25B7.2020102@zytor.com>
Date: Mon, 19 Apr 2010 20:55:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Guenter Roeck <guenter.roeck@ericsson.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "penberg@cs.helsinki.fi" <penberg@cs.helsinki.fi>,
       "mingo@redhat.com" <mingo@redhat.com>,
       "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH][RESEND] x86: Do not write to VGA memory space if	CONFIG_VGA_CONSOLE
 is undefined
References: <1270046479-4486-1-git-send-email-guenter.roeck@ericsson.com> <84144f021003310832i3420e4c1g7396b4d1f311f393@mail.gmail.com> <1270491029.1477.453.camel@groeck-laptop> <4BBA3021.9090504@zytor.com> <1270497725.1477.488.camel@groeck-laptop> <4BBA473D.9040004@zytor.com> <1270501481.1477.521.camel@groeck-laptop> <4BBA51F3.7070808@zytor.com> <1270505579.1477.584.camel@groeck-laptop> <4BCCC4E1.8040109@zytor.com> <20100420022110.GA20116@ericsson.com>
In-Reply-To: <20100420022110.GA20116@ericsson.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2010 07:21 PM, Guenter Roeck wrote:
> On Mon, Apr 19, 2010 at 05:02:25PM -0400, H. Peter Anvin wrote:
>> Hi Guenter,
>>
>> I wanted to check where we are at... at the very least we should drop
>> messages issued before initialization when isVGA != 1.
>>
>> Since serial ports require initialization, I really don't want to send
>> messages to the serial port before the port has been initialized, but
>> obviously it would be good to initialize earlyprintk as early as at all
>> possible.
>>
> Moving setup_early_printk() around may be possible, but I do not know
> the code good enough to take that risk. Even trying was a bad idea.
>
> I could submit a patch to add some protection into early_printk(),
> to ensure it does not write into VGA memory space if there is no VGA,
> and do that without changing current semantics - specifically, still
> write into VGA memory space even if setup_early_printk() was not called
> yet, but if boot_params.screen_info.orig_video_isVGA is set.
>
> I thought you indicated that you are opposed to changing the code,
> and it looks kind of clumsy, so I concluded that it was not worth
> trying again. Maybe I misunderstood - let me know.
>
> Guenter

I think writing into VGA memory if we know there is a VGA device is 
there.  I don't want to write to an uninitialized serial port, because 
that can cause all kinds of problems.

But yes, dropping output to VGA if there isn't one makes a lot of sense.

	-hpa
