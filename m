Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab0FOMI2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 08:08:28 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:53363 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab0FOMI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 08:08:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ngGS+7xwCcmSE3LbsdEiBhzyFCFTwyAKs4IKeyCzrIuVZh7nsk6tTv3/Wcz9rdol0O
         DjCJP6SU31UEkC/whGJuL9CtMsxOXvHOeb5ZqUve8Nse6lKzHnBhKmdQSb82RJyv4dfS
         cFQ623goMD6QsBzjqJpSYiAcJ6vKtKVt4DfUY=
MIME-Version: 1.0
In-Reply-To: <4C16BFF5.7070308@gmail.com>
References: <AANLkTimnqVSom2qHetXMBPiCNTYd-yc8Tl6a64n0zTSk@mail.gmail.com>
	<20100614162002.GA13902@kroah.com>
	<AANLkTinwaYy5Z528PraVuWUsU2pJBLoq0c2hgIGirTNn@mail.gmail.com>
	<4C16BFF5.7070308@gmail.com>
Date: Tue, 15 Jun 2010 20:08:25 +0800
Message-ID: <AANLkTimp4_TaQuGPlnw9ZpQCoTiTeFxtWQeZgfsdUBnK@mail.gmail.com>
Subject: Re: e-SATA ExpressCard - OOPS plus incrementing "ataX" on 
	Linux-2.6.xx
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Robert Hancock <hancockrwd@gmail.com>, Jeff Garzik <jgarzik@redhat.com>
Cc: Greg KH <greg@kroah.com>, kristen.c.accardi@intel.com,
       Dely Sy <dely.l.sy@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Wilcox <willy@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 7:49 AM, Robert Hancock <hancockrwd@gmail.com> wrote:

> The ataX number incrementing is normal (it always increments when an ATA
> host is initialized, it doesn't appear the numbers get reused). The other
> messages are the expected result when you surprise-remove the card. I think
> there should be a way to trigger the hotplug code to disable the device
> before you eject it, but I'm not sure what that is supposed to be - maybe
> echo 1 to /sys/device/pci_somethingorother/remove ?

Robert,

Thanks for the pointer. I found this "remove" is in
/sys/bus/pci/devices/0000:05:00.0/remove

# echo 1 >/sys/bus/pci/devices/0000:05:00.0/remove

ata14.00: disabled
sd 17:0:0:0: [sdb] Synchronizing SCSI cache
sd 17:0:0:0: [sdb] Result: hostbyte=0x04 driverbyte=0x00
sd 17:0:0:0: [sdb] Stopping disk
sd 17:0:0:0: [sdb] START_STOP FAILED
sd 17:0:0:0: [sdb] Result: hostbyte=0x04 driverbyte=0x00
ahci 0000:05:00.0: PCI INT A disabled


It's getter better. Next is to really shutdown the "sdb" hard disk. Is
that possible? Would be nice to make the "sd 17:0:0:0: [sdb]
START_STOP FAILED" go away gracefully. Any command to do that?


On Tue, Jun 15, 2010 at 9:26 AM, Jeff Garzik <jeff@garzik.org> wrote:

> The incrementing of ataX is unrelated to anything else...  Each "new" ata interface gets a new id.

Jeff,

With the "remove" command working, it'll be nice to make "ahci"
_reuse_ the interface now that it's removed cleanly. I'm just afaid
that each time the card is removed and reinserted, the ataXX interface
kept incrementing and will eventually does harm to the kernel?


> "failed to stop engine" is where the driver is attempting to talk to the card, and gracefully shut things down.  > If the card does not exist (ie. has been removed/ejected), then this is normal behavior.

Ok, that's fixed with "echo 1 >/sys/bus/pci/devices/0000:05:00.0/remove".



Thanks,
Jeff
