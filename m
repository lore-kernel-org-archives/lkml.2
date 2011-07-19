Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778Ab1GSLK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 07:10:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42387 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab1GSLK5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 07:10:57 -0400
Subject: Re: [RFC/PATCH] mm/futex: Fix futex writes on archs with SW
 tracking of dirty & young
From: Peter Zijlstra <peterz@infradead.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Shan Hai <haishan.bai@gmail.com>, paulus@samba.org, tglx@linutronix.de,
        walken@google.com, dhowells@redhat.com, cmetcalf@tilera.com,
        tony.luck@intel.com, akpm@linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <1311049762.25044.392.camel@pasglop>
References: <1310717238-13857-1-git-send-email-haishan.bai@gmail.com>
	 <1310717238-13857-2-git-send-email-haishan.bai@gmail.com>
	 <1310725418.2586.309.camel@twins> <4E21A526.8010904@gmail.com>
	 <1310860194.25044.17.camel@pasglop>
	 <4b337921-d430-4b63-bc36-ad31753cf800@email.android.com>
	 <1310912990.25044.203.camel@pasglop>  <1310944453.25044.262.camel@pasglop>
	 <1310961691.25044.274.camel@pasglop>  <4E23D728.7090406@gmail.com>
	 <1310972462.25044.292.camel@pasglop>  <4E23E02C.8090401@gmail.com>
	 <1310974591.25044.298.camel@pasglop>  <4E24FA51.70602@gmail.com>
	 <1311049762.25044.392.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 19 Jul 2011 13:10:24 +0200
Message-ID: <1311073824.13765.195.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-19 at 14:29 +1000, Benjamin Herrenschmidt wrote:
> The futex code currently attempts to write to user memory within
> a pagefault disabled section, and if that fails, tries to fix it
> up using get_user_pages().
> 
> This doesn't work on archs where the dirty and young bits are
> maintained by software, since they will gate access permission
> in the TLB, and will not be updated by gup().
> 
> In addition, there's an expectation on some archs that a
> spurious write fault triggers a local TLB flush, and that is
> missing from the picture as well.
> 
> I decided that adding those "features" to gup() would be too much
> for this already too complex function, and instead added a new
> simpler fixup_user_fault() which is essentially a wrapper around
> handle_mm_fault() which the futex code can call.
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org> 

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
