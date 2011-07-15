Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965401Ab1GOKfO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 06:35:14 -0400
Received: from mx0.aculab.com ([213.249.233.131]:47436 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S964982Ab1GOKfN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 06:35:13 -0400
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 0/1] Fixup write permission of TLB on powerpc e500 core
Date: Fri, 15 Jul 2011 11:32:49 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6D8ADFC@saturn3.aculab.com>
In-Reply-To: <4E20112C.6040307@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [PATCH 0/1] Fixup write permission of TLB on powerpc e500 core
thread-index: AcxC1mm3J8eSDvXyRACJfi3E1OX13AAA2Cfw
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Shan Hai" <haishan.bai@gmail.com>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Cc: <tony.luck@intel.com>, <linux-kernel@vger.kernel.org>,
        <cmetcalf@tilera.com>, <dhowells@redhat.com>, <paulus@samba.org>,
        <tglx@linutronix.de>, <walken@google.com>,
        <linuxppc-dev@lists.ozlabs.org>, <akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> The fault causing futex_atomic_cmpxchg_inatomic() is
> protected by pagefault_disable(), so the page fault handler has
> no chance to toggle the SW dirty/young tracking.

Perhaps that is the bug!
Whatever pagefault_disable() does, it shouldn't disable the
SW dirty/young tracking - which should only needs bits moving
in the page table itself (and TLB update??) rather than any
operations on the rest of the data areas.

It looks to me as though this could happen any time a page
is marked inaccessible by the dirty/young tracking.
Not just as a result of COW.

	David


