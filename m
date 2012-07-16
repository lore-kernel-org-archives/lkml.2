Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab2GPTbj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 15:31:39 -0400
Received: from mail1.windriver.com ([147.11.146.13]:60905 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab2GPTbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 15:31:37 -0400
Date: Mon, 16 Jul 2012 14:31:14 -0500
From: Peter Seebach <peter.seebach@windriver.com>
To: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/6] workqueue: introduce NR_WORKER_POOLS and
 for_each_worker_pool()
Message-ID: <20120716143114.5ad07878@wrlaptop>
In-Reply-To: <CA+55aFyozbYJh4vRLCCkk5j86XEasngvWkKmL4WpBjiCB5050g@mail.gmail.com>
References: <1341859315-17759-1-git-send-email-tj@kernel.org>
	<1341859315-17759-6-git-send-email-tj@kernel.org>
	<20120714035538.GB5638@dhcp-172-17-108-109.mtv.corp.google.com>
	<CA+55aFyeauqCqrWsx4U2TB2ENrugZXYj+4vw3Fd0kGaeWBP3RA@mail.gmail.com>
	<20120714044438.GA7718@dhcp-172-17-108-109.mtv.corp.google.com>
	<CA+55aFyozbYJh4vRLCCkk5j86XEasngvWkKmL4WpBjiCB5050g@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2012 22:00:10 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:
> (*) Technically, "&(x)[0]" is actually a really confused way of saying
> "(x+0)" while making sure that "x" was a valid pointer.

But wait, there's more!

Should someone some day try to use an implementation with a fairly
ferocious bounds-checker, the bounds of &x[0] are the bounds of the
first member of x, while the bounds of x are... well, whatever they
were. (If x is an array, they're definitely the bounds of the whole
array. If x is a pointer to something, then it depends on how the
pointer was obtained.)

I'm not sure anyone actually has an implementation that bothers with
this level of granularity in pointers, but I am about 90% sure that an
implementation which did would be conforming.  e.g.:

  int a[2];
  a[1] = 3; /* ok */
  int *b = a;
  b[1] = 3; /* ok */
  int *c = &a[0];
  c[1] = 3; /* bounds violation */

Note that "conforming" does not imply "could compile and run most
existing code without surprising new errors". The world is full of code
which assumes absolute identity between (a+i) and &(*(a+i)).

If the code which inspired your rant was actually doing it on purpose
to obtain this result, I shall have to buy a hat so I can eat it.
(Disclaimer: Hat must be made of something delicious.)

-s
-- 
Listen, get this.  Nobody with a good compiler needs to be justified.
