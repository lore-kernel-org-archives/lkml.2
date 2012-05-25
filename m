Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab2EYNbj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 09:31:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:39586 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679Ab2EYNbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 09:31:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="148391804"
Date: Fri, 25 May 2012 14:47:13 +0100
From: Alan Cox <alan@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] tty: tty_mutex: fix lockdep warning in
 tty_lock_pair(v1)
Message-ID: <20120525144713.6946df1e@bob.linux.org.uk>
In-Reply-To: <1337952533.9783.195.camel@laptop>
References: <1337651931-5301-1-git-send-email-ming.lei@canonical.com>
	<CACVXFVP290dwgJVhgMf9girR9h0yU_mjxcN2Po0u1c1y4=QL0w@mail.gmail.com>
	<1337952533.9783.195.camel@laptop>
Organization: Intel
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Having looked at the source I still don't see how it could possibly
> work,.. So the problem with tty_release() -> tty_ldisc_release() is
> that tty_ldisc_release() does an unlock/lock of tty.

Yes it should do the pair, see the patch I posted restructing it, and
the second one restructing it right.

> However your tty_lock_pair() can still result in tty being subclass 1,
> see your else branch, nested case.
> 
> That said, how is this not a real deadlock? If you rely on tty pointer
> ordering to avoid deadlocks, you always need to lock them in the same
> order. The unlock+lock in ldisc_release violates that.

Which was a bug.

Alan
