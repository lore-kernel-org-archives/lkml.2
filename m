Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335Ab0FNXtQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 19:49:16 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60324 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab0FNXtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 19:49:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=R5Irj/hk6TTgWd2D2PWL2jj8fXwG4ofDeL1x0ywSVIHEL22l1sEukFZYrZK7tbgEM2
         O8GRYQrH+gOrpH9iYk/hpWGJMGDkxBTGDXy/SmzBZOJz57yZjNEhCnMRuLR1jsGvyC4m
         qpUyGhXFToMFrI67O/CB5mg+DbNEVgCTU7KEY=
Message-ID: <4C16BFF5.7070308@gmail.com>
Date: Mon, 14 Jun 2010 17:49:09 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jeff Chua <jeff.chua.linux@gmail.com>
CC: Greg KH <greg@kroah.com>, kristen.c.accardi@intel.com,
       Dely Sy <dely.l.sy@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Takayoshi Kochi <t-kochi@bq.jp.nec.com>, Matthew Wilcox <willy@hp.com>
Subject: Re: e-SATA ExpressCard - OOPS plus incrementing "ataX" on  Linux-2.6.xx
References: <AANLkTimnqVSom2qHetXMBPiCNTYd-yc8Tl6a64n0zTSk@mail.gmail.com>	<20100614162002.GA13902@kroah.com> <AANLkTinwaYy5Z528PraVuWUsU2pJBLoq0c2hgIGirTNn@mail.gmail.com>
In-Reply-To: <AANLkTinwaYy5Z528PraVuWUsU2pJBLoq0c2hgIGirTNn@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2010 12:44 PM, Jeff Chua wrote:
> On Tue, Jun 15, 2010 at 12:20 AM, Greg KH<greg@kroah.com>  wrote:
>> On Mon, Jun 14, 2010 at 11:16:29PM +0800, Jeff Chua wrote:
>
>
>> This is a warning that you can ignore, it's been fixed in the latest
>> tree (2.6.35-rc3).
>>
>> try that and see.
>
> Greg,
>
> Ok, just tried rc3 and it's fixed the 1st OOPS.
>
> But I'm still seeing the "ataX" incrementing from ata7 to ata8, ata9
> ... after taking out and putting back the card. It seems the interface
> is still not shutting down properly. ... Any command to shutdown it
> down gracefully?

The ataX number incrementing is normal (it always increments when an ATA 
host is initialized, it doesn't appear the numbers get reused). The 
other messages are the expected result when you surprise-remove the 
card. I think there should be a way to trigger the hotplug code to 
disable the device before you eject it, but I'm not sure what that is 
supposed to be - maybe echo 1 to /sys/device/pci_somethingorother/remove ?

>
> ata9.00: disabled
> 2010-06-15T02:32:04.531177+08:00 boston kernel: ata9.00: disabled
> sd 8:0:0:0: [sdb] Synchronizing SCSI cache
> sd 8:0:0:0: [sdb] Result: hostbyte=0x04 driverbyte=0x00
> sd 8:0:0:0: [sdb] Stopping disk
> sd 8:0:0:0: [sdb] START_STOP FAILED
> sd 8:0:0:0: [sdb] Result: hostbyte=0x04 driverbyte=0x00
> 2010-06-15T02:32:04.568687+08:00 boston kernel: sd 8:0:0:0: [sdb]
> Synchronizing SCSI cache
> 2010-06-15T02:32:04.568715+08:00 boston kernel: sd 8:0:0:0: [sdb]
> Result: hostbyte=0x04 driverbyte=0x00
> 2010-06-15T02:32:04.568719+08:00 boston kernel: sd 8:0:0:0: [sdb] Stopping disk
> 2010-06-15T02:32:04.568731+08:00 boston kernel: sd 8:0:0:0: [sdb]
> START_STOP FAILED
> 2010-06-15T02:32:04.568735+08:00 boston kernel: sd 8:0:0:0: [sdb]
> Result: hostbyte=0x04 driverbyte=0x00
> ata9: failed to stop engine (-5)
> ahci 0000:05:00.0: PCI INT A disabled
> 2010-06-15T02:32:05.068765+08:00 boston kernel: ata9: failed to stop engine (-5)
> 2010-06-15T02:32:05.068797+08:00 boston kernel: ahci 0000:05:00.0: PCI
> INT A disabled
>
>
>
> Thanks,
> Jeff

