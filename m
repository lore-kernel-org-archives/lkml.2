Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180Ab3AIQNJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 11:13:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932099Ab3AIQNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 11:13:08 -0500
Date: Wed, 9 Jan 2013 17:12:22 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Arapov <anton@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [RFC PATCH v2 0/4] uprobes: return probe implementation
Message-ID: <20130109161222.GA27722@redhat.com>
References: <1357730692-3928-1-git-send-email-anton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357730692-3928-1-git-send-email-anton@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09, Anton Arapov wrote:
>
> There are RFC uretprobes implementation. I'd be grateful for review.
>
>   RFCv1: https://lkml.org/lkml/2012/12/21/133
>
> I've intentionally removed the retprobe bypass logic, it requires
> a bit more work.

Yes, this is not trivial, lets do this separately.

> not fixed since last prior RFC review:
>   unify xol_get_trampoline_slot() and xol_take_insn_slot()

This was of the reasons for "Do not play with utask in xol_get_insn_slot()"
I sent. After this patch you only need the trivial change

	- static unsigned long xol_get_insn_slot(struct uprobe *uprobe)
	+ static unsigned long xol_get_insn_slot(unsigned char *insn)

and now you do not need xol_get_trampoline_slot().

However. Why do you need it at all? Let me quote myself:

	Or. Perhaps even better, do not add this helper at all. xol_alloc_area()
	could reserve the first slot/bit for trampoline. And note that in this
	case we do not need xol_area->rp_trampoline_vaddr, it is always equal
	to xol_area->vaddr.

?

>   protect uprobe in prepare_uretprobe()

This should be fixed ;)

Oleg.

