Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839Ab2BPBv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 20:51:58 -0500
Received: from ozlabs.org ([203.10.76.45]:34544 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756260Ab2BPBvP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 20:51:15 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc: akpm@linux-foundation.org, kosaki.motohiro@gmail.com,
        linux-kernel@vger.kernel.org, venki@google.com,
        Mike Travis <travis@sgi.com>
Subject: Re: [PATCH] lib/cpumask.c: Optimize __any_online_cpu() calculation
In-Reply-To: <4F3BBED4.2090101@linux.vnet.ibm.com>
References: <20120215123208.15623.73499.stgit@srivatsabhat.in.ibm.com> <1329310627.2437.18.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <4F3BBED4.2090101@linux.vnet.ibm.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 16 Feb 2012 09:21:23 +1030
Message-ID: <87pqdfbthw.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Feb 2012 19:49:00 +0530, "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com> wrote:
> On 02/15/2012 06:27 PM, Eric Dumazet wrote:
> 
> > Le mercredi 15 février 2012 à 18:05 +0530, Srivatsa S. Bhat a écrit :
> >> __any_online_cpu() uses a for loop at the moment.
> >> Instead, use cpumask_* operations to speed it up.
> >>
> >> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> >> ---
> >> Actually, the patch posted at https://lkml.org/lkml/2012/2/15/101 removed
> >> the last user of any_online_cpu() (and hence __any_online_cpu()).
> >> However, since this is an exported symbol, I refrained from removing this
> >> function altogether.
> > 
> > Just remove the export/function and eventually leave the helper ?
> > 
> > #define any_online_cpu(mask) cpumask_any_and(mask, cpu_online_mask)
> > 
> 
> 
> That sounds good. Here is v2 of the patch.
> (Since this v2 touches include/linux/cpumask.h, I rebased it on top of the
> patch posted at: https://lkml.org/lkml/2012/2/15/2. Even without that
> patch it should apply with minor line number changes..)

No.  Just git rid of the only caller of any_online_cpu():

arch/ia64/kernel/smpboot.c:693:			new_cpei_cpu = any_online_cpu(cpu_online_map);

Thanks,
Rusty.
