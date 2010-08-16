Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139Ab0HPQtO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 12:49:14 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33582 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821Ab0HPQtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 12:49:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=itUWBPGdwAcLi/LQG515Hqg7hLvX2utetLrke6n+f4NDt4RyZ+qQ5o1BgyXx9ei9pB
         RPD4fV666sIKdxcGqXlOxfsNv06Pn+Px1h+9VsHNACeWZQXGJzBiNaW98QNE45NbQpAp
         eLfSt7+CE0Nn52A8uDbgEmZtSygFZJoe69+ns=
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Andreas <andihartmann@01019freenet.de>
Subject: Re: [rt2x00-users] rt61pci - bad performance
Date: Mon, 16 Aug 2010 18:48:25 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.5.0; x86_64; ; )
Cc: Ivo Van Doorn <ivdoorn@gmail.com>,
        "Kernel-Mailingliste" <linux-kernel@vger.kernel.org>,
        users@rt2x00.serialmonkey.com
References: <ffaPE-58l-5@gated-at.bofh.it> <AANLkTin-_QX+ioguFYX49VyJKie5qAZdm2aEpiCaoQ3O@mail.gmail.com> <4C696858.5030908@01019freenet.de>
In-Reply-To: <4C696858.5030908@01019freenet.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201008161848.25691.helmut.schaa@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Monday 16 August 2010 schrieb Andreas:
> Ivo Van Doorn wrote:
> >>>> hw crypto should be enabled by default in rt61pci, however, I don't know
> >>>> if it is actually working ;)
> >>>
> >>> How can I see if it's working?
> >>
> >> You can add a printk to rt61pci_fill_rxdone, something like:
> >>
> >> diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
> >> index e539c6c..aa1aafd 100644
> >> --- a/drivers/net/wireless/rt2x00/rt61pci.c
> >> +++ b/drivers/net/wireless/rt2x00/rt61pci.c
> >> @@ -2023,6 +2023,7 @@ static void rt61pci_fill_rxdone(struct queue_entry *entry,
> >>                         rxdesc->flags |= RX_FLAG_DECRYPTED;
> >>                 else if (rxdesc->cipher_status == RX_CRYPTO_FAIL_MIC)
> >>                         rxdesc->flags |= RX_FLAG_MMIC_ERROR;
> >> +               printk(KERN_INFO "rt61pci_fill_rxdone: %x\n", rxdesc->cipher_status);
> >>         }
> >>
> >>         /*
> >
> > Actually check debugfs:
> >
> > /sys/kernel/debug/ieee80211/phy0/rt61pci/queue/crypto
> >
> > for the statistics for cryptography.
> >
> > Ivo
> 
> Well, this path doesn't exist - even the crypto-file can't be found.
> 
> lsmod | grep rt61
> rt61pci                19584  0
> rt2x00pci               5646  1 rt61pci
> rt2x00lib              31738  2 rt61pci,rt2x00pci
> eeprom_93cx6            1429  1 rt61pci
> crc_itu_t               1435  2 rt61pci,firewire_core
> 
> notebook1:/sys/kernel/debug/ieee80211/phy0 # find -name crypto
> notebook1:/sys/kernel/debug/ieee80211/phy0 #
> 
> notebook1:/sys/kernel/debug/ieee80211/phy0 # mount | grep debugfs
> debugfs on /sys/kernel/debug type debugfs (rw)
> 
> 
> The debug message gave tons of:
> Aug 16 18:11:47 .... kernel: [ 3435.535149] rt61pci_fill_rxdone: 0
> Aug 16 18:11:47 .... kernel: [ 3435.536335] rt61pci_fill_rxdone: 0
> Aug 16 18:11:47 .... kernel: [ 3435.537049] rt61pci_fill_rxdone: 0
> Aug 16 18:11:47 .... kernel: [ 3435.537697] rt61pci_fill_rxdone: 0
> Aug 16 18:11:47 .... kernel: [ 3435.538595] rt61pci_fill_rxdone: 0
> Aug 16 18:11:47 .... kernel: [ 3435.543566] rt61pci_fill_rxdone: 0
> Aug 16 18:11:47 .... kernel: [ 3435.545187] rt61pci_fill_rxdone: 0
> Aug 16 18:11:47 .... kernel: [ 3435.546837] rt61pci_fill_rxdone: 0
> Aug 16 18:11:47 .... kernel: [ 3435.547031] rt61pci_fill_rxdone: 0
> 

Good, looks like hw crypto is working then ...

Helmut
