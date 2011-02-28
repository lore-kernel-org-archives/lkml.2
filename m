Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab1B1Kgo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 05:36:44 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57565 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357Ab1B1Kgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 05:36:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jTxXnWYFgQlmPLRjLGXdT3V7CGVb0s+1GL0QtoeXxxaXCiaZq7ZhbhVardbAY1Foj1
         RCyAEIdPcSzPrNFpCFDGzi+ssZkznWbskGN7erfUoOoqEYFZTAeInvF/QAnrwLAkjNvj
         HXmJ3TWUnrHiN+Oc0XtLFU0W5gMLjq70phagY=
Date: Mon, 28 Feb 2011 11:36:37 +0100
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg double V3 0/5] this_cpu_cmpxchg_double support
Message-ID: <20110228103637.GA11045@htj.dyndns.org>
References: <20110225173850.486326452@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110225173850.486326452@linux.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 11:38:50AM -0600, Christoph Lameter wrote:
> This patch series introduces this_cpu_cmpxchg_double().
> 
> x86 cpus support cmpxchg16b and cmpxchg8b instuction which are capable of
> switching two words instead of one during a cmpxchg.
> Two words allow to swap more state in an atomic instruction.
> 
> this_cpu_cmpxchg_double() is used in the slub allocator to avoid
> interrupt disable/enable in both alloc and free fastpath.
> Using the new operation significantly speeds up the fastpaths.

Pekka, Christoph, I applied the third and fifth patches to the percpu
tree.  Please feel free to pull from the following branch and apply
slub changes on top of it.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-2.6.39

HEAD is b9ec40af0e18fb7d02106be148036c2ea490fdf9.  As git.korg seems a
bit slow to sync these days, it may be better to pull from
master.korg.

  ssh://master.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-2.6.39

Thank you.

-- 
tejun
