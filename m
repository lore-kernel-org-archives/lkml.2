Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab1EGQaR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 12:30:17 -0400
Received: from pindarots.xs4all.nl ([80.101.128.228]:52423 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790Ab1EGQaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 12:30:12 -0400
Message-ID: <4DC57392.8010902@xs4all.nl>
Date: Sat, 07 May 2011 18:30:10 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: AMD C1E issue?   2.6.38.4
References: <4DC54CE5.6050307@xs4all.nl> <20110507162130.GA13307@liondog.tnic>
In-Reply-To: <20110507162130.GA13307@liondog.tnic>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-07 18:21, Borislav Petkov wrote:
>> Saw these in my messages after enabling C1E on my new Jetway Mini-ITX board:
>>
>> # microcode_ctl -u
>> microcode_ctl: writing microcode (length: 430080)
>> microcode_ctl: error writing to '/dev/cpu/microcode' errno=22 (Invalid
>> argument)
>> microcode_ctl: there may be messages from the driver in your system log.
>>
>> microcode: AMD microcode update via /dev/cpu/microcode not supported
>> microcode: AMD microcode update via /dev/cpu/microcode not supported
> 
> no, the message is correct - the AMD ucode driver doesn't support
> ucode loading method through the /dev node, only through the firmware
> loader. I.e., you should simply put the microcode image into
> /lib/firmware/amd-ucode/ and compile the kernel microcode driver as a
> module - then it'll load automatically.

Wel, yes/no.
It works that way on my other boxes.
On this specific box microcode_ctl is not activated automagically during
startup of the machine.

> This doesn't have anything to do with C1E.

OK, that helps. Thanks.

What else could be the cause of microcode_ctl not updating?
Situation is:
microcode: CPU0: patch_level=0x10000b7
microcode: CPU1: patch_level=0x10000b7
Is that new enough so that there is just no newer code to be uploaded
for AMD Athlon(tm) II X2 235e Processor ?

Udo
