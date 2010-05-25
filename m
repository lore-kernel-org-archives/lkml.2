Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759082Ab0EYWT2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 18:19:28 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:40377 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758780Ab0EYWT1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 18:19:27 -0400
From: "Altobelli, David" <david.altobelli@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Prarit Bhargava <prarit@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>,
       "tony.camuso@redhat.com" <tony.camuso@redhat.com>
Date: Tue, 25 May 2010 22:16:10 +0000
Subject: RE: [PATCH]: hpilo: fix pointer warning in ilo_ccb_setup
Thread-Topic: [PATCH]: hpilo: fix pointer warning in ilo_ccb_setup
Thread-Index: Acr8VC4K6q7Ns5JLT4CUGmRMLKe/ZwAAl75Q
Message-ID: <92D64232F2316045B18937D5C9996B152CD6C5BA90@GVW1144EXB.americas.hpqcorp.net>
References: <20100522004615.25451.83108.sendpatchset@prarit.bos.redhat.com>
 <20100525144937.e0726ec2.akpm@linux-foundation.org>
In-Reply-To: <20100525144937.e0726ec2.akpm@linux-foundation.org>
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

> Seems very wrong - writes to *dmp_pa will now scribble over 
> the `struct ccb_data'.

Yeah.  The dma_pa variable is used to track the physical 
address of the DMA memory, and it is written to the device.  
We don't want a kernel pointer, we want the actual physical addr,
plus the various offsets.

> Probably local variable dma_pa should have type dma_addr_t.

I feel like I tried that, and I had trouble setting or using
the send_fifobar/recv_fifobar variables.  But I probably
didn't try too hard.
