Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311Ab2JZGLm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 02:11:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:28734 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754689Ab2JZGLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 02:11:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,652,1344236400"; 
   d="scan'208";a="209546765"
Date: Fri, 26 Oct 2012 14:11:45 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: Yuanhan Liu <yliu.null@gmail.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Wei Yang <weiyang@linux.vnet.ibm.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] kfifo: remove unnecessary type check
Message-ID: <20121026061145.GA2778@yliu-dev.sh.intel.com>
References: <1351215971-11639-1-git-send-email-yliu.null@gmail.com>
 <1351229911.12511.1.camel@wall-e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351229911.12511.1.camel@wall-e>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 07:38:31AM +0200, Stefani Seibold wrote:
> Am Freitag, den 26.10.2012, 09:46 +0800 schrieb Yuanhan Liu:
> > From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
> > 
> > Firstly, this kind of type check doesn't work. It does something similay
> > like following:
> > 	void * __dummy = NULL;
> > 	__buf = __dummy;
> > 
> > __dummy is defined as void *. Thus it will not trigger warnings as
> > expected.
> > 
> > Second, we don't need that kind of check. Since the prototype
> > of __kfifo_out is:
> > 	unsigned int __kfifo_out(struct __kfifo *fifo,  void *buf, unsigned int len)
> > 
> > buf is defined as void *, so we don't need do the type check. Remove it.
> > 
> > LINK: https://lkml.org/lkml/2012/10/25/386
> > LINK: https://lkml.org/lkml/2012/10/25/584
> > 
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Wei Yang <weiyang@linux.vnet.ibm.com>
> > Cc: Stefani Seibold <stefani@seibold.net>
> > Cc: Fengguang Wu <fengguang.wu@intel.com>
> > Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> > Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
> > ---
> >  include/linux/kfifo.h | 20 --------------------
> >  1 file changed, 20 deletions(-)
> > 
> > diff --git a/include/linux/kfifo.h b/include/linux/kfifo.h
> > index 10308c6..b8c1d03 100644
> > --- a/include/linux/kfifo.h
> > +++ b/include/linux/kfifo.h
> > @@ -390,10 +390,6 @@ __kfifo_int_must_check_helper( \
> >  	unsigned int __ret; \
> >  	const size_t __recsize = sizeof(*__tmp->rectype); \
> >  	struct __kfifo *__kfifo = &__tmp->kfifo; \
> > -	if (0) { \
> > -		typeof(__tmp->ptr_const) __dummy __attribute__ ((unused)); \
> > -		__dummy = (typeof(__val))NULL; \
> > -	} \
> >  	if (__recsize) \
> >  		__ret = __kfifo_in_r(__kfifo, __val, sizeof(*__val), \
> >  			__recsize); \
> > @@ -432,8 +428,6 @@ __kfifo_uint_must_check_helper( \
> >  	unsigned int __ret; \
> >  	const size_t __recsize = sizeof(*__tmp->rectype); \
> >  	struct __kfifo *__kfifo = &__tmp->kfifo; \
> > -	if (0) \
> > -		__val = (typeof(__tmp->ptr))0; \
> >  	if (__recsize) \
> >  		__ret = __kfifo_out_r(__kfifo, __val, sizeof(*__val), \
> >  			__recsize); \
> > @@ -473,8 +467,6 @@ __kfifo_uint_must_check_helper( \
> >  	unsigned int __ret; \
> >  	const size_t __recsize = sizeof(*__tmp->rectype); \
> >  	struct __kfifo *__kfifo = &__tmp->kfifo; \
> > -	if (0) \
> > -		__val = (typeof(__tmp->ptr))NULL; \
> >  	if (__recsize) \
> >  		__ret = __kfifo_out_peek_r(__kfifo, __val, sizeof(*__val), \
> >  			__recsize); \
> > @@ -512,10 +504,6 @@ __kfifo_uint_must_check_helper( \
> >  	unsigned long __n = (n); \
> >  	const size_t __recsize = sizeof(*__tmp->rectype); \
> >  	struct __kfifo *__kfifo = &__tmp->kfifo; \
> > -	if (0) { \
> > -		typeof(__tmp->ptr_const) __dummy __attribute__ ((unused)); \
> > -		__dummy = (typeof(__buf))NULL; \
> > -	} \
> >  	(__recsize) ?\
> >  	__kfifo_in_r(__kfifo, __buf, __n, __recsize) : \
> >  	__kfifo_in(__kfifo, __buf, __n); \
> > @@ -565,10 +553,6 @@ __kfifo_uint_must_check_helper( \
> >  	unsigned long __n = (n); \
> >  	const size_t __recsize = sizeof(*__tmp->rectype); \
> >  	struct __kfifo *__kfifo = &__tmp->kfifo; \
> > -	if (0) { \
> > -		typeof(__tmp->ptr) __dummy = NULL; \
> > -		__buf = __dummy; \
> > -	} \
> >  	(__recsize) ?\
> >  	__kfifo_out_r(__kfifo, __buf, __n, __recsize) : \
> >  	__kfifo_out(__kfifo, __buf, __n); \
> > @@ -777,10 +761,6 @@ __kfifo_uint_must_check_helper( \
> >  	unsigned long __n = (n); \
> >  	const size_t __recsize = sizeof(*__tmp->rectype); \
> >  	struct __kfifo *__kfifo = &__tmp->kfifo; \
> > -	if (0) { \
> > -		typeof(__tmp->ptr) __dummy __attribute__ ((unused)) = NULL; \
> > -		__buf = __dummy; \
> > -	} \
> >  	(__recsize) ? \
> >  	__kfifo_out_peek_r(__kfifo, __buf, __n, __recsize) : \
> >  	__kfifo_out_peek(__kfifo, __buf, __n); \
> 
> Did you tried to compile the whole kernel including all the drivers with
> your patch?

Hi Stefani,

I did a build test, it did't introduce any new compile errors and
warnings. While, I haven't tried make allmodconfig then. Does this patch
seems wrong to you?

Thanks,
Yuanhan Liu
