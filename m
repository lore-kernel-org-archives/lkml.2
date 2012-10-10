Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757159Ab2JJURf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 16:17:35 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:38169 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800Ab2JJURd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 16:17:33 -0400
Date: Wed, 10 Oct 2012 13:17:30 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Fengguang Wu <fengguang.wu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
cc: Glauber Costa <glommer@parallels.com>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch for-linus] memcg, kmem: fix build error when CONFIG_INET
 is disabled
In-Reply-To: <20121010143331.GA7880@localhost>
Message-ID: <alpine.DEB.2.00.1210101312330.28583@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1210092325500.9528@chino.kir.corp.google.com> <5075383A.1000001@parallels.com> <20121010092700.GD23011@dhcp22.suse.cz> <50753FFF.6060102@parallels.com> <20121010143331.GA7880@localhost>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Oct 2012, Fengguang Wu wrote:

> > Fengguang, was that this error? Why hasn't it showed up before in the
> > test system?
> 
> I do find this error in the build error log:
> 
>         (.text+0x867f): undefined reference to `sock_update_memcg'
>         2012-09-24 04:54:53 snb next:akpm:69921c3 x86_64-randconfig-s005 0a7f618
> 
> Unfortunately it was not reported because the build system could
> miss/ignore build bugs due to various reasons/imperfections. It has
> since then undergo lots of enhancements and as a result, the daily
> reported errors have more than doubled. :-)
> 

Not sure where this discussion is going.  Do people who can't build their 
kernel and have a fix for it need to verify that your build system shows 
the same thing first?  This isn't a false positive.

As I said in the first message, Randy reported this on September 24 (the 
same date you're reporting above) and received no response when he 
reported it to LKML here: 
http://marc.info/?l=linux-kernel&m=134852557320089

Regardless, Linus' tree is messed up and I don't think we need to go back 
reverting patches out of his tree when it's trivial to fix with my patch, 
which Michal acked.  Sheesh.
