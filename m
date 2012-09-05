Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757637Ab2IENzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 09:55:38 -0400
Received: from a194-183.smtp-out.amazonses.com ([199.255.194.183]:26620 "EHLO
	a194-183.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756819Ab2IENzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 09:55:37 -0400
Date: Wed, 5 Sep 2012 13:55:35 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Michael Wang <wangyun@linux.vnet.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Matt Mackall <mpm@selenic.com>, Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH] slab: fix the DEADLOCK issue on l3 alien lock
In-Reply-To: <5046B9EE.7000804@linux.vnet.ibm.com>
Message-ID: <0000013996b6f21d-d45be653-3111-4aef-b079-31dc673e6fd8-000000@email.amazonses.com>
References: <5044692D.7080608@linux.vnet.ibm.com> <5046B9EE.7000804@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.183
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Sep 2012, Michael Wang wrote:

> Since the cachep and cachep->slabp_cache's l3 alien are in the same lock class,
> fake report generated.

Ahh... That is a key insight into why this occurs.

> This should not happen since we already have init_lock_keys() which will
> reassign the lock class for both l3 list and l3 alien.

Right. I was wondering why we still get intermitted reports on this.

> This patch will invoke init_lock_keys() after we done enable_cpucache()
> instead of before to avoid the fake DEADLOCK report.

Acked-by: Christoph Lameter <cl@linux.com>
