Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368Ab0HPURh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 16:17:37 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46785 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829Ab0HPURf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 16:17:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=uuoVe62YU05uw5XO1KXykhu/DpxtLHJ2L782K2SkdkG+utD8XlL6XYbqherEdl6fw1
         ldjEjrc/4IYrKpGAGDm91k1pLD9ewqEXnbYG3RrAIz+U8CfGMmzPtmLhyI32/W7GCpeb
         EXXsX0crDa8l2t4GKMsoSEQKxvqeP8LNK4xmU=
Subject: Re: [LOCKDEP BUG][2.6.36-rc1] xt_info_wrlock?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Patrick McHardy <kaber@trash.net>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1281988895.1926.1945.camel@laptop>
References: <1281978469.3268.55.camel@gandalf.stny.rr.com>
	 <1281979893.2524.54.camel@edumazet-laptop>
	 <1281981301.3268.110.camel@gandalf.stny.rr.com>
	 <1281982566.3268.137.camel@gandalf.stny.rr.com>
	 <1281983814.1926.1763.camel@laptop>
	 <1281984528.2487.25.camel@edumazet-laptop>
	 <1281986177.1926.1858.camel@laptop>
	 <1281987352.2487.40.camel@edumazet-laptop>
	 <1281988895.1926.1945.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Aug 2010 22:17:30 +0200
Message-ID: <1281989850.2487.64.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 16 août 2010 à 22:01 +0200, Peter Zijlstra a écrit :
> On Mon, 2010-08-16 at 21:35 +0200, Eric Dumazet wrote:
> > Le lundi 16 août 2010 à 21:16 +0200, Peter Zijlstra a écrit :
> > 
> > > Adding lockdep_off() is just plain wrong, if you cannot describe the
> > > locking there's a fair chance its wrong anyway.
> > > 
> > 
> > I see.
> > 
> > I described the fine locking after Steven comment, adding a long
> > Changelog.
> > 
> > http://patchwork.ozlabs.org/patch/61827/
> > 
> > If someone thinks this locking is buggy, please speak now ;)
> 
> Urgh,.. I think it might be correct, but wtf! Wasn't this originally RCU
> code, why not go back to using RCU now that we have
> synchronize_rcu_expedited()?
> 
> As to the original issue, why not keep that bh stuff disabled for
> CONFIG_PROVE_LOCKING instead, that will at least let you keep lock
> coverage, adding lockdep_off() will hide any cycles that would involve
> this lock (even though its currently a leaf lock, you never know what
> creative things the future brings).
> 
> This fancy open coded lock looks like utter fail for -rt though.. please
> use RCU if at all possible.
> 
> 

Please read history of why RCU failed in this context.

I believe I did most of RCU conversions in kernel, you dont need to
shout on me.

And its a bit late in 2.6.36 to even think about it.

I am happy that you volunteer for next RCU conversion, thanks Peter !

In the mean time, we just are going to disable BH again, I'll post a
patch.


