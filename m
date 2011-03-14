Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab1CNE7r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 00:59:47 -0400
Received: from mail.solarflare.com ([216.237.3.220]:53647 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab1CNE7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 00:59:46 -0400
Subject: Re: linux-next: build failure after merge of the net tree
From: Ben Hutchings <bhutchings@solarflare.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20110314152456.b49b2693.sfr@canb.auug.org.au>
References: <20110314152456.b49b2693.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Mon, 14 Mar 2011 04:59:38 +0000
Message-ID: <1300078778.3962.22.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Mar 2011 04:59:45.0603 (UTC) FILETIME=[A333F930:01CBE204]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18008.005
X-TM-AS-Result: No--18.513200-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-14 at 15:24 +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the net tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> kernel/irq/manage.c: In function 'irq_affinity_notify':
> kernel/irq/manage.c:182: error: 'struct irq_desc' has no member named 'affinity'
> 
> Caused by commit cd7eab44e994 ("genirq: Add IRQ affinity notifiers")
> (which is also in the tip tree).  I am guessing that there is a fix for
> this also in the tip tree ... yep commit 1fb0ef31f428 ("genirq: Fix
> affinity notifier fallout").
> 
> I tried using the net tree from next-20110311 for today but that had the
> same problem.  So I merged the above fix commit from the tip tree.
> 
> I have no idea why this has suddenly become a problem in the net tree.

Commit cd7eab44e994 ("genirq: Add IRQ affinity notifiers") was a
prerequisite for some changes in networking.  Thomas Gleixner applied it
on a branch of its own so that David Miller could pull just that commit
into net-next-2.6.  Of course, this means net-next-2.6 doesn't have the
later fix (and won't for a while).

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

