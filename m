Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab2BTDFO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 22:05:14 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35760 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab2BTDFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 22:05:12 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 20 Feb 2012 12:03:46 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Kautuk Consul <consul.kautuk@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 v2] rmap: Make page_referenced_file and
 page_referenced_anon inline
Message-Id: <20120220120346.9cc5b7b6.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1329492398-7631-1-git-send-email-consul.kautuk@gmail.com>
References: <1329492398-7631-1-git-send-email-consul.kautuk@gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Feb 2012 10:26:38 -0500
Kautuk Consul <consul.kautuk@gmail.com> wrote:

> Inline the page_referenced_anon and page_referenced_file
> functions.
> These functions are called only from page_referenced.
> 
> Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>

Hmm ? In my environ,
 
before patch.

[kamezawa@bluextal linux]$ size mm/rmap.o
   text    data     bss     dec     hex filename
  11474       0      24   11498    2cea mm/rmap.o
   (8833) (optimize-for-size=y)
After patch.

[kamezawa@bluextal linux]$ size mm/rmap.o
   text    data     bss     dec     hex filename
  11422       0      24   11446    2cb6 mm/rmap.o
   (8775) (optimize-for-size=y)

text size is 50bytes decreased. But I wonder page_referenced_anon/file
is enough large function which is not inlined by hand in usual...

>From Documentation/CodingStyle Chapter15:  The inline disease
==
A reasonable rule of thumb is to not put inline at functions that have more
than 3 lines of code in them. An exception to this rule are the cases where
a parameter is known to be a compiletime constant, and as a result of this
constantness you *know* the compiler will be able to optimize most of your
function away at compile time. For a good example of this later case, see
the kmalloc() inline function.

Often people argue that adding inline to functions that are static and used
only once is always a win since there is no space tradeoff. While this is
technically correct, gcc is capable of inlining these automatically without
help, and the maintenance issue of removing the inline when a second user
appears outweighs the potential value of the hint that tells gcc to do
something it would have done anyway.
==

I'm sorry but I don't Ack this.

Thanks,
-Kame

