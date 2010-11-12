Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418Ab0KLBo1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 20:44:27 -0500
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:41183 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756114Ab0KLBo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 20:44:26 -0500
From: Bruno Randolf <br1@einfach.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH v6] Add generic exponentially weighted moving average (EWMA) function
Date: Fri, 12 Nov 2010 10:44:40 +0900
User-Agent: KMail/1.13.5 (Linux/2.6.35-22-generic; KDE/4.5.1; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, randy.dunlap@oracle.com,
        peterz@infradead.org, blp@cs.stanford.edu,
        linux-kernel@vger.kernel.org, Lars_Ericsson@telia.com,
        kosaki.motohiro@jp.fujitsu.com, kevin.granade@gmail.com,
        "John W. Linville" <linville@tuxdriver.com>
References: <20101111034756.15014.2156.stgit@localhost6.localdomain6> <201011111421.49464.br1@einfach.org> <4CDC333E.4070104@s5r6.in-berlin.de>
In-Reply-To: <4CDC333E.4070104@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011121044.40274.br1@einfach.org>
X-SF-Loop: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri November 12 2010 03:17:34 Stefan Richter wrote:
> It seems totally clear-cut to me that code like this is submitted together
> with at least one call site, and it is submitted through the tree in which
> that call site is maintained.

Ok. So I'll re-send the patch thru John's wireless tree after I fixed up your 
comments.

> >> (And it's a bit sad that the function will exist in the base vmlinux
> >> even for people who don't ever use it, but that's a problem which we
> >> don't really have a good solution for).
> > 
> > Hmm, should I switch it back to all inlines?
> 
> Add a hidden Kconfig variable for it which is SELECTed by those Kconfig
> prompts that require it?  That's the good solution that we use for a number
> of similar library functions.
> $ cat lib/Makefile

Ok.

> You use WARN_ON in lib/average.c.  You should include <linux/bug.h>.

Thanks.

> Why do ewma_init() and ewma_add() return their first argument?  They look
> to me like they can be straight-forward void functions.

You are right, for ewma_init() it does not make sense.

For ewma_add() I think it does. This has been discussed before (e.g. 
http://linux.derkeiler.com/Mailing-Lists/Kernel/2010-10/msg09124.html).
Some people might want to get the value when they add a sample by using 
ewma_get(ewma_add(&ewma, val));

Bruno
