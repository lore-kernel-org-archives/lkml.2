Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab1F0WfK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 18:35:10 -0400
Received: from lucidpixels.com ([72.73.18.11]:54681 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755211Ab1F0Wem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 18:34:42 -0400
Date: Mon, 27 Jun 2011 18:34:41 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: "Ronciak, John" <john.ronciak@intel.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Subject: RE: [E1000-devel] 2.6.39.2: skb_over_panic: kernel BUG at
 net/core/skbuff.c:127!
In-Reply-To: <D38E8E86660E514AB505863C19C9287C03A585@ORSMSX101.amr.corp.intel.com>
Message-ID: <alpine.DEB.2.02.1106271831060.6721@p34.internal.lan>
References: <alpine.DEB.2.02.1106271742310.6721@p34.internal.lan> <D38E8E86660E514AB505863C19C9287C03A525@ORSMSX101.amr.corp.intel.com> <alpine.DEB.2.02.1106271814200.6721@p34.internal.lan>
 <D38E8E86660E514AB505863C19C9287C03A585@ORSMSX101.amr.corp.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 27 Jun 2011, Ronciak, John wrote:

>> Hello John,
>> Justin.
> You still didn't tell us what eth interface is on which HW.  We need to know that.  Do an 'ethtool -i eth2' and the same for each of the other interfaces in the system.  The igb driver that is used on the NIC described above is in high use without people reporting this error.
>
> Cheers,
> John

Sorry,

eth0 = e1000e (on-board (on an Intel DP55KG))
eth{1,2,3,4} = igb (the 4-port NIC I mentioned)
eth5 = ixgbe (the 10GbE AT2 server board (copper))

--

[    2.301687] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) hidden:mac
[    2.301878] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    2.302162] e1000e 0000:00:19.0: eth0: MAC: 9, PHY: 9, PBA No: FFFFFF-0FF

[    2.350085] igb 0000:03:00.0: eth1: (PCIe:2.5Gb/s:Width x4) hidden:mac
[    2.350351] igb 0000:03:00.0: eth1: PBA No: E84075-002
[    2.400381] igb 0000:03:00.1: eth2: (PCIe:2.5Gb/s:Width x4) hidden:mac
[    2.400486] igb 0000:03:00.1: eth2: PBA No: E84075-002
[    2.448103] igb 0000:03:00.2: eth3: (PCIe:2.5Gb/s:Width x4) hidden:mac
[    2.448391] igb 0000:03:00.2: eth3: PBA No: E84075-002
[    2.496095] igb 0000:03:00.3: eth4: (PCIe:2.5Gb/s:Width x4) hidden:mac
[    2.496377] igb 0000:03:00.3: eth4: PBA No: E84075-002

[   38.916123] ixgbe 0000:01:00.0: eth5: NIC Link is Up 10 Gbps, Flow Control: RX/TX

--

ethtool output as requested:

driver: e1000e
version: 1.3.10-k2
firmware-version: 0.12-5
bus-info: 0000:00:19.0
supports-statistics: yes
supports-test: yes
supports-eeprom-access: yes
supports-register-dump: yes

ethtool -I eth1
driver: igb
version: 3.0.6-k2
firmware-version: 3.19-0
bus-info: 0000:03:00.3
supports-statistics: yes
supports-test: yes
supports-eeprom-access: yes
supports-register-dump: yes

ethtool -I eth2
driver: igb
version: 3.0.6-k2
firmware-version: 3.19-0
bus-info: 0000:03:00.2
supports-statistics: yes
supports-test: yes
supports-eeprom-access: yes
supports-register-dump: yes

ethtool -I eth3
driver: igb
version: 3.0.6-k2
firmware-version: 3.19-0
bus-info: 0000:03:00.1
supports-statistics: yes
supports-test: yes
supports-eeprom-access: yes
supports-register-dump: yes

ethtool -I eth4
driver: igb
version: 3.0.6-k2
firmware-version: 3.19-0
bus-info: 0000:03:00.0
supports-statistics: yes
supports-test: yes
supports-eeprom-access: yes
supports-register-dump: yes

ethtool -I eth5
driver: ixgbe
version: 3.2.9-k2
firmware-version: 2.9-0
bus-info: 0000:01:00.0
supports-statistics: yes
supports-test: yes
supports-eeprom-access: yes
supports-register-dump: yes

Justin.



