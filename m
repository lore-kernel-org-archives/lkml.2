Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab1G1BVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 21:21:31 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39725 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863Ab1G1BVZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 21:21:25 -0400
MIME-Version: 1.0
In-Reply-To: <4E302299.2070309@lwfinger.net>
References: <CAMzZzFGqPv6Nbw8J8JGNKcLA76sAs3oD6+hH9NPCjwA33fYpOQ@mail.gmail.com>
	<CAMzZzFGpDiFAhsLAb+SQxjbGMzBoOStF_Lr7Eb3PT6Drcf=VdA@mail.gmail.com>
	<4E302299.2070309@lwfinger.net>
Date: Thu, 28 Jul 2011 09:21:23 +0800
Message-ID: <CAMzZzFHoQV9wo31sbEMUOv-OQZE1p1WfT8WMGnKJVjNHKvLmQw@mail.gmail.com>
Subject: Re: Oops when insmod rtl8192ce
From: hubert Liao <liao.hubertt@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/27 Larry Finger <Larry.Finger@lwfinger.net>:
> On 07/27/2011 04:26 AM, hubert Liao wrote:
>>
>> Hi,
>> We got an oops when insmod rtl8192ce module (the board is an ARM soc),
>> accroding the oops message, find it's because in rtl_pci_probe()
>> called _rtl_pci_find_adapter(),
>> in this funcation, the  pdev->bus->self is a NULL pointer .
>> static boot _rtl_pci_find_adapter(strcut pci_dev *dev,
>>               struct ieee80211_hw *hw)
>> {
>> struct pci_dev *bridge_pdev = pdev->bus->self;   //line 1601
>> ...
>> pcipriv->ndis_adapter.pcibridge_vendorid = bridge_pdev->vendor;<--
>> [oops here] line 1700
>> ...
>> }
>> here, I just want to know why the bus->self  is NULL?
>> ----
>> [  148.186632] Unable to handle kernel NULL pointer dereference at
>> virtual address 00000020
>
> As John Linville suggested, please open a bugzilla report.
>
Ok, I'll try it, but I am not familiar with it.
> I would also like some additional information. What kernel are you using? In
> addition, please post the 'lspci -nnk' information for your card.
>
The kernel is from the latest linus kernel git tree(3.0.0-05684-ge371d46-dirty),
I also have tested the 2.6.38.8 stable release, it has the same problem.

lspci -nnk
00:00.0 Class [0580]: Device [11ab:6192] (rev 03)
        Subsystem: Device [11ab:11ab]
00:01.0 Class [0280]: Device [10ec:8178] (rev 01)
        Subsystem: Device [1a3b:1178]

> I also think that pdev->bus should have been setup before the initialization
> code in rtl8192ce was called. I have not tested the driver on other than x86
> and x86_64 architectures because of hardware availability, thus ARM may
> expose some problems. Is this soc little-endian?
>
Yes ,it is little-endian

cat /proc/cpuinfo
Processor       : Feroceon 88FR131 rev 1 (v5l)
BogoMIPS        : 789.70
Features        : swp half thumb fastmult edsp
CPU implementer : 0x56
CPU architecture: 5TE
CPU variant     : 0x2
CPU part        : 0x131
CPU revision    : 1

Hardware        : Marvell RD-88F6192-NAS Development Board
Revision        : 0000
Serial          : 0000000000000000

> Thanks,
> Larry
>
>
