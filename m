Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951Ab2COCfp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 22:35:45 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:37865 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419Ab2COCfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 22:35:44 -0400
Message-ID: <4F61537C.8030309@gmail.com>
Date: Thu, 15 Mar 2012 02:27:08 +0000
From: Vasco Dias <rafa.vasco@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Thunderbird/10.0.2
MIME-Version: 1.0
To: =?UTF-8?B?TW90aWVqdXMgSmFrxaF0eXM=?= <desired.mta@gmail.com>
CC: Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org,
        mikew@google.com
Subject: Re: Problem with efibootmgr on asus 1215b
References: <20120312143806.GB12382@srcf.ucam.org> <20120315012941.GA24251@pierce>
In-Reply-To: <20120315012941.GA24251@pierce>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 15 Mar 2012 01:29:41 AM WET, Motiejus Jakštys wrote:
>> Somewhat late to this I know, but:
>>
>> On Fri, Jan 20, 2012 at 11:48:26AM +0000, Matt Fleming wrote:
>>> [  441.370854] BUG: unable to handle kernel paging request at 00000000ffe1fbc8
>>
>> So it's attempting a direct access to 00000000ffe1fbc8, which, if I had
>> to guess, is probably where the flash is located. That makes sense from
>> the perspective of it being used in efivars. The obvious sadness here is
>> that it's doing this with a physical address rather than a virtual one.
>> It's possible that the machine is too broken to live - does Windows
>> succeed in performing a UEFI install? If it does then I think we need to
>> just accept that life is ugly and map the UEFI runtime areas with a 1:1
>> mapping as well as into virtual address space. That would also fix the
>> problem we see right now where the reboot call often uses a physical
>> address rather than a virtual one.
>
> Just to let you know I apparently have exactly the same issue with the same
> laptop. If it can help, I could try installing the M$ Student Edition during
> the weekend and report the results.
>
> Windows Server 2008 64-bit, fresh GPT partition table will be my lab
> environment. Standard installation procedure.
>
> I am running Ubuntu 12.04 with 3.2.0-18-generic.
>
> Motiejus

I have to say that before installing linux i tried installing windows 
right after
converting the system to gpt and after selecting the partition to 
install it it
would just BSOD.

I downloaded windows from my msdna account, converted it to boot from 
the usb drive and manually selected the efi file from the drive to 
launch
the windows setup. 

Sometimes it would reboot just after starting, other times it would BSOD
after selecting the partition and clicking next and yet other times it 
would
start installing and then BSOD.

After at least 20 different attemps there was just one time that before 
going into BSOD that it successfuly registered the microsoft boot 
program with the efi boot variables.

All that assuming the files on the usb drive were not corrupted ;)
(it would be fun if they were)
