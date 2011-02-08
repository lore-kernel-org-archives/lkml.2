Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab1BHDbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 22:31:18 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42599
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751106Ab1BHDbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 22:31:17 -0500
Date: Mon, 07 Feb 2011 19:31:52 -0800 (PST)
Message-Id: <20110207.193152.226778529.davem@davemloft.net>
To: rusty@rustcorp.com.au
Cc: dtor@vmware.com, schwab@linux-m68k.org, geert@linux-m68k.org,
        linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: Early crash
From: David Miller <davem@davemloft.net>
In-Reply-To: <201102081342.49243.rusty@rustcorp.com.au>
References: <20110207165829.GA13101@dtor-ws.eng.vmware.com>
	<20110207.112708.193718501.davem@davemloft.net>
	<201102081342.49243.rusty@rustcorp.com.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>
Date: Tue, 8 Feb 2011 13:42:48 +1030

> But OTOH, this is an old problem which was faced by module params since
> pre-git.  And we use the-align-to-void*-size method there; I vaguely recall
> inserting it.
> 
> You've now got me wondering whether these platforms have broken builtin
> module parameters, but I think it would crash iterating if you had any
> boot parameters at all if that were the case.
> 
> So do we fix that now too, or wait for it to break?

Good question.

I think the magic align magic on x86_64 in gcc only kicks in if a
structure is larger than a certain size.  But of course they could
change that at some point if they like.

So probably better safe than sorry.
