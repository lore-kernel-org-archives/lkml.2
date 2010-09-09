Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab0IIPOz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 11:14:55 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:61282 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab0IIPOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 11:14:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] md: do not use ++ in rcu_dereference() argument
Date: Thu, 9 Sep 2010 17:14:43 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Kulikov Vasiliy <segooon@gmail.com>, kernel-janitors@vger.kernel.org,
        Neil Brown <neilb@suse.de>, Jens Axboe <jaxboe@fusionio.com>,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1283711539-7123-1-git-send-email-segooon@gmail.com> <201009072200.59509.arnd@arndb.de> <20100907205015.GJ2448@linux.vnet.ibm.com>
In-Reply-To: <20100907205015.GJ2448@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009091714.44013.arnd@arndb.de>
X-Provags-ID: V02:K0:xIgU+kVMxwLBMyHwRZCEweUSGJrKkhk023s4kyTI5r1
 PBGRCQv1qPxSlrzmfSyCkPqxOEzmkJVCFwJGCMuGgNI+GEU1Zz
 AB+EmnrT7L92ncc6BD+KVVclGIXL3EkBjiWPPpNWSVN8K1voTm
 rZMlulYdrCJ9omtLsQepmCh50kn5YdzCEH22KxM4ndfiiNev1k
 SbPtYLb7x0rxmvedi8cRw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 September 2010, Paul E. McKenney wrote:
> On Tue, Sep 07, 2010 at 10:00:58PM +0200, Arnd Bergmann wrote:
> > On Tuesday 07 September 2010 21:21:55 Kulikov Vasiliy wrote:
> > > #define __rcu_dereference_check(p, c, space) \
> > >         ({ \
> > >                 typeof(*p) *_________p1 = (typeof(*p)*__force )ACCESS_ONCE(p); \
> > >                                                                    ^
> > >                 rcu_lockdep_assert(c); \
> > >                 (void) (((typeof (*p) space *)p) == p); \
> > >                                       ^     ^
> > >                 smp_read_barrier_depends(); \
> > >                 ((typeof(*p) __force __kernel *)(_________p1)); \
> > >         })
> > > 
> > > If I understand this, it is evaluated three times, right?
> > 
> > Yes, that looks like my own fault, I added that :(
> > 
> > This patch seems to fix it, but I need to think about it some more
> > to make sure it still does everything we need.
> 
> Let me know when you are satisfied with it, and then I will pick it up.

I guess it would be good to put it in now. I haven't had the time
to try out all cases, but the current code in -next is definitely
broken, so please put the fix in now.

	Arnd
