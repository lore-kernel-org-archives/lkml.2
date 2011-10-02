Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab1JBAgh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 20:36:37 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:57249 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597Ab1JBAgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 20:36:31 -0400
Date: Sat, 1 Oct 2011 17:36:27 -0700
From: Tejun Heo <tj@kernel.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>, Jason Baron <jbaron@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH RFC V2 2/5] stop_machine: make stop_machine safe and
 efficient to call early
Message-ID: <20111002003627.GB31799@mtj.dyndns.org>
References: <cover.1317506051.git.jeremy.fitzhardinge@citrix.com>
 <58bc7c7142fe54cd6c17f2f18f4b11fd2f597d5a.1317506051.git.jeremy.fitzhardinge@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58bc7c7142fe54cd6c17f2f18f4b11fd2f597d5a.1317506051.git.jeremy.fitzhardinge@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Oct 01, 2011 at 02:55:34PM -0700, Jeremy Fitzhardinge wrote:
> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> Make stop_machine() safe to call early in boot, before SMP has been
> set up, by simply calling the callback function directly if there's
> only one CPU online.

Maybe "before stop_machine is initialized" is better wording now both
here and in the comment?

> [ Fixes from AKPM:
>    - add comment
>    - local_irq_flags, not save_flags
>    - also call hard_irq_disable() for systems which need it
> 
>   Tejun suggested using an explicit flag rather than just looking at
>   the online cpu count. ]
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: H. Peter Anvin <hpa@linux.intel.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Steven Rostedt <rostedt@goodmis.org>

Other than that,

 Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
