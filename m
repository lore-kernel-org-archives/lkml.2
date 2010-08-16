Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471Ab0HPUBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 16:01:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39854 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab0HPUBr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 16:01:47 -0400
Subject: Re: [LOCKDEP BUG][2.6.36-rc1] xt_info_wrlock?
From: Peter Zijlstra <peterz@infradead.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Patrick McHardy <kaber@trash.net>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1281987352.2487.40.camel@edumazet-laptop>
References: <1281978469.3268.55.camel@gandalf.stny.rr.com>
	 <1281979893.2524.54.camel@edumazet-laptop>
	 <1281981301.3268.110.camel@gandalf.stny.rr.com>
	 <1281982566.3268.137.camel@gandalf.stny.rr.com>
	 <1281983814.1926.1763.camel@laptop>
	 <1281984528.2487.25.camel@edumazet-laptop>
	 <1281986177.1926.1858.camel@laptop>
	 <1281987352.2487.40.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 16 Aug 2010 22:01:35 +0200
Message-ID: <1281988895.1926.1945.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-16 at 21:35 +0200, Eric Dumazet wrote:
> Le lundi 16 août 2010 à 21:16 +0200, Peter Zijlstra a écrit :
> 
> > Adding lockdep_off() is just plain wrong, if you cannot describe the
> > locking there's a fair chance its wrong anyway.
> > 
> 
> I see.
> 
> I described the fine locking after Steven comment, adding a long
> Changelog.
> 
> http://patchwork.ozlabs.org/patch/61827/
> 
> If someone thinks this locking is buggy, please speak now ;)

Urgh,.. I think it might be correct, but wtf! Wasn't this originally RCU
code, why not go back to using RCU now that we have
synchronize_rcu_expedited()?

As to the original issue, why not keep that bh stuff disabled for
CONFIG_PROVE_LOCKING instead, that will at least let you keep lock
coverage, adding lockdep_off() will hide any cycles that would involve
this lock (even though its currently a leaf lock, you never know what
creative things the future brings).

This fancy open coded lock looks like utter fail for -rt though.. please
use RCU if at all possible.


