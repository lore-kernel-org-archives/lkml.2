Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab0DYQrb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 12:47:31 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:42979 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab0DYQr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 12:47:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=mm9WCVXLUY8RNipYBZDllHCq45fCrxVtaYAYEZ46YawoFlRxryWSUBpE8fVftkwUm3
         9LWo2r67X7lwSknrShBpcB4vMkY7Zj9ulG4AQNOKoncc6wSW+UUKhXgHteCCBD77a46E
         uLwFC9DKUdDxcPcHdAl8EClvQ57/MY/iQ9wzs=
Message-ID: <4BD4721D.2090202@gmail.com>
Date: Sun, 25 Apr 2010 10:47:25 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Richard Genoud <richard.genoud@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [bug ?] device reported invalid CHS sector 0 / NCQ disabled due
 to  excessive errors
References: <o2l80b317761004250816q17a14763g812d9fbe32d42f80@mail.gmail.com>
In-Reply-To: <o2l80b317761004250816q17a14763g812d9fbe32d42f80@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2010 09:16 AM, Richard Genoud wrote:
> Hi !
>
> I've bought a new motherboard (asus P7P55D) and I'm seeing annoying
> errors about NCQ.
> To reproduce the problem, I compile a kernel with -j4.
> At some point, the compilation freezes, it seems that nothing is
> written to the hdds for something like 1 or 2 minutes.
> Then, all starts again and I can see in the logs a lot of "device
> reported invalid CHS sector 0".
> Sometimes, after that, NCQ is disabled.
>
> It happens on disks on my RAID 1 array (sda/sdb, ext4 formatted), but
> not on my third disk (sdc, ext3 formatted)
>
> kernel is from ubuntu (with the commit
> 8da854cb02156c90028233ae1e85ce46a1d3f82c (hpet erratum for intel P55))
> I tried with 2.6.34-rc5, and the problem is still there.
>
> Does this ring a bell ? (maybe it's not kernel related, and it's a
> problem with my HDDs...)

Usually this sort of thing is some kind of hardware problem - either a 
firmware bug in the drive, or else a SATA link communication problem 
like a bad cable, or the drives not getting clean power under load.

>
> Apr 21 19:20:03 desktop kernel: [  119.920702] ata2: hard resetting link
> Apr 21 19:20:03 desktop kernel: [  120.449693] ata2: SATA link up 3.0
> Gbps (SStatus 123 SControl 300)
> Apr 21 19:20:03 desktop kernel: [  120.451774] ata2.00: configured for UDMA/133
> Apr 21 19:20:03 desktop kernel: [  120.451782] ata2.00: device
> reported invalid CHS sector 0
> Apr 21 19:20:03 desktop kernel: [  120.451786] ata2.00: device
> reported invalid CHS sector 0
> Apr 21 19:20:03 desktop kernel: [  120.451790] ata2.00: device
> reported invalid CHS sector 0
> Apr 21 19:20:03 desktop kernel: [  120.451801] ata2: EH complete

The log is missing the detail messages indicating what actually happened 
- can you post the output from dmesg instead?
