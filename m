Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab1LISVk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 13:21:40 -0500
Received: from mga03.intel.com ([143.182.124.21]:8933 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426Ab1LISVj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 13:21:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="84094463"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>, LKML <linux-kernel@vger.kernel.org>
CC: X86-ML <x86@kernel.org>, EDAC devel <linux-edac@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Date: Fri, 9 Dec 2011 10:19:02 -0800
Subject: RE: [PATCH 2/2] x86, MCE: Drain mcelog buffer
Thread-Topic: [PATCH 2/2] x86, MCE: Drain mcelog buffer
Thread-Index: Acy1svaa/a28vz7sSRaovNJkt9mUwAA6we7A
Message-ID: <0207C53569FE594381A4F2EB66570B2A018EFB7762@orsmsx508.amr.corp.intel.com>
References: <1323353332-5671-1-git-send-email-bp@amd64.org>
 <1323353332-5671-3-git-send-email-bp@amd64.org>
In-Reply-To: <1323353332-5671-3-git-send-email-bp@amd64.org>
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

void mce_register_decode_chain(struct notifier_block *nb)
 {
 	atomic_notifier_chain_register(&x86_mce_decoder_chain, nb);
+	drain_mcelog_buffer();
 }

Won't this dump all the pended stuff to the *first* guy to
register - but subsequent interested parties will still
miss out?

If so, then we might care who gets here first.

-Tony
