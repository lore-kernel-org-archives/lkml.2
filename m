Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526Ab0EEHdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 03:33:15 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:34644 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab0EEHdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 03:33:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=wI/RtDzKgXDEzv/opg9pJJFCKkUV7ER1VSw/5/AU/8HT7WP/XpquHQNXGkflTnW8bU
         Fmaaqg2b4+lWDPWConXs+rNd1hfOwKDrvJ4xWbQJjmWIkbVjLCklF1zg3CvF0gwZ8LUd
         WV13lnU8yCKLOSD3ZZWga+s1O+k6qQQDbDJaA=
Subject: Re: [PATCH v2] fs: use kmalloc() to allocate fdmem if possible
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Changli Gao <xiaosuo@gmail.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
In-Reply-To: <4BE11BD0.8040703@suse.cz>
References: <1272826920-8899-1-git-send-email-xiaosuo@gmail.com>
	 <20100504152713.0c72a087.akpm@linux-foundation.org>
	 <4BE11BD0.8040703@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 May 2010 09:33:08 +0200
Message-ID: <1273044788.2367.1.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 05 mai 2010 à 09:18 +0200, Jiri Slaby a écrit :
> On 05/05/2010 12:27 AM, Andrew Morton wrote:
> > On Mon,  3 May 2010 03:02:00 +0800
> > Changli Gao <xiaosuo@gmail.com> wrote:
> > 
> >> use kmalloc() to allocate fdmem if possible.
> >>
> >> vmalloc() is used as a fallback solution for fdmem allocation. A new helper
> >> function __free_fdtable() is introduced to reduce the lines of code.
> >>
> >> A potential bug, vfree() a memory allocated by kmalloc(), is fixed.
> >>
> > 
> > Seems a reasonable thing to do.
> 
> Hi,
> 
> So didn't we converge to something like this:
> http://lkml.org/lkml/2010/5/3/53
> instead of this patch?
> 
> This
> 
> >  It might also be reasonable to make
> > vmalloc() try kmalloc() first, but that's a separate exercise.
> 
> and this
> 
> > This most definitely should have __GFP_NOWARN.
> 
> is discussed there too btw.
> 
> thanks,

Its a start, I guess we also need some NUMA capability as well.

For example, iptables could use such an allocator only if it is NUMA
enabled.



