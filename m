Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab0F2Niw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 09:38:52 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:47022 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599Ab0F2Niv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 09:38:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PvZ854Fdr055F1wX0v0BoPi3J0/65BRsI9xozYcNrmAhoao5d+j5F3A4ohHREuD/WT
         YmsyNaxvPktxUjhOnB3uxHrt4xUWAYck1we7g0xMnI2xwwRFQQupHAU0R6g2tuNma4a0
         z+1D6JGovimhFq0UWsEK19WOJFWLTroTW9UK0=
Date: Tue, 29 Jun 2010 15:39:01 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       oleg@redhat.com, axboe@kernel.dk, dwalker@codeaurora.org,
       stefanr@s5r6.in-berlin.de, florian@mickler.org, andi@firstfloor.org,
       mst@redhat.com, randy.dunlap@oracle.com
Subject: Re: [PATCH UPDATED 12/35] workqueue: update cwq alignement
Message-ID: <20100629133858.GC5318@nowhere>
References: <1277759063-24607-1-git-send-email-tj@kernel.org> <1277759063-24607-13-git-send-email-tj@kernel.org> <20100628224755.GA10104@nowhere> <4C29AADD.1070503@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C29AADD.1070503@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 10:12:13AM +0200, Tejun Heo wrote:
> work->data field is used for two purposes.  It points to cwq it's
> queued on and the lower bits are used for flags.  Currently, two bits
> are reserved which is always safe as 4 byte alignment is guaranteed on
> every architecture.  However, future changes will need more flag bits.
> 
> On SMP, the percpu allocator is capable of honoring larger alignment
> (there are other users which depend on it) and larger alignment works
> just fine.  On UP, percpu allocator is a thin wrapper around
> kzalloc/kfree() and don't honor alignment request.
> 
> This patch introduces WORK_STRUCT_FLAG_BITS and implements
> alloc/free_cwqs() which guarantees max(1 << WORK_STRUCT_FLAG_BITS,
> __alignof__(unsigned long long) alignment both on SMP and UP.  On SMP,
> simply wrapping percpu allocator is enough.  On UP, extra space is
> allocated so that cwq can be aligned and the original pointer can be
> stored after it which is used in the free path.
> 
> * Alignment problem on UP is reported by Michal Simek.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Reported-by: Michal Simek <michal.simek@petalogix.com>
> ---



Your tree now builds well on x86-32. Thanks!

