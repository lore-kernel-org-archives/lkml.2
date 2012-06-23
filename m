Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291Ab2FWHo1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 03:44:27 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:49287 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751923Ab2FWHo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 03:44:26 -0400
Message-ID: <1340437465.2274.5.camel@joe2Laptop>
Subject: Re: [PATCH] printk: Add printk_flush() to force buffered text to
 console
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "kay.sievers" <kay.sievers@vrfy.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@elte.hu>
Date: Sat, 23 Jun 2012 00:44:25 -0700
In-Reply-To: <20120623061313.GA21895@gmail.com>
References: <1340322723.27036.220.camel@gandalf.stny.rr.com>
	 <20120622145402.8047a669.akpm@linux-foundation.org>
	 <20120623061313.GA21895@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-06-23 at 08:13 +0200, Ingo Molnar wrote:
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Thu, 21 Jun 2012 19:52:03 -0400
> > Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > But with the new printk() changes, text without a newline 
> > > gets buffered and does not print out to the console at the 
> > > location of the printk.
> > 
> > uh, how about we fix that?  The old behaviour was good, the 
> > new behaviour is noxious.
> 
> Absolutely.
> 
> pr_flush() really seems to be a workaround.

I think the new behavior an overall improvement.
It helps avoid multiple thread interleaving.

I suggested a fix to enable a printk buffered/non-buffered
mechanism with an optional printk_flush/pr_flush.

https://lkml.org/lkml/2012/6/21/305


