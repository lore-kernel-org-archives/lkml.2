Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab1DRMdJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 08:33:09 -0400
Received: from cantor.suse.de ([195.135.220.2]:51107 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753062Ab1DRMdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 08:33:02 -0400
Date: Mon, 18 Apr 2011 22:32:51 +1000
From: NeilBrown <neilb@suse.de>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 12/12] mm: Throttle direct reclaimers if PF_MEMALLOC
 reserves are low and swap is backed by network storage
Message-ID: <20110418223251.7ab148bb@notabene.brown>
In-Reply-To: <1302777698-28237-13-git-send-email-mgorman@suse.de>
References: <1302777698-28237-1-git-send-email-mgorman@suse.de>
	<1302777698-28237-13-git-send-email-mgorman@suse.de>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Apr 2011 11:41:38 +0100 Mel Gorman <mgorman@suse.de> wrote:

> If swap is backed by network storage such as NBD, there is a risk that a
> large number of reclaimers can hang the system by consuming all
> PF_MEMALLOC reserves. To avoid these hangs, the administrator must tune
> min_free_kbytes in advance. This patch will throttle direct reclaimers
> if half the PF_MEMALLOC reserves are in use as the system is at risk of
> hanging. A message will be displayed so the administrator knows that
> min_free_kbytes should be tuned to a higher value to avoid the
> throttling in the future.
> 

(I knew there was something else).

I understand that there are suggestions that direct reclaim should always be
serialised as this reduces lock contention and improve data patterns (or
something like that).

Would that make this patch redundant?  Or does this provide some extra
guarantee that the other proposal would not?

Thanks again,

NeilBrown

