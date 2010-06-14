Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594Ab0FNVRe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 17:17:34 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:48290 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756468Ab0FNVRd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 17:17:33 -0400
From: "Altobelli, David" <david.altobelli@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Prarit Bhargava <prarit@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>,
       "Camuso, Tony" <Tony.Camuso@hp.com>,
       "dzickus@redhat.com" <dzickus@redhat.com>
Date: Mon, 14 Jun 2010 21:16:34 +0000
Subject: RE: [PATCH]: hpilo: fix pointer warning in ilo_ccb_setup [v2]
Thread-Topic: [PATCH]: hpilo: fix pointer warning in ilo_ccb_setup [v2]
Thread-Index: AcsL91Se1nwD0XcDS2++Qt24hntw1AAClIGg
Message-ID: <92D64232F2316045B18937D5C9996B152CD7EDAE9F@GVW1144EXB.americas.hpqcorp.net>
References: <20100608151923.10554.57721.sendpatchset@prarit.bos.redhat.com>
 <20100614122517.775fc67c.akpm@linux-foundation.org>
In-Reply-To: <20100614122517.775fc67c.akpm@linux-foundation.org>
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

> From Andrew Morton:
> So what's happening here.  As send_fifobar_pa, send_desc_pa,
> recv_fifobar_pa and recv_desc_pa are only ever written to, I assume
> that we're writing a 64-bit value and then reading it back via the
> 32-bit value which shares the same storage.

The physical addresses are used to fill out a structure defined 
by iLO firmware that has 64 bit fields for the various queues or descriptors.
A copy with physical addrs is copied to device memory.  The size of the 
structure matters for the physical copy, which is why those fields need to be u64,
not a variable type like dma_addr_t, or a pointer.
We keep a copy with virtual addresses for use by the kernel.  The size of the 
kernel pointer doesn't really matter, it just tells the driver where to write 
in the shared memory.  Does that answer your question, maybe I missed 
what concerned you?
