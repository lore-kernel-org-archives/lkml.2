Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999Ab0HYEWi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 00:22:38 -0400
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:49208 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751676Ab0HYEWg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 00:22:36 -0400
From: Rasesh Mody <rmody@brocade.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jing Huang <huangj@brocade.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Tue, 24 Aug 2010 21:22:19 -0700
Subject: RE: linux-next: build failure after merge of the final tree (net
 tree related)
Thread-Topic: linux-next: build failure after merge of the final tree (net
 tree related)
Thread-Index: ActD+pC5LFGQUjI1SzC0hCZCo+N9WgAELMuA
Message-ID: <E5313AF6F2BFD14293E5FD0F94750F86A4AE225EE8@HQ1-EXCH01.corp.brocade.com>
References: <20100825120927.c469ce20.sfr@canb.auug.org.au>
In-Reply-To: <20100825120927.c469ce20.sfr@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.0.10011,1.0.148,0.0.0000
 definitions=2010-08-25_02:2010-08-25,2010-08-24,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 phishscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=6.0.2-1004200000 definitions=main-1008240235
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All,

We are working on a fix and we will submit a patch soon.

Regards,
Rasesh

-----Original Message-----
From: Stephen Rothwell [mailto:sfr@canb.auug.org.au] 
Sent: Tuesday, August 24, 2010 7:09 PM
To: David Miller; netdev@vger.kernel.org
Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Rasesh Mody; Jing Huang; James Bottomley
Subject: linux-next: build failure after merge of the final tree (net tree related)

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/net/built-in.o: In function `bfa_ioc_is_operational':
(.opd+0x1c6c8): multiple definition of `bfa_ioc_is_operational'
drivers/scsi/built-in.o:(.opd+0x1b1b0): first defined here

and many more ...

Caused by commit 8b230ed8ec96c933047dd0625cf95f739e4939a6 ("bna: Brocade 10Gb Ethernet device driver") interacting with commit a whole series of patches to do with the Brocade BFA FC SCSI driver that are in Linus' tree stretching back to v2.6.32-rc2.

I have reverted that net tree commit (and commit
f04b4dd2b1f533cef0507e0410ffc6732d21a272 ("bna: Delete get_flags and set_flags ethtool methods") that depends on it).

--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
