Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab2K2VSe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 16:18:34 -0500
Received: from one.firstfloor.org ([213.235.205.2]:32889 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477Ab2K2VS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 16:18:29 -0500
Date: Thu, 29 Nov 2012 22:18:28 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Jim Kukunas <james.t.kukunas@linux.intel.com>,
        Linux Raid <linux-raid@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] lib/raid6: Add AVX2 optimized recovery functions
Message-ID: <20121129211828.GZ16230@one.firstfloor.org>
References: <1352411264-5156-1-git-send-email-james.t.kukunas@linux.intel.com> <m2obigf9xa.fsf@firstfloor.org> <50B7CFF8.7010401@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50B7CFF8.7010401@zytor.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The code is compiled so that the xmm/ymm registers are not available to
> the compiler.  Do you have any known examples of asm volatiles being
> reordered *with respect to each other*?  My understandings of gcc is
> that volatile operations are ordered with respect to each other (not
> necessarily with respect to non-volatile operations, though.)

Can you quote it from the manual? As I understand volatile as usual
is not clearly defined. 

gcc has a lot of optimization passes and volatile bugs are common.


> Either way, this implementatin technique was used for the MMX/SSE
> implementations without any problems for 9 years now.

It's still wrong.

Lying to the compiler usually bites you at some point.

-Andi
