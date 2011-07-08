Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab1GHVkR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 17:40:17 -0400
Received: from mga14.intel.com ([143.182.124.37]:15662 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879Ab1GHVkP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 17:40:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,500,1304319600"; 
   d="scan'208";a="24641727"
From: "Luck, Tony" <tony.luck@intel.com>
To: Don Zickus <dzickus@redhat.com>
CC: "mjg@redhat.com" <mjg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 8 Jul 2011 14:40:13 -0700
Subject: RE: pstore dump inside an nmi handler
Thread-Topic: pstore dump inside an nmi handler
Thread-Index: Acw9rBXDiGiC30MwTJ2hO8DqN/oo0AACv7ZA
Message-ID: <987664A83D2D224EAE907B061CE93D5301E981AB56@orsmsx505.amr.corp.intel.com>
References: <20110708201731.GA3025@redhat.com>
In-Reply-To: <20110708201731.GA3025@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Inside pstore_dump(), the first thing it tries to grab is a mutex_lock()
> (inside an nmi hander).  This seems to be the root cause of my problems.

Someone else pointed out that mutex_lock() is a problem here too. They
wondered whether spin_lock_irqsave() would work - or whether pstore
backends were allowed to sleep - to which I said I hoped they didn't,
but wasn't really sure what the future will hold.

So ... ideas (and patches) are most welcome.

-Tony


