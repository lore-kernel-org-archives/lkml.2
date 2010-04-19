Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab0DSInl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 04:43:41 -0400
Received: from smtp-out.google.com ([216.239.44.51]:58932 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab0DSInk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 04:43:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:user-agent:mime-version:to:cc:subject:
	references:in-reply-to:content-type:
	content-transfer-encoding:x-system-of-record;
	b=s7LduraCkjwxfZdTLCvS77RDkgWxd3ojOAeCPl57sUYmINlNR1+R66Rl2FPlUUq73
	s5b6ElEX8GaCYevGRgiNg==
Message-ID: <4BCC17B2.80509@google.com>
Date: Mon, 19 Apr 2010 01:43:30 -0700
From: Mike Waychison <mikew@google.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.9) Gecko/20100317 Lightning/1.0b1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: =?UTF-8?B?SmFuIEt1bmRyw6F0?= <jkt@gentoo.org>,
       linux-kernel@vger.kernel.org
Subject: Re: boot device order troubleshooting without an initrd
References: <4BCB87E2.4090807@gentoo.org> <20100418165125.1d2b2843@infradead.org>
In-Reply-To: <20100418165125.1d2b2843@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/18/2010 4:51 PM, Arjan van de Ven wrote:
> On Mon, 19 Apr 2010 00:29:54 +0200
> Jan Kundrát<jkt@gentoo.org>  wrote:
>
>> Hi folks,
>> I'm looking for a way to pass a correct "root" parameter to the kernel
>> from the bootloader, independently on the number of attached disks. My
>> machine (VIA EPIA SN-1800) has four SATA ports and one CF card slot.
>> The CF slot is visible as an IDE device. The BIOS is configured for
>> booting from the CF card, and Grub2 has absolutely no problems
>> booting the kernel.
>>
>> The problem I'm facing is that if there are no SATA disks attached, my
>> CF card gets called /dev/sda, while if I attach two SATA drives, the
>> CF card gets called /dev/sdc. I can solve that "in userspace" without
>
>
> so the problem is that the boot order you want is pretty much opposite
> from what "normal" people want.
> AHCI sata before CF slots is pretty much the right thing and what most
> people will use.... most people will have their OS on AHCI SATA, and
> occasionally stick in some photo card or whatever.... and they'd ask
> the flipside question basically.
>
>
> We could have pretty evil things in the kernel, so that we'd deal with
> multiple root= lines in the kernel, one by one trying them until one
> sticks. Right now we don't.... but if you make a clean enough patch
> it might even pass the review here...
>

Multiple root devices here may help..  I recently added support for 
enumerating multiple root devices to kinit in klibc to work around some 
configuration issues on our servers.

http://git.kernel.org/?p=libs/klibc/klibc.git;a=commit;h=5b5b6f5192af5c3fa30fe605e8842c62421adbd4
