Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab1LNJoN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 04:44:13 -0500
Received: from casper.infradead.org ([85.118.1.10]:47976 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab1LNJoJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 04:44:09 -0500
Message-ID: <1323855797.28489.22.camel@twins>
Subject: Re: printk() vs tty_io
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <greg@kroah.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 14 Dec 2011 10:43:17 +0100
In-Reply-To: <20111214065910.GA25775@elte.hu>
References: <1323804803.9082.40.camel@twins>
	 <20111214065910.GA25775@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-14 at 07:59 +0100, Ingo Molnar wrote:

> btw., would be nice to also somehow realeasify those debug hacks 
> to preserve them for eternity - doing all lockdep output as 
> earlyprintk while keeping printks working is a great way to 
> debug printk() itself.
> 
> Those printk lockups also took a *lot* of time for me to bisect.

Yeah, they're horrible.. took me long enough to reproduce, and even now
I know how its not easy.

Anyway, I just posted the two patches that make lockdep do
early_printk(), they're not too horrid. I still need to look at making
dump_stack() play nice as well, but so far I've managed to grok bits
from the held lock output only.


