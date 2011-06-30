Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757834Ab1F3Dru (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 23:47:50 -0400
Received: from mail.perches.com ([173.55.12.10]:3346 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456Ab1F3Drn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 23:47:43 -0400
Subject: Re: [PATCH 2/2] bluetooth: Add bt_printk, convert logging macros
 to lower case
From: Joe Perches <joe@perches.com>
To: "Gustavo F. Padovan" <padovan@profusion.mobi>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <20110630033119.GA3438@joana>
References: <1309370457.2208.48.camel@aeonflux>
	 <cover.1309396408.git.joe@perches.com>
	 <dde77465697e4a8fed630a9528cd8c1fcb092ce4.1309396408.git.joe@perches.com>
	 <20110630033119.GA3438@joana>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Jun 2011 20:47:41 -0700
Message-ID: <1309405661.1726.7.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-30 at 00:31 -0300, Gustavo F. Padovan wrote:
> Hi Joe,

Hello Gustavo.

> > Use the more common logging styles.
> > bt_print uses vsprintf extension %pV.
> > This saves 2 to 3 % of code/text space.
> > $ find net/bluetooth -name "built-in.o.*" | xargs size
> >    text	   data	    bss	    dec	    hex	filename
> >   14778	   1012	   3408	  19198	   4afe	net/bluetooth/bnep/built-in.o.new
> >   15067	   1012	   3408	  19487	   4c1f	net/bluetooth/bnep/built-in.o.old
> >   18483	   1172	   4264	  23919	   5d6f	net/bluetooth/cmtp/built-in.o.new
> >   18927	   1172	   4264	  24363	   5f2b	net/bluetooth/cmtp/built-in.o.old
> >   59461	   3884	  14464	  77809	  12ff1	net/bluetooth/rfcomm/built-in.o.new
> >   61206	   3884	  14464	  79554	  136c2	net/bluetooth/rfcomm/built-in.o.old
> >   19237	   1172	   5152	  25561	   63d9	net/bluetooth/hidp/built-in.o.new
> >   19581	   1172	   5152	  25905	   6531	net/bluetooth/hidp/built-in.o.old
> >  346600	  19163	  86080	 451843	  6e503	net/bluetooth/built-in.o.new
> >  353751	  19163	  86064	 458978	  700e2	net/bluetooth/built-in.o.old
> > $ find drivers/bluetooth/ -name "built-in.o.*" | xargs size
> >    text	   data	    bss	    dec	    hex	filename
> >  129956	   8632	  36096	 174684	  2aa5c	drivers/bluetooth/built-in.o.new
> >  134402	   8632	  36064	 179098	  2bb9a	drivers/bluetooth/built-in.o.old
> This is really nice, but can we keep the lower case?

I don't understand what you mean.
Maybe "keep the upper case"?

Sure, go for it.

My point was to add bt_printk and convert the macros.
You could break that up into 5 patches I suppose.

Some sequence like:

	Add bt_printk, convert current BT_<LEVEL> to use them
	Rename bt_err to bt_to_errno
	Add lowercase bt_<level>
	Case conversions of BT_<LEVEL> to bt_<level>
	Remove BT_<LEVEL>

> I think applying this
> patch now will break things to people developing on top of my tree.

Do what you think best.
The code size saving is in conversion to bt_printk and using %pV.
The UPPER->lower is noisy and trivial.

> Then someday in the future when development becomes calm or just after the
> next merge window I run a s/BT_*/bt_*/ on everything.
> Thanks a lot for looking into this, reduce code/text by 3% only changing
> logging is awesome.

cheers, Joe

