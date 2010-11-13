Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929Ab0KMGcu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 01:32:50 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33564 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab0KMGcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 01:32:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=H++jWTKiNHCzsLR8u/cQlQN3VjR8ThXaQQoMRAJKgJxmGiZlCk+qihiokTeZ4yt73d
         W7VOFBqPUIXL7i0TfbB28ArSuw+pfCMhlcvBA7nJgn9SVuOen6MZ2nkmaV+SKmXBfMPQ
         xtbHlJkgAJA2vZlibDekaAYIrawUInNBNV8c8=
Date: Sat, 13 Nov 2010 14:35:51 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Cypher Wu <cypher.w@gmail.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Subject: Re: Kernel rwlock design, Multicore and IGMP
Message-ID: <20101113063551.GD3837@hack>
References: <AANLkTikvT=x9eBovn2-m6HLqk7wyXSAR3sc9jCQ0C6mL@mail.gmail.com> <1289489007.17691.1310.camel@edumazet-laptop> <AANLkTik93QUQxSDmwd4Qj-gXQiWWPzd68JPAYAHBAsHR@mail.gmail.com> <20101112071323.GB5660@cr0.nay.redhat.com> <1289546874.17691.1774.camel@edumazet-laptop> <20101112081945.GA5949@cr0.nay.redhat.com> <AANLkTik-KDvc2fgH91vBHGT6vqxbZrv=9DoQknujPWy2@mail.gmail.com> <20101112091818.GB5949@cr0.nay.redhat.com> <AANLkTi=0Z1zVqCvYwKiQ8cUZoeD_rLgZ+C07GuFgA7E7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=0Z1zVqCvYwKiQ8cUZoeD_rLgZ+C07GuFgA7E7@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 07:06:47PM +0800, Cypher Wu wrote:
>>
>> Note, on Tile, it uses a little different algorithm.
>>
>
>It seems that rwlock on x86 and tile have different behavior, x86 use
>RW_LOCK_BIAS, when read_lock() it will test if the lock is 0, and if
>so then the read_lock() have to 'spinning', otherwise it dec the lock;
>when write_lock() tried it first check if lock is It seems that rwlock
>on x86 and tile have different behavior, x86 use RW_LOCK_BIAS and if
>so, set lock to 0 and continue, otherwise it will 'spinning'.
>I'm not very familiar with x86 architecture, but the code seems like
>working that way.

No, they should be the same, sorry I made a mistake in the above reply.

Although Tile uses shifts in implementation while x86 uses inc/dec,
the idea is same, either writers use higher bits and readers use
lower bits or vice-versa.

-- 
Live like a child, think like the god.
 
