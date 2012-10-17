Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167Ab2JQOFY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 10:05:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47641 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757049Ab2JQOFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 10:05:22 -0400
Date: Wed, 17 Oct 2012 16:05:13 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Richard Yang <weiyang@linux.vnet.ibm.com>
Cc: Stefani Seibold <stefani@seibold.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove untouched code in kfifo_in
In-Reply-To: <20121017140136.GA7913@richard.(null)>
Message-ID: <alpine.LNX.2.00.1210171605030.17129@pobox.suse.cz>
References: <1350463837-30244-1-git-send-email-weiyang@linux.vnet.ibm.com> <alpine.LNX.2.00.1210171434360.17129@pobox.suse.cz> <20121017140136.GA7913@richard.(null)>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2012, Richard Yang wrote:

> >> This patch just remove this code.
> >> ---
> >>  include/linux/kfifo.h |    4 ----
> >>  1 files changed, 0 insertions(+), 4 deletions(-)
> >> 
> >> diff --git a/include/linux/kfifo.h b/include/linux/kfifo.h
> >> index 10308c6..e7015bb 100644
> >> --- a/include/linux/kfifo.h
> >> +++ b/include/linux/kfifo.h
> >> @@ -512,10 +512,6 @@ __kfifo_uint_must_check_helper( \
> >>  	unsigned long __n = (n); \
> >>  	const size_t __recsize = sizeof(*__tmp->rectype); \
> >>  	struct __kfifo *__kfifo = &__tmp->kfifo; \
> >> -	if (0) { \
> >> -		typeof(__tmp->ptr_const) __dummy __attribute__ ((unused)); \
> >> -		__dummy = (typeof(__buf))NULL; \
> >> -	} \
> >>  	(__recsize) ?\
> >>  	__kfifo_in_r(__kfifo, __buf, __n, __recsize) : \
> >>  	__kfifo_in(__kfifo, __buf, __n); \
> >
> >Frankly, I'd first like to understand what was the rationale for adding it 
> >at the first place. Adding Stefani and lkml to CC.
> 
> Agree.
> 
> BTW, by git blame, I just see commit 2e956fb3 which is checked in by Stefani. 
> While looking in the diff, the kfifo_in() is already there. Looks like this
> commit move the definition from one file to another file. 
> 
> So I am not sure the if(0) code is added by Stefani. Any other method to trace
> the ealier history?

git blame -- include/linux/kfifo-new.h 2e956fb3~1

-- 
Jiri Kosina
SUSE Labs
