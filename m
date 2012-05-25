Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab2EYN75 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 09:59:57 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:60250 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab2EYN74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 09:59:56 -0400
Date: Fri, 25 May 2012 15:01:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alan Cox <alan@linux.intel.com>, Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] tty: tty_mutex: fix lockdep warning in
 tty_lock_pair(v1)
Message-ID: <20120525150141.7a099aa3@pyramind.ukuu.org.uk>
In-Reply-To: <1337953922.9783.205.camel@laptop>
References: <1337651931-5301-1-git-send-email-ming.lei@canonical.com>
	<CACVXFVP290dwgJVhgMf9girR9h0yU_mjxcN2Po0u1c1y4=QL0w@mail.gmail.com>
	<1337952533.9783.195.camel@laptop>
	<20120525144713.6946df1e@bob.linux.org.uk>
	<1337953922.9783.205.camel@laptop>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2012 15:52:02 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, 2012-05-25 at 14:47 +0100, Alan Cox wrote:
> > > Having looked at the source I still don't see how it could possibly
> > > work,.. So the problem with tty_release() -> tty_ldisc_release() is
> > > that tty_ldisc_release() does an unlock/lock of tty.
> > 
> > Yes it should do the pair, see the patch I posted restructing it, and
> > the second one restructing it right.
> 
> http://marc.info/?l=linux-kernel&m=133794355529930
> 
> That one? To what tree does one apply that? Because the tty_lock_pair()
> in Linus is still missing a lockdep annotation afaict.

It applies on top of the other patches being tested in the thread on the
lockdep warning.

Alan
