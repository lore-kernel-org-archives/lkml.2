Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab0CXAUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 20:20:39 -0400
Received: from mail-yw0-f172.google.com ([209.85.211.172]:51098 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab0CXAUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 20:20:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=nEDoaq4M7sLm4d8pkxbZrpt2W2nisfAZIoQiDEjKsCGLlwY/1XozRk5FmFZjfBKEdP
         QYPnZGQcPENLP0q7uJrkZ7ytdbZLOZT4rxO88yo2Ypo0D6E4tifIMR3+zryosB80sNZC
         MVC4HqcXrgINKPO6mwgzBtV4iLbUC8avZwItQ=
Message-ID: <4BA95AD1.2090906@gmail.com>
Date: Tue, 23 Mar 2010 18:20:33 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Mike Hayward <hayward@loup.net>, linux-kernel@vger.kernel.org,
       ide <linux-ide@vger.kernel.org>
Subject: Re: Regression: my systems can no longer boot from an ide hard drive
References: <201003230801.o2N81UKg009750@alien.loup.net> <20100323091718.5a57b6e1.randy.dunlap@oracle.com>
In-Reply-To: <20100323091718.5a57b6e1.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2010 10:17 AM, Randy Dunlap wrote:
> [adding linux-ide mailing list]
>
> On Tue, 23 Mar 2010 02:01:30 -0600 Mike Hayward wrote:
>
>> Three identical known good opteron systems can no longer boot freshly
>> installed distros from an ide hard drive.  The systems have one ide
>> drive and eight sata drives.  If distro is installed to ide drive,
>> Ubuntu 9.10 server moves cursor down the screen twice, then hangs
>> while Fedora 12 grub loads but then claims it can't find root to mount
>> and it and hangs 'forever'.  Numerous distros have all booted fine
>> before 2.6.25... I don't know where it went wrong between 25 and 31.
>>
>> This is despite partitioning with and without lvm, despite making sure
>> kernel/boot loader are in partition in first 2 gigs of ide drive.
>>
>> Both distros boot just fine on each system when os is installed on a
>> sata drive so this isn't a hardware defect.
>>
>> Distro that boots fine from ide:
>> Linux opt1 2.6.25-14.fc9.x86_64 #1 SMP Thu May 1 06:06:21 EDT 2008 x86_64 x86_64 x86_64 GNU/Linux
>>
>> Distros that no longer boot via ide drive:
>> Linux opt2 2.6.31-14-server #48-Ubuntu SMP Fri Oct 16 15:07:34 UTC 2009 x86_64 GNU/Linux
>> Linux opt3 2.6.31.5-127.fc12.x86_64 #1 SMP Sat Nov 7 21:11:14 EST 2009 x86_64 x86_64 x86_64 GNU/Linux
>>
>> Maybe this can be worked around with some options to grub or
>> kernel... if so, shouldn't distros detect that ide drives are being
>> set up and configure the boot loader properly?  It would be very hard
>> for newbie to figure this one out.

Most likely the IDE drive isn't being detected properly, but we need 
more info on the hardware. Can you post the dmesg output from bootup 
with a working kernel? (If you can, the boot messages from the ones that 
fail to boot would be ideal. For the Fedora one, you can edit the kernel 
command line in grub and take the "quiet" off the end to see more of 
them on the screen, any ata output would be useful..)
