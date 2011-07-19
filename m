Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab1GSI27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 04:28:59 -0400
Received: from mx0.aculab.com ([213.249.233.131]:57834 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752190Ab1GSI25 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 04:28:57 -0400
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [RFC/PATCH] mm/futex: Fix futex writes on archs with SW trackingof dirty & young
Date: Tue, 19 Jul 2011 09:26:35 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6D8ADFF@saturn3.aculab.com>
In-Reply-To: <4E253F40.2010104@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [RFC/PATCH] mm/futex: Fix futex writes on archs with SW trackingof dirty & young
thread-index: AcxF7Kw+G1LNYN0XQJaOW+WeDbVWRwAAFR/g
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Shan Hai" <haishan.bai@gmail.com>,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>
Cc: <tony.luck@intel.com>, "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        "Peter Zijlstra" <peterz@infradead.org>,
        <linux-kernel@vger.kernel.org>, <cmetcalf@tilera.com>,
        <dhowells@redhat.com>, <paulus@samba.org>, <tglx@linutronix.de>,
        <walken@google.com>, <linuxppc-dev@lists.ozlabs.org>,
        <akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> Got it, if the fault_in_user_writeable() is designed to catch the
> exact same write permission fault problem we discuss here, so
> your patch fixed that very nicely, we should fixup it by directly
> calling handle_mm_fault like what you did because we are for sure
> to know what just happened(permission violation), its not necessary
> to check what's happened by calling gup-->follow_page, and
> further the follow_page failed to report the fault :-)

One thought I've had - and I don't know enough about the data
area in use to know if it is a problem - is what happens if
a different cpu faults on the same user page and has already
marked it 'valid' between the fault happening and the fault
handler looking at the page tables to find out why.
If any of the memory areas are shared, it might be that the
PTE (etc) might already show the page a writable by the
time the fault handler is looking at them - this might confuse it!

	David


