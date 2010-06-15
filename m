Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757111Ab0FOB0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 21:26:46 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42570 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755055Ab0FOB0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 21:26:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=UDCrzN75NBpbnCmjZxlVgwWpxTUxUSv70H5GTdwaeOUrK8ZuDi6S9p/2YKJKdR0jY1
         lfFe37X9D5OIEuNMSS3ZFobXiLH9mFtGBI6yppyiFsoOxBkH5RG6PZ78CkpIsLn1fnNQ
         3Y5d3aWbsQcjuV2IUk6Gr0XIvax/2g3WJg5oc=
Message-ID: <4C16D6CB.9050704@garzik.org>
Date: Mon, 14 Jun 2010 21:26:35 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jeff Chua <jeff.chua.linux@gmail.com>
CC: Greg KH <greg@kroah.com>, kristen.c.accardi@intel.com,
       Dely Sy <dely.l.sy@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Takayoshi Kochi <t-kochi@bq.jp.nec.com>, Matthew Wilcox <willy@hp.com>
Subject: Re: e-SATA ExpressCard - OOPS plus incrementing "ataX" on  Linux-2.6.xx
References: <AANLkTimnqVSom2qHetXMBPiCNTYd-yc8Tl6a64n0zTSk@mail.gmail.com> <20100614162002.GA13902@kroah.com> <AANLkTinwaYy5Z528PraVuWUsU2pJBLoq0c2hgIGirTNn@mail.gmail.com>
In-Reply-To: <AANLkTinwaYy5Z528PraVuWUsU2pJBLoq0c2hgIGirTNn@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2010 02:44 PM, Jeff Chua wrote:
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

The incrementing of ataX is unrelated to anything else...  Each "new" 
ata interface gets a new id.


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

"failed to stop engine" is where the driver is attempting to talk to the 
card, and gracefully shut things down.  If the card does not exist (ie. 
has been removed/ejected), then this is normal behavior.

	Jeff



