Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab1GTSHE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 14:07:04 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:5773 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab1GTSHB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 14:07:01 -0400
X-SpamScore: -20
X-BigFish: VPS-20(zz9371M1432N98dK14ffOzz1202hzz8275ch8275bhz2ei2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:198.70.193.64;KIP:(null);UIP:(null);IPVD:NLI;H:avexcashub1.qlogic.com;RD:avexcashub2.qlogic.com;EFVD:NLI
From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, netdev <netdev@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux Driver <Linux-Driver@qlogic.com>,
        David Lamparter <equinox@diac24.net>
Date: Wed, 20 Jul 2011 11:10:18 -0700
Subject: Re: linux-next: Tree for July 20 (qlcnic)
Thread-Topic: linux-next: Tree for July 20 (qlcnic)
Thread-Index: AcxHB89dR5JsjPvAR/G9eq299hBYpQ==
Message-ID: <0E5EAE44-204C-4F4D-926C-F4D973B0CDB1@qlogic.com>
References: <20110720180041.5774ca335e6697c17374dca5@canb.auug.org.au>
 <20110720091945.39f0a8a5.rdunlap@xenotime.net>
In-Reply-To: <20110720091945.39f0a8a5.rdunlap@xenotime.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: qlogic.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 20, 2011, at 9:19 AM, Randy Dunlap wrote:

> On Wed, 20 Jul 2011 18:00:41 +1000 Stephen Rothwell wrote:
> 
>> Hi all,
> 
> When CONFIG_VLAN_8021Q is not enabled:
> 
> drivers/net/qlcnic/qlcnic_main.c:4207: error: 'struct net_device' has no member named 'vlgrp'

This is caused by the following commit:

commit 69ecca86da4890c13a5e29c51b4ac76a1a8a62c9                                                      
Refs: v3.0-rc7-1265-g69ecca8                                                                         
Author:     David Lamparter <equinox@diac24.net>                                                     
AuthorDate: Sun Jul 17 08:53:12 2011 +0000                                                           
Commit:     David S. Miller <davem@davemloft.net>                                                    
CommitDate: Sun Jul 17 12:33:22 2011 -0700                                                           
                                                                                                     
    net: vlan, qlcnic: make vlan_find_dev private                                                    
                                                                                                     
    there is only one user of vlan_find_dev outside of the actual vlan code:                         
    qlcnic uses it to iterate over some VLANs it knows.                                              
                                                                                                     
    let's just make vlan_find_dev private to the VLAN code and have the                              
    iteration in qlcnic be a bit more direct. (a few rcu dereferences less                           
    too)                                                                                             
                                                                                                     
    Signed-off-by: David Lamparter <equinox@diac24.net>                                              
    Cc: Patrick McHardy <kaber@trash.net>                                                            
    Cc: Amit Kumar Salecha <amit.salecha@qlogic.com>                                                 
    Cc: Anirban Chakraborty <anirban.chakraborty@qlogic.com>                                         
    Cc: linux-driver@qlogic.com                                                                      
    Signed-off-by: David S. Miller <davem@davemloft.net>                                             


