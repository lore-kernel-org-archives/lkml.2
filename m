Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648Ab0FGXwQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 19:52:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45728
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751146Ab0FGXwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 19:52:14 -0400
Date: Mon, 07 Jun 2010 16:52:24 -0700 (PDT)
Message-Id: <20100607.165224.25140316.davem@davemloft.net>
To: mpm@selenic.com
Cc: shemminger@linux-foundation.org, fleitner@redhat.com,
       netdev@vger.kernel.org, amwang@redhat.com, fubar@us.ibm.com,
       fbl@sysclose.org, gospo@redhat.com, nhorman@tuxdriver.com,
       jmoyer@redhat.com, linux-kernel@vger.kernel.org,
       bridge@lists.linux-foundation.org, bonding-devel@lists.sourceforge.net
Subject: Re: [PATCH] netconsole: queue console messages to send later
From: David Miller <davem@davemloft.net>
In-Reply-To: <1275942091.26597.85.camel@calx>
References: <1275940248.26597.70.camel@calx>
	<20100607130015.15555744@nehalam>
	<1275942091.26597.85.camel@calx>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Mackall <mpm@selenic.com>
Date: Mon, 07 Jun 2010 15:21:31 -0500

> Open to suggestions. The locks in question are driver-internal. There
> also may not be any actual recursion taking place:
> 
> driver path a takes private lock x
> driver path a attempts printk
> printk calls into netconsole
> netconsole calls into driver path b
> driver path b attempts to take lock x -> deadlock
> 
> So we can't even try to walk back the stack looking for such nonsense.
> Though we could perhaps force queuing of all messages -from- the driver
> bound to netconsole. Tricky, and not quite foolproof.

Look, this is all nonsense talk.

This is only coming about because of the recent discussions about
bonding, so let's fix bonding's locking.  I've made concrete
suggestions on converting it's rwlocks over to spinlocks and RCU to
fix the specific problem bonding has.

Every time we hit some new locking issue the knee jerk reaction is
to do something stupid to the generic netconsole code instead of
fixing the real source of the problem.
