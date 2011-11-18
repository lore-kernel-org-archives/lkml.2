Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440Ab1KRUDt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 15:03:49 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54843 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025Ab1KRUDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 15:03:48 -0500
Date: Sat, 19 Nov 2011 00:03:42 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Emelyanov <xemul@parallels.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [PATCH v2 0/4] Checkpoint/Restore: Show in proc IDs of objects
 that can be shared between tasks
Message-ID: <20111118200342.GC21041@moon>
References: <4EC4DA15.7090106@parallels.com>
 <20111117124831.688adbeb.akpm@linux-foundation.org>
 <4EC6246A.6020807@parallels.com>
 <20111118110716.c854b4bd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111118110716.c854b4bd.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 18, 2011 at 11:07:16AM -0800, Andrew Morton wrote:
...
> 
> OK.  Using the object's kernel virtual address is certainly very
> attractive.
> 
> It is the case that we're causing difficulty with this longer-term plan
> to make c/r available to unprivileged processes?  Because it's OK to
> expose kernel addresses to CAP_SYS_ADMIN (or similar) tasks (isn't it?).
> 

Actually the address is not exposed in open-form but rather xor'ed with
a random number, still from security pov it's not clear if it's really useful
for attacker to obtain inverted low bits of the former random number (which
might happen on aligned addresses).

	Cyrill
