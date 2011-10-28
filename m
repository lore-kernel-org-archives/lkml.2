Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933819Ab1J1XL4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 19:11:56 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:55312 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273Ab1J1XLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 19:11:54 -0400
Date: Fri, 28 Oct 2011 16:11:49 -0700
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au
Subject: Re: [PATCH] ida: make ida_simple_get/put() IRQ safe
Message-ID: <20111028231149.GA31997@google.com>
References: <20111026203311.GF24261@google.com>
 <20111028160115.bba2b8cf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111028160115.bba2b8cf.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 04:01:15PM -0700, Andrew Morton wrote:
> On Wed, 26 Oct 2011 13:33:11 -0700
> Tejun Heo <tj@kernel.org> wrote:
> 
> > It's often convenient to be able to release resource from IRQ context.
> > Make ida_simple_*() use irqsave/restore spin ops so that they are IRQ
> > safe.
> 
> The patch also accidentally makes ida_simple_get() callable from
> interrupt context.  That's a somewhat unreliable operation due to
> -ENOMEM possibilities even with GFP_ATOMIC.

Hmmm... We can add a WARN_ON_ONCE() there but do we really care?  If
the caller is using GFP_ATOMIC, it should be expecting unreliability.

Thanks.

-- 
tejun
