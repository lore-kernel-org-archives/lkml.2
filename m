Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab2DOOVS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 10:21:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:48532 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837Ab2DOOVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 10:21:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="129816141"
Date: Sun, 15 Apr 2012 07:21:16 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, penberg@kernel.org
Subject: Re: [PATCH] slab/mempolicy: always use local policy from interrupt
 context
Message-ID: <20120415142116.GB2566@tassilo.jf.intel.com>
References: <1334358010-17019-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334358010-17019-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>   * such protection.
>   */
> -unsigned slab_node(struct mempolicy *policy)
> +unsigned slab_node(void)
>  {
> +	struct mempolicy *policy = in_interrupt() ? current->policy : NULL;

Oops I sent the wrong version of the patch. This should be 
!in_interrupt() of course. Resend coming.

-Andi
