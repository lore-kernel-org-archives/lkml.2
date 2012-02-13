Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118Ab2BMRXU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 12:23:20 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44604 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab2BMRXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 12:23:17 -0500
Date: Mon, 13 Feb 2012 09:23:11 -0800
From: Tejun Heo <tj@kernel.org>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Christoph Lameter <cl@linux.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] percpu: use raw_local_irq_* in _this_cpu op
Message-ID: <20120213172311.GB12117@google.com>
References: <1329131018-19107-1-git-send-email-tom.leiming@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329131018-19107-1-git-send-email-tom.leiming@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 07:03:38PM +0800, Ming Lei wrote:
> It doesn't make sense to trace irq off or do irq flags
> lock proving inside 'this_cpu' operations, so replace local_irq_*
> with raw_local_irq_* in 'this_cpu' op.
> 
> Also the patch fixes one lockdep warning[1], which is caused
> by the added local_irq_save/restore(flags) in this_cpu_inc
> called by __debug_atomic_inc: kernel/lockdep.c

I think this isn't gonna hurt anything but I don't understand why the
lockdep warning is triggering when using traced version.  Can you
please explain that in a bit more detail in the patch description?

Thank you.

-- 
tejun
