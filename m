Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750936Ab1FMEAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 00:00:36 -0400
Received: from linux-sh.org ([111.68.239.195]:47009 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695Ab1FMEAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 00:00:33 -0400
Date: Mon, 13 Jun 2011 13:00:04 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        linux-fbdev@vger.kernel.org, Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] fb.h: ARM uses __raw_{read/write}
Message-ID: <20110613040003.GA29731@linux-sh.org>
References: <201106101731.08578.hartleys@visionengravers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106101731.08578.hartleys@visionengravers.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 05:31:08PM -0700, H Hartley Sweeten wrote:
> ARM provides __raw_{read/write}* functions for memory access. These
> should be used instead of the default '(*(volatile' stuff to make sure the
> memory accesses are typesafe (void __iomem *).
> 
> This also fixes a number of sparse warning like:
> 
>   warning: cast removes address space of expression
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> 
I'm not sure what semantics are desirable for ARM here, so I'll wait for
Russell to reply.

This wrapping will basically mean that the fb_read/write ops are using
__raw_xxx variants while the memset and memcpy wrappers will be using the
regular read/write[bwl] routines which contain __iormb() calls. Given
that ioread/write and friends all wrap in to the normal versions with the
barriers, I would suppose that this is the default behaviour that is
desired, as opposed to wrapping in to the __raw_xxx variants directly.
