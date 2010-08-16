Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103Ab0HPQgq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 12:36:46 -0400
Received: from mx0.vr-web.de ([195.200.35.198]:35022 "EHLO mx0.vr-web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754989Ab0HPQgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 12:36:41 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Aug 2010 12:36:41 EDT
Message-ID: <4C696858.5030908@01019freenet.de>
Date: Mon, 16 Aug 2010 18:33:28 +0200
From: Andreas <andihartmann@01019freenet.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.3a6pre) Gecko/20100803 SeaMonkey/2.1a2
MIME-Version: 1.0
To: Ivo Van Doorn <ivdoorn@gmail.com>,
        Kernel-Mailingliste <linux-kernel@vger.kernel.org>,
        users@rt2x00.serialmonkey.com,
        Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: [rt2x00-users] rt61pci - bad performance
References: <ffaPE-58l-5@gated-at.bofh.it> <fgXXY-KJ-1@gated-at.bofh.it> <4C6659F5.9080706@01019freenet.de> <201008160901.57487.helmut.schaa@googlemail.com> <AANLkTin-_QX+ioguFYX49VyJKie5qAZdm2aEpiCaoQ3O@mail.gmail.com>
In-Reply-To: <AANLkTin-_QX+ioguFYX49VyJKie5qAZdm2aEpiCaoQ3O@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-BitDefender-Scanner: Clean, Agent: BitDefender Courier 3.0.2 on
 vrwf103, sigver: 7.28621
X-BitDefender-CF-Stamp: none
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ivo Van Doorn wrote:
>>>> hw crypto should be enabled by default in rt61pci, however, I don't know
>>>> if it is actually working ;)
>>>
>>> How can I see if it's working?
>>
>> You can add a printk to rt61pci_fill_rxdone, something like:
>>
>> diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
>> index e539c6c..aa1aafd 100644
>> --- a/drivers/net/wireless/rt2x00/rt61pci.c
>> +++ b/drivers/net/wireless/rt2x00/rt61pci.c
>> @@ -2023,6 +2023,7 @@ static void rt61pci_fill_rxdone(struct queue_entry *entry,
>>                         rxdesc->flags |= RX_FLAG_DECRYPTED;
>>                 else if (rxdesc->cipher_status == RX_CRYPTO_FAIL_MIC)
>>                         rxdesc->flags |= RX_FLAG_MMIC_ERROR;
>> +               printk(KERN_INFO "rt61pci_fill_rxdone: %x\n", rxdesc->cipher_status);
>>         }
>>
>>         /*
>
> Actually check debugfs:
>
> /sys/kernel/debug/ieee80211/phy0/rt61pci/queue/crypto
>
> for the statistics for cryptography.
>
> Ivo

Well, this path doesn't exist - even the crypto-file can't be found.

lsmod | grep rt61
rt61pci                19584  0
rt2x00pci               5646  1 rt61pci
rt2x00lib              31738  2 rt61pci,rt2x00pci
eeprom_93cx6            1429  1 rt61pci
crc_itu_t               1435  2 rt61pci,firewire_core

notebook1:/sys/kernel/debug/ieee80211/phy0 # find -name crypto
notebook1:/sys/kernel/debug/ieee80211/phy0 #

notebook1:/sys/kernel/debug/ieee80211/phy0 # mount | grep debugfs
debugfs on /sys/kernel/debug type debugfs (rw)


The debug message gave tons of:
Aug 16 18:11:47 .... kernel: [ 3435.535149] rt61pci_fill_rxdone: 0
Aug 16 18:11:47 .... kernel: [ 3435.536335] rt61pci_fill_rxdone: 0
Aug 16 18:11:47 .... kernel: [ 3435.537049] rt61pci_fill_rxdone: 0
Aug 16 18:11:47 .... kernel: [ 3435.537697] rt61pci_fill_rxdone: 0
Aug 16 18:11:47 .... kernel: [ 3435.538595] rt61pci_fill_rxdone: 0
Aug 16 18:11:47 .... kernel: [ 3435.543566] rt61pci_fill_rxdone: 0
Aug 16 18:11:47 .... kernel: [ 3435.545187] rt61pci_fill_rxdone: 0
Aug 16 18:11:47 .... kernel: [ 3435.546837] rt61pci_fill_rxdone: 0
Aug 16 18:11:47 .... kernel: [ 3435.547031] rt61pci_fill_rxdone: 0



Kind regards,
Andreas
