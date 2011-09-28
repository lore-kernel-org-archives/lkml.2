Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155Ab1I1Szh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 14:55:37 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:32980 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118Ab1I1Szf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 14:55:35 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Don Zickus <dzickus@redhat.com>
CC: "Luck, Tony" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>, Matthew Garrett <mjg@redhat.com>,
        "Chen, Gong" <gong.chen@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Wed, 28 Sep 2011 14:55:16 -0400
Subject: RE: [RFC][PATCH -next] pstore: replace spin_lock with
 spin_trylock_irqsave in panic path
Thread-Topic: [RFC][PATCH -next] pstore: replace spin_lock with
 spin_trylock_irqsave in panic path
Thread-Index: Acx96EHEQqSOWIL5TS2QX3gl7H50ugAJ4Nkw
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C5700CA5D@USINDEVS01.corp.hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C56C9B823@USINDEVS01.corp.hds.com>
 <20110927173413.GJ5795@redhat.com>
 <987664A83D2D224EAE907B061CE93D5301EE4211E3@orsmsx505.amr.corp.intel.com>
 <20110927175919.GK5795@redhat.com>
 <987664A83D2D224EAE907B061CE93D5301EE421365@orsmsx505.amr.corp.intel.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C56C9B8AD@USINDEVS01.corp.hds.com>
 <20110928140933.GR5795@redhat.com>
In-Reply-To: <20110928140933.GR5795@redhat.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1012030000
 definitions=main-1109280222
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Don,

>[reads the kernel/panic.c code] oh, I see this already exists, you would
>just move the smp_send_stop() command up a couple lines of code.
>
>[Side note] perhaps we should change the behaviour of smp_send_stop to use
>NMI and create a blacklist of machines to use the IRQ line instead.  I
>assume the list of broken machines is small as Red Hat has been kdumping
>kernels since 2.6.18 with little evidence that machines were failing
>because NMI wasn't working properly.

OK. I will develop a patch in accordance with your comment above.
In addition to that, I have to improve mtdoops/ramoops because
There are some blocking codes in them.

Seiji
