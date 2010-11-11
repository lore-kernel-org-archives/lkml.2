Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343Ab0KKEFZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 23:05:25 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40142 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932256Ab0KKEFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 23:05:24 -0500
Date: Wed, 10 Nov 2010 20:02:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bruno Randolf <br1@einfach.org>
Cc: randy.dunlap@oracle.com, peterz@infradead.org, blp@cs.stanford.edu,
        linux-kernel@vger.kernel.org, Lars_Ericsson@telia.com,
        kosaki.motohiro@jp.fujitsu.com, kevin.granade@gmail.com,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v6] Add generic exponentially weighted moving average
 (EWMA) function
Message-Id: <20101110200231.aaa51b47.akpm@linux-foundation.org>
In-Reply-To: <20101111034756.15014.2156.stgit@localhost6.localdomain6>
References: <20101111034756.15014.2156.stgit@localhost6.localdomain6>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Nov 2010 12:47:56 +0900 Bruno Randolf <br1@einfach.org> wrote:

> 
> ...
>
> The original idea for this implementation came from the rt2x00 driver
> (rt2x00link.c). I would like to use it in several places in the mac80211 and
> ath5k code and I hope it can be useful in many other places in the kernel code.
> 
> ...
>
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -21,7 +21,7 @@ lib-y	+= kobject.o kref.o klist.o
>  
>  obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
>  	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
> -	 string_helpers.o gcd.o lcm.o list_sort.o uuid.o
> +	 string_helpers.o gcd.o lcm.o list_sort.o uuid.o average.o

It would be a bit strange to merge this into 2.6.36-rcX when there are
no callers.  But you do want it to be present in some tree for your own
testing and distribution purposes.

So perhaps it would be best to merge this via the wireless tree, so
everything exists in one place and it can be fed into linux-next and
into mainline in an orderly fashion.

If that sounds like a plan then I can send this patch in John's
direction.  Which means that if he merges it into mainline without also
merging any of your patches which _use_ this function then we still end
up with unused code in mainline, but at least that way it wasn't my fault ;)

Let me know your thoughts?


(And it's a bit sad that the function will exist in the base vmlinux
even for people who don't ever use it, but that's a problem which we
don't really have a good solution for).

