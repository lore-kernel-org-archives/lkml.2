Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741Ab2EWJyh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 05:54:37 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:57344 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab2EWJyg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 05:54:36 -0400
MIME-Version: 1.0
In-Reply-To: <20120426211042.GC27486@google.com>
References: <1335339396.16988.80.camel@lappy> <20120426211042.GC27486@google.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Wed, 23 May 2012 11:54:14 +0200
Message-ID: <CA+1xoqff_OQORFm05fCqeZ-vCt+2Y9H0KNfSxrCepfCDNGZgXQ@mail.gmail.com>
Subject: Re: [PATCH block/for-3.5/core] blkcg: tg_stats_alloc_lock is an irq lock
To: Tejun Heo <tj@kernel.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, axboe@kernel.dk,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        paulmck@linux.vnet.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 11:10 PM, Tejun Heo <tj@kernel.org> wrote:
> tg_stats_alloc_lock nests inside queue lock and should always be held
> with irq disabled.  throtl_pd_{init|exit}() were using non-irqsafe
> spinlock ops which triggered inverse lock ordering via irq warning via
> RCU freeing of blkg invoking throtl_pd_exit() w/o disabling IRQ.
>
> Update both functions to use irq safe operations.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Sasha Levin <sasha.levin@oracle.com>
> LKML-Reference: <1335339396.16988.80.camel@lappy>
> ---

I think that this patch got lost somewhere and never got merged into
the for-3.5 branch.
