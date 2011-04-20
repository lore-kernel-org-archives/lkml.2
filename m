Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794Ab1DTTcI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 15:32:08 -0400
Received: from pqueuea.post.tele.dk ([193.162.153.9]:38840 "EHLO
	pqueuea.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768Ab1DTTcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 15:32:06 -0400
Date: Wed, 20 Apr 2011 21:31:45 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc: stop exporting irq_map
Message-ID: <20110420193145.GA15439@merkur.ravnborg.org>
References: <20110420084449.23741.45580.stgit@ponder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110420084449.23741.45580.stgit@ponder>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +
>  irq_hw_number_t virq_to_hw(unsigned int virq)
>  {
>  	return irq_map[virq].hwirq;
>  }
>  EXPORT_SYMBOL_GPL(virq_to_hw);

General comment...
kernel/irq/* denote the virtual irq numbers "irq".
powerpc uses "virq" for the same.

Sometimes it is confusing that two different names is used
for the same thing.

The intent of this patch is to centralize access to a common data structure,
but this could also be a good candidate for a terminology shift if
this is considered.

"git grep virq" shows a lot of hits - especially in arm, powerpc.
So what I suggest is obviously only a small step in the direction
of using "irq" all over.

	Sam
