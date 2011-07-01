Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344Ab1GATg3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 15:36:29 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:41354 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377Ab1GATgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 15:36:25 -0400
Date: Fri, 1 Jul 2011 16:36:20 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Joe Perches <joe@perches.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bluetooth: Add bt_printk
Message-ID: <20110701193620.GI23683@joana>
Mail-Followup-To: Joe Perches <joe@perches.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20110630033119.GA3438@joana>
 <f06f1d8f4185db431a038c328c42caf4fe270dd0.1309418368.git.joe@perches.com>
 <20110701190327.GD23683@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110701190327.GD23683@joana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Gustavo F. Padovan <padovan@profusion.mobi> [2011-07-01 16:03:27 -0300]:

> Hi Joe,
> 
> * Joe Perches <joe@perches.com> [2011-06-30 00:19:51 -0700]:
> 
> > Add a local logging function to emit bluetooth specific
> > messages.  Using vsprintf extension %pV saves code/text
> > space.
> > 
> > Convert the current BT_INFO and BT_ERR macros to use bt_printk.
> > Remove __func__ from BT_ERR macro (and the uses).
> > Prefix "Bluetooth: " to BT_ERR
> > Remove __func__ from BT_DBG as function can be prefixed when
> > using dynamic_debug.
> > 
> > With allyesconfig:
> > 
> >    text	   data	    bss	    dec	    hex	filename
> >  129956	   8632	  36096	 174684	  2aa5c	drivers/bluetooth/built-in.o.new2
> >  134402	   8632	  36064	 179098	  2bb9a	drivers/bluetooth/built-in.o.old
> >   14778	   1012	   3408	  19198	   4afe	net/bluetooth/bnep/built-in.o.new2
> >   15067	   1012	   3408	  19487	   4c1f	net/bluetooth/bnep/built-in.o.old
> >  346595	  19163	  86080	 451838	  6e4fe	net/bluetooth/built-in.o.new2
> >  353751	  19163	  86064	 458978	  700e2	net/bluetooth/built-in.o.old
> >   18483	   1172	   4264	  23919	   5d6f	net/bluetooth/cmtp/built-in.o.new2
> >   18927	   1172	   4264	  24363	   5f2b	net/bluetooth/cmtp/built-in.o.old
> >   19237	   1172	   5152	  25561	   63d9	net/bluetooth/hidp/built-in.o.new2
> >   19581	   1172	   5152	  25905	   6531	net/bluetooth/hidp/built-in.o.old
> >   59461	   3884	  14464	  77809	  12ff1	net/bluetooth/rfcomm/built-in.o.new2
> >   61206	   3884	  14464	  79554	  136c2	net/bluetooth/rfcomm/built-in.o.old
> > 
> > with x86 defconfig (and just bluetooth):
> > 
> > $ size net/bluetooth/built-in.o.defconfig.*
> >    text	   data	    bss	    dec	    hex	filename
> >   66358	    933	    100	  67391	  1073f	net/bluetooth/built-in.o.defconfig.new
> >   66643	    933	    100	  67676	  1085c	net/bluetooth/built-in.o.defconfig.old
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> 
> I applied this patch with a minimal change in the print format. I changed
> 'bluetooth' to 'Bluetooth'. Thanks a lot for the patch. ;)

Ah, and in the case someone want to add the function name to debug messages
after this patch. It is easy. Just run

echo -n "module bluetooth +pf" > /sys/kernel/debug/dynamic_debug/control

And debug with funcion names will be enabled. ;)

	Gustavo
