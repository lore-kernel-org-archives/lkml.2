Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab1FNPcg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 11:32:36 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35962 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349Ab1FNPcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 11:32:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=OXiadkuoX580JGMQh7FKbz/4oix5BiVqYs78NowqFpCzib7Nm4NhI8qRnx3i11+W60
         ulMNRD8wcWQyA6lJucZK8CUVZ8NHExdLNnCQOsbna/kyo8vvnX68olIhqQeME4MiBKta
         +s/Hp+oaufD2IUKk0bowrPpM6nWrh+mnM/zq8=
Message-ID: <4DF77ECB.4030709@gmail.com>
Date: Tue, 14 Jun 2011 17:31:23 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Thunderbird/3.1.9
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Yinghai Lu <yinghai@kernel.org>, Jim Bos <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, efi: Do not reserve boot services regions within
 reserved areas
References: <4DF77832.9020407@gmail.com> <20110614152101.GA17773@srcf.ucam.org>
In-Reply-To: <20110614152101.GA17773@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 14-06-11 17:21, Matthew Garrett schreef:
> On Tue, Jun 14, 2011 at 05:03:14PM +0200, Maarten Lankhorst wrote:
>
>> +		/* Could not reserve boot area */
>> +		if (!size)
>> +			continue;
>> +
>> +		printk(KERN_INFO PFX "Freeing boot area "
>> +			"[0x%llx-0x%llx)\n", start, start+size);
> Probably don't need the printk - we could be dumping a few hundred of 
> those.
Ok, I believe you are right about the succesful ones, since memblock=debug
will let you see those anyhow.

Should I change the unsuccesful ones to use memblock_dbg instead of printk?
In that case you can still debug it if needed. Same question for free path,
change printk to memblock_dbg?
>> -		  "Kernel-defined memdesc doesn't match the one from EFI!\n");
>> +		  "Kernel-defined memdesc (%lu) "
>> +			"doesn't match the one from EFI(%lu)!\n",
>> +			sizeof(efi_memory_desc_t), memmap.desc_size);
> And drop this hunk. It's entirely valid for an implementation to do 
> this, we should just delete the message entirely.
Ok. Just wasn't sure what to make of it, since that message kept popping up here.

~Maarten
