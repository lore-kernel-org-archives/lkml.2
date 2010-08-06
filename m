Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866Ab0HFEzO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 00:55:14 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:30707 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab0HFEzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 00:55:09 -0400
Message-ID: <4C5B9469.3080409@kernel.org>
Date: Thu, 05 Aug 2010 21:49:45 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] Networking
References: <20100803.203814.59697285.davem@davemloft.net> 	<AANLkTimxv1y3QJ7s+ghi1FFCcwnUVWT1n6dvT-NNN=Oo@mail.gmail.com> 	<AANLkTinU4+tcm2O_BVBFkHSdnx7JEPtM4sw_s--qdUKC@mail.gmail.com> <AANLkTi=3dVWKtgL2A=4xm_1VSk64--3Zk_fQBYUdAAn+@mail.gmail.com>
In-Reply-To: <AANLkTi=3dVWKtgL2A=4xm_1VSk64--3Zk_fQBYUdAAn+@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4C5B95A2.00FB,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2010 07:15 PM, Linus Torvalds wrote:
> On Thu, Aug 5, 2010 at 7:04 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>
>>  CC      drivers/net/ixgbe/ixgbe_main.o
>> drivers/net/ixgbe/ixgbe_main.c: In function ‘ixgbe_select_queue’:
>> drivers/net/ixgbe/ixgbe_main.c:6159: error: ‘struct ixgbe_fcoe’ has no member named ‘up’
> 
> Hmm. You must have some other version of that file than I do. Line
> 6159 is in ixgbe_init_module() in my source tree.
> 
>                  Linus

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=drivers/net/ixgbe/ixgbe_main.c;h=7d6a415bcf885633999e10ed795df49876d6c47e;hb=HEAD

6146 static u16 ixgbe_select_queue(struct net_device *dev, struct sk_buff *skb)
6147 {
6148         struct ixgbe_adapter *adapter = netdev_priv(dev);
6149         int txq = smp_processor_id();
6150
6151 #ifdef IXGBE_FCOE
6152         if ((skb->protocol == htons(ETH_P_FCOE)) ||
6153             (skb->protocol == htons(ETH_P_FIP))) {
6154                 if (adapter->flags & IXGBE_FLAG_FCOE_ENABLED) {
6155                         txq &= (adapter->ring_feature[RING_F_FCOE].indices - 1);
6156                         txq += adapter->ring_feature[RING_F_FCOE].mask;
6157                         return txq;
6158                 } else if (adapter->flags & IXGBE_FLAG_DCB_ENABLED) {
6159                         txq = adapter->fcoe.up;
6160                         return txq;
6161                 }
6162         }
6163 #endif
