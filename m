Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993Ab1KRUha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 15:37:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37148 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291Ab1KRUh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 15:37:29 -0500
Date: Fri, 18 Nov 2011 12:37:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Pavel Emelyanov <xemul@parallels.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [PATCH v2 0/4] Checkpoint/Restore: Show in proc IDs of objects
 that can be shared between tasks
Message-Id: <20111118123728.554b45e7.akpm@linux-foundation.org>
In-Reply-To: <20111118200342.GC21041@moon>
References: <4EC4DA15.7090106@parallels.com>
	<20111117124831.688adbeb.akpm@linux-foundation.org>
	<4EC6246A.6020807@parallels.com>
	<20111118110716.c854b4bd.akpm@linux-foundation.org>
	<20111118200342.GC21041@moon>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Nov 2011 00:03:42 +0400
Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> On Fri, Nov 18, 2011 at 11:07:16AM -0800, Andrew Morton wrote:
> ...
> > 
> > OK.  Using the object's kernel virtual address is certainly very
> > attractive.
> > 
> > It is the case that we're causing difficulty with this longer-term plan
> > to make c/r available to unprivileged processes?  Because it's OK to
> > expose kernel addresses to CAP_SYS_ADMIN (or similar) tasks (isn't it?).
> > 
> 
> Actually the address is not exposed in open-form but rather xor'ed with
> a random number, still from security pov it's not clear if it's really useful
> for attacker to obtain inverted low bits of the former random number (which
> might happen on aligned addresses).
> 

Of course.  But

a) I'm not sure that this scheme actually protects the kernel
   addresses - there may be way in which cunning userspace can work out
   the random mask.

b) If we can export these addresses only to CAP_SYS_ADMIN tasks then
   we don't need to obfuscate them anyway.

   Which takes me back to again asking: why not make c/r root-only? 
   And provide non-root access via a carefully-written setuid
   front-end?


