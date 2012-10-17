Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568Ab2JQTwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 15:52:38 -0400
Received: from www84.your-server.de ([213.133.104.84]:38396 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756461Ab2JQTwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 15:52:37 -0400
Message-ID: <1350503509.9947.1.camel@wall-e>
Subject: Re: [PATCH] remove untouched code in kfifo_in
From: Stefani Seibold <stefani@seibold.net>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Richard Yang <weiyang@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Date: Wed, 17 Oct 2012 21:51:49 +0200
In-Reply-To: <alpine.LNX.2.00.1210171605030.17129@pobox.suse.cz>
References: <1350463837-30244-1-git-send-email-weiyang@linux.vnet.ibm.com>
	 <alpine.LNX.2.00.1210171434360.17129@pobox.suse.cz>
	 <20121017140136.GA7913@richard.(null)>
	 <alpine.LNX.2.00.1210171605030.17129@pobox.suse.cz>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was introduce by me to suppress a compiler warning, so don't remove
it. 

Am Mittwoch, den 17.10.2012, 16:05 +0200 schrieb Jiri Kosina:
> On Wed, 17 Oct 2012, Richard Yang wrote:
> 
> > >> This patch just remove this code.
> > >> ---
> > >>  include/linux/kfifo.h |    4 ----
> > >>  1 files changed, 0 insertions(+), 4 deletions(-)
> > >> 
> > >> diff --git a/include/linux/kfifo.h b/include/linux/kfifo.h
> > >> index 10308c6..e7015bb 100644
> > >> --- a/include/linux/kfifo.h
> > >> +++ b/include/linux/kfifo.h
> > >> @@ -512,10 +512,6 @@ __kfifo_uint_must_check_helper( \
> > >>  	unsigned long __n = (n); \
> > >>  	const size_t __recsize = sizeof(*__tmp->rectype); \
> > >>  	struct __kfifo *__kfifo = &__tmp->kfifo; \
> > >> -	if (0) { \
> > >> -		typeof(__tmp->ptr_const) __dummy __attribute__ ((unused)); \
> > >> -		__dummy = (typeof(__buf))NULL; \
> > >> -	} \
> > >>  	(__recsize) ?\
> > >>  	__kfifo_in_r(__kfifo, __buf, __n, __recsize) : \
> > >>  	__kfifo_in(__kfifo, __buf, __n); \
> > >
> > >Frankly, I'd first like to understand what was the rationale for adding it 
> > >at the first place. Adding Stefani and lkml to CC.
> > 
> > Agree.
> > 
> > BTW, by git blame, I just see commit 2e956fb3 which is checked in by Stefani. 
> > While looking in the diff, the kfifo_in() is already there. Looks like this
> > commit move the definition from one file to another file. 
> > 
> > So I am not sure the if(0) code is added by Stefani. Any other method to trace
> > the ealier history?
> 
> git blame -- include/linux/kfifo-new.h 2e956fb3~1
> 


