Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049Ab3AIPaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 10:30:20 -0500
Received: from www84.your-server.de ([213.133.104.84]:59951 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757904Ab3AIPaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 10:30:18 -0500
Message-ID: <1357745379.11538.4.camel@wall-e>
Subject: Re: [PATCH 1/5] kfifo: remove unnecessary type check
From: Stefani Seibold <stefani@seibold.net>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 09 Jan 2013 16:29:39 +0100
In-Reply-To: <20130109023503.GC304@yliu-dev.sh.intel.com>
References: <1357657073-27352-1-git-send-email-yuanhan.liu@linux.intel.com>
	 <1357657073-27352-2-git-send-email-yuanhan.liu@linux.intel.com>
	 <1357681864.27255.5.camel@wall-e>
	 <20130109023503.GC304@yliu-dev.sh.intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.6.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 09.01.2013, 10:35 +0800 schrieb Yuanhan Liu:
> On Tue, Jan 08, 2013 at 10:51:04PM +0100, Stefani Seibold wrote:
> > Am Dienstag, den 08.01.2013, 22:57 +0800 schrieb Yuanhan Liu:
> > > Firstly, this kind of type check doesn't work. It does something similar
> > > as following:
> > > 	void * __dummy = NULL;
> > > 	__buf = __dummy;
> > > 
> > > __dummy is defined as void *. Thus it will not trigger warnings as
> > > expected.
> > > 
> > > Second, we don't need that kind of check. Since the prototype
> > > of __kfifo_out is:
> > > 	unsigned int __kfifo_out(struct __kfifo *fifo,  void *buf, unsigned int len)
> > > 
> > > buf is defined as void *, so we don't need do the type check. Remove it.
> > > 
> > 
> > Thats wrong.
> > 
> > First the type checking will be used in kfifo_put() and kfifo_in() for
> > const types to check if the passed type of the data can converted to the
> > fifo element type. 
> 
> Hi Stefani,
> 
> Yes, I see now. After rechecking the code, I found that this kind of
> type checking only works for those static defined kifo by
> DECLARE/DEFINE_KFIFO. As the ptrtype is the same as the data type:
> 
>     /* the 4th argument "type" is "ptrtype" */
>     #define STRUCT_KFIFO(type, size) struct __STRUCT_KFIFO(type, size, 0, type)
> 
>     #define DECLARE_KFIFO(fifo, type, size) STRUCT_KFIFO(type, size) fifo
> 
> While, for those kfifo dynamically allocated, the type checking will not
> work as expected then as ptrtype is always "void":
> 
>     struct kfifo __STRUCT_KFIFO_PTR(unsigned char, 0, void);
> 

You should avoid using struct kfifo, as you can read in kfifo.h this is
only for compatibility reason.

If you use the macro DECLARE_KFIFO_PTR(), DECLARE_KFIFO() or
DEFINE_KFIFO() instead.

Have a look at the examples files in the samples/kfifo directory.

- Stefani


