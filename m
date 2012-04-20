Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab2DTQWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 12:22:20 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:33451 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab2DTQWS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 12:22:18 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Don Zickus <dzickus@redhat.com>, "x86@kernel.org" <x86@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "thomas.mingarelli@hp.com" <thomas.mingarelli@hp.com>
Date: Fri, 20 Apr 2012 12:17:57 -0400
Subject: RE: [PATCH 0/3] x86, nmi: Fixes
Thread-Topic: [PATCH 0/3] x86, nmi: Fixes
Thread-Index: Ac0N6LujZIWCulIGQc25BMdAfRNmqARJ1m3g
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2E4BF2FD12@USINDEVS01.corp.hds.com>
References: <1333051877-15755-1-git-send-email-dzickus@redhat.com>
In-Reply-To: <1333051877-15755-1-git-send-email-dzickus@redhat.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=7 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1204200157
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I tested this patch by making kernel panic with NMI switch and confirmed that it works well.
This patch solves an issue I found in 3.3.0-rc5 because kzalloc in register_nmi_handler() is removed.

https://lkml.org/lkml/2012/3/2/356

Tested-by: Seiji Aguchi <seiji.aguchi@hds.com>

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Don Zickus
> Sent: Thursday, March 29, 2012 4:11 PM
> To: x86@kernel.org
> Cc: LKML; Peter Zijlstra; thomas.mingarelli@hp.com; Don Zickus
> Subject: [PATCH 0/3] x86, nmi: Fixes
> 
> The patch series started with fixes for kmemcheck but slowly involved the fixing hpwdt.  Hopefully everything is ok for now.
> 
> Don Zickus (2):
>   watchdog, hpwdt: Remove priority option for NMI callback
>   x86, nmi: Add new NMI queues to deal with IO_CHK and SERR
> 
> Li Zhong (1):
>   x86,nmi: Fix page faults by nmiaction if kmemcheck is enabled
> 
>  arch/x86/include/asm/nmi.h |   22 ++++++++++-
>  arch/x86/kernel/nmi.c      |   83 +++++++++++++-------------------------------
>  drivers/watchdog/hpwdt.c   |   46 +++++++++++++------------
>  3 files changed, 68 insertions(+), 83 deletions(-)
> 
> --
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in the body of a message to majordomo@vger.kernel.org More
> majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
