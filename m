Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab2EYNwP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 09:52:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:33915 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab2EYNwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 09:52:14 -0400
Subject: Re: [PATCH] tty: tty_mutex: fix lockdep warning in
 tty_lock_pair(v1)
From: Peter Zijlstra <peterz@infradead.org>
To: Alan Cox <alan@linux.intel.com>
Cc: Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <20120525144713.6946df1e@bob.linux.org.uk>
References: <1337651931-5301-1-git-send-email-ming.lei@canonical.com>
	 <CACVXFVP290dwgJVhgMf9girR9h0yU_mjxcN2Po0u1c1y4=QL0w@mail.gmail.com>
	 <1337952533.9783.195.camel@laptop>
	 <20120525144713.6946df1e@bob.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 May 2012 15:52:02 +0200
Message-ID: <1337953922.9783.205.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-25 at 14:47 +0100, Alan Cox wrote:
> > Having looked at the source I still don't see how it could possibly
> > work,.. So the problem with tty_release() -> tty_ldisc_release() is
> > that tty_ldisc_release() does an unlock/lock of tty.
> 
> Yes it should do the pair, see the patch I posted restructing it, and
> the second one restructing it right.

http://marc.info/?l=linux-kernel&m=133794355529930

That one? To what tree does one apply that? Because the tty_lock_pair()
in Linus is still missing a lockdep annotation afaict.

