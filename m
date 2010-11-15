Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932647Ab0KOHjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 02:39:45 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:51295 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757650Ab0KOHjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 02:39:41 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 15 Nov 2010 08:38:39 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Bruno Randolf <br1@einfach.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, randy.dunlap@oracle.com,
        peterz@infradead.org, blp@cs.stanford.edu,
        linux-kernel@vger.kernel.org, Lars_Ericsson@telia.com,
        kevin.granade@gmail.com, "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v6] Add generic exponentially weighted moving average
 (EWMA) function
Message-ID: <20101115083839.622b58af@stein>
In-Reply-To: <201011151110.46007.br1@einfach.org>
References: <4CDC333E.4070104@s5r6.in-berlin.de>
	<20101114133029.E008.A69D9226@jp.fujitsu.com>
	<4CDFA2FC.40603@s5r6.in-berlin.de>
	<201011151110.46007.br1@einfach.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 15 Bruno Randolf wrote:
> On Sun November 14 2010 17:51:08 Stefan Richter wrote:
> > BTW, isn't "get" more usually used as a prefix for these kinds of
> > functions in kernel APIs?  "get" as a suffix more often means "get
> > a reference" alias increase reference count rather than "get the
> > value".
> 
> Umm. I don't know and honstly I don't care. I think the API ewma_* is 
> consistent. If you have a good reason to change it please let me
> know, otherwise i'd just leave it like it is now.

It is not about consistency of the API in itself but about consistency
with the rest of the kernel.  Cf. skb_get vs. get_unaligned and many
more.  I for one immediately think of "something is having its
reference count incremented here" when I come across a something_get
when reading code.

I don't know of such a convention being documented anywhere.  But for an
overkill of examples of "get" as prefix and suffix, grep for get_ and
_get( in include/.  The same convention exists IME with "put" that
either writes a value or drops a reference.

Sorry for bringing this up so late but it is IMO not a trivial point.
-- 
Stefan Richter
-=====-==-=- =-== -====
http://arcgraph.de/sr/
