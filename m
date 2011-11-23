Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab1KWQY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 11:24:26 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41032 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599Ab1KWQYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 11:24:25 -0500
Date: Wed, 23 Nov 2011 08:24:17 -0800
From: Tejun Heo <tj@kernel.org>
To: Pedro Alves <pedro@codesourcery.com>
Cc: Pavel Emelyanov <xemul@parallels.com>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Roland McGrath <roland@hack.frob.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        James Bottomley <jbottomley@parallels.com>
Subject: Re: [RFC][PATCH 0/3] fork: Add the ability to create tasks with
 given pids
Message-ID: <20111123162417.GE25780@google.com>
References: <4EC4F2FB.408@parallels.com>
 <201111221204.39235.pedro@codesourcery.com>
 <20111122153326.GD322@google.com>
 <201111231620.45440.pedro@codesourcery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201111231620.45440.pedro@codesourcery.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Nov 23, 2011 at 04:20:44PM +0000, Pedro Alves wrote:
> > Would CAP_CHECKPOINT be a shame too?  
> 
> I think CAP_CHECKPOINT (or something through some LSM) would be
> definitely better.
> 
> > I'm reluctant about priviledge
> > through fd inheritance mostly because of its unusualness.  I don't
> > think priv management is a good problem space for small creative
> > solutions.  We're much better off with mundane mechanisms which people
> > are already familiar with and is easy to account for.
> 
> fd inheritance wouldn't work for gdb; a user spawned gdb
> wouldn't inherit an open fd to kernel.ns_last_pid from anywhere.

I see.  So, let's do it for root for now and later add finer grained
CAP as necessary/viable.  Pavel, what do you think?

Thanks.

-- 
tejun
