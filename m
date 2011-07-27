Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab1G0JAa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 05:00:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47116 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013Ab1G0JA2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 05:00:28 -0400
Subject: Re: [RFC/PATCH] mm/futex: Fix futex writes on archs with SW
 tracking of dirty & young
From: Peter Zijlstra <peterz@infradead.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>, Shan Hai <haishan.bai@gmail.com>,
        paulus@samba.org, tglx@linutronix.de, walken@google.com,
        dhowells@redhat.com, cmetcalf@tilera.com, tony.luck@intel.com,
        akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
In-Reply-To: <1311753513.25044.663.camel@pasglop>
References: <1310717238-13857-1-git-send-email-haishan.bai@gmail.com>
	 <1310717238-13857-2-git-send-email-haishan.bai@gmail.com>
	 <1310725418.2586.309.camel@twins> <4E21A526.8010904@gmail.com>
	 <1310860194.25044.17.camel@pasglop>
	 <4b337921-d430-4b63-bc36-ad31753cf800@email.android.com>
	 <1310912990.25044.203.camel@pasglop> <1310944453.25044.262.camel@pasglop>
	 <1310961691.25044.274.camel@pasglop> <4E23D728.7090406@gmail.com>
	 <1310972462.25044.292.camel@pasglop> <4E23E02C.8090401@gmail.com>
	 <1310974591.25044.298.camel@pasglop> <4E24FA51.70602@gmail.com>
	 <1311049762.25044.392.camel@pasglop>
	 <CAMjpGUdxpaYBFfKjBEPFOJohnKoXfagLUHvhrst+NembeabxcA@mail.gmail.com>
	 <1311753513.25044.663.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 27 Jul 2011 10:59:50 +0200
Message-ID: <1311757190.24752.406.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-27 at 17:58 +1000, Benjamin Herrenschmidt wrote:

> What should nommu do anyways ? it's not like there's much it can do
> right ? It should never even hit the fault path to start with ...

Something like the below makes a nommu arm config build.. David, is this
indeed the correct thing to do for nommu?

---
Index: linux-2.6/mm/nommu.c
===================================================================
--- linux-2.6.orig/mm/nommu.c
+++ linux-2.6/mm/nommu.c
@@ -190,6 +190,12 @@ int get_user_pages(struct task_struct *t
 }
 EXPORT_SYMBOL(get_user_pages);
 
+int fixup_user_fault(struct task_struct *tsk, struct mm_struct *mm,
+		     unsigned long address, unsigned int fault_flags)
+{
+	BUG(); /* nommu should never call this */
+}
+
 /**
  * follow_pfn - look up PFN at a user virtual address
  * @vma: memory mapping

