Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab1I1NDs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 09:03:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57058 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504Ab1I1NDr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 09:03:47 -0400
Subject: Re: [PATCH] PREEMPT_RT_FULL: arm coredump fails for cpu >= 4
From: Peter Zijlstra <peterz@infradead.org>
To: frank.rowand@am.sony.com
Cc: "tglx@linutronix.de" <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Date: Wed, 28 Sep 2011 15:03:13 +0200
In-Reply-To: <4E828E35.6070801@am.sony.com>
References: <4E828E35.6070801@am.sony.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317214993.24040.16.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-27 at 20:02 -0700, Frank Rowand wrote:
> 
> ARM can not use SPLIT_PTLOCK_CPUS if PREEMPT_RT_FULL because
> vectors_user_mapping() creates a VM_ALWAYSDUMP mapping of the vector page,
> but no ptl->lock has been allocated for the page.  An attempt to coredump
> that page will result in a kernel NULL pointer dereference when
> follow_page() attempts to lock the page.


> 
> This patch is needed only if mm-shrink-the-page-frame-to-rt-size.patch is
> applied. 

Yeah, vile hackery that is.. why isn't pgtable_page_ctor() called on
those pages?

Not that I care too much about split_pte_lock on ARM, they're mostly all
tiny machines anyway so the gain is marginal, but it would be good to
find out why the pgtable constructor isn't called properly.
