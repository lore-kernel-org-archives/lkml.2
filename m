Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161368Ab2GLQlJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 12:41:09 -0400
Received: from mga12.intel.com ([143.182.124.36]:26923 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161336Ab2GLQlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 12:41:05 -0400
MIME-Version: 1.0
In-Reply-To: <1342086988.4091.44.camel@ThinkPad-T420>
References: <1341817465.4579.5.camel@ThinkPad-T420>
	<20120711154232.165cbca9.akpm@linux-foundation.org>
	<CABE8wwsqyo=BPCy4xy1PAVKFWe=GqYRdYowXkQ6UZoXdtEdCZA@mail.gmail.com>
	<1342086988.4091.44.camel@ThinkPad-T420>
Date: Thu, 12 Jul 2012 09:41:02 -0700
Message-ID: <CABE8wws27XooqGaZCbiqhykP1jP99eUE0=DKV6Lc2sha0sWK0A@mail.gmail.com>
Subject: Re: [PATCH RESEND] Fix a dead loop in async_synchronize_full()
From: Dan Williams <dan.j.williams@intel.com>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, arjan@linux.intel.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Christian Kujau <lists@nerdbynature.de>,
        Cong Wang <xiyou.wangcong@gmail.com>, JBottomley@parallels.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ adding James ]

On Thu, Jul 12, 2012 at 2:56 AM, Li Zhong <zhong@linux.vnet.ibm.com> wrote:
> I have tested your pending patches, they fix the problem here.

Thanks!

James, if you get the chance please add:

Tested-by: Li Zhong <zhong@linux.vnet.ibm.com>

...to the pending set, or I can just resend.  Let me know.

> But with ASYNC_DOMAIN_EXCLUSIVE added for the domains defined on the
> stack, I think we lack a function that could wait for all the works in
> all domains (however, maybe actually we don't need such an interface).
>
> Also, I think it's not good to exclude them from
> async_synchronize_full() just because they are defined on the stack.

ASYNC_DOMAIN can be used to allow on-stack domains to be flushed via
async_synchronize_full().  However, if you know ahead of time that
your work items do not need to be anonymously flushed and you know the
lifetime of your domain ASYNC_DOMAIN_EXCLUSIVE +
async_synchronize_full_domain() are there to prevent unnecessary
entanglements.

If for some reason you want to have temporary on stack domains be
globally visible I included an async_unregister_domain() routine to
make the api complete.  It has a comment that using
ASYNC_DOMAIN_EXCLUSIVE for such domains is preferred.

--
Dan
