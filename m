Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783Ab2JZHdO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 03:33:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:3528 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756554Ab2JZHdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 03:33:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,653,1344236400"; 
   d="scan'208";a="232815257"
Date: Fri, 26 Oct 2012 15:33:17 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: Yuanhan Liu <yliu.null@gmail.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Wei Yang <weiyang@linux.vnet.ibm.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] kfifo: remove unnecessary type check
Message-ID: <20121026073317.GC2778@yliu-dev.sh.intel.com>
References: <1351215971-11639-1-git-send-email-yliu.null@gmail.com>
 <1351229911.12511.1.camel@wall-e>
 <20121026061145.GA2778@yliu-dev.sh.intel.com>
 <1351234266.12511.23.camel@wall-e>
 <20121026071757.GB2778@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121026071757.GB2778@yliu-dev.sh.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 03:17:57PM +0800, Yuanhan Liu wrote:
> On Fri, Oct 26, 2012 at 08:51:06AM +0200, Stefani Seibold wrote:
> > Am Freitag, den 26.10.2012, 14:11 +0800 schrieb Yuanhan Liu:
> > > On Fri, Oct 26, 2012 at 07:38:31AM +0200, Stefani Seibold wrote:
> > > > Am Freitag, den 26.10.2012, 09:46 +0800 schrieb Yuanhan Liu:
> > > > > From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
> > > > > 
> > > > > Firstly, this kind of type check doesn't work. It does something similay
> > > > > like following:
> > > > > 	void * __dummy = NULL;
> > > > > 	__buf = __dummy;
> > > > > 
> > > > > __dummy is defined as void *. Thus it will not trigger warnings as
> > > > > expected.
> > > > > 
> > > > > Second, we don't need that kind of check. Since the prototype
> > > > > of __kfifo_out is:
> > > > > 	unsigned int __kfifo_out(struct __kfifo *fifo,  void *buf, unsigned int len)
> > > > > 
> > > > > buf is defined as void *, so we don't need do the type check. Remove it.
> > > > > 
> > > > > LINK: https://lkml.org/lkml/2012/10/25/386
> > > > > LINK: https://lkml.org/lkml/2012/10/25/584
> > > > > 
> > > > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > > > Cc: Wei Yang <weiyang@linux.vnet.ibm.com>
> > > > > Cc: Stefani Seibold <stefani@seibold.net>
> > > > > Cc: Fengguang Wu <fengguang.wu@intel.com>
> > > > > Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> > > > > Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
> > > > > ---
> > 
> > > > 
> > > > Did you tried to compile the whole kernel including all the drivers with
> > > > your patch?
> > > 
> > > Hi Stefani,
> > > 
> > > I did a build test, it did't introduce any new compile errors and
> > > warnings. While, I haven't tried make allmodconfig then. Does this patch
> > > seems wrong to you?
> > > 
> > > Thanks,
> > > Yuanhan Liu
> > 
> > Hi Liu,
> > 
> > no the patch seems not wrong to me. But as you see with the previous
> > patch it is not easy to predict the side effects.
> > 
> > An allmodconfig together with C=2 is necessary to check if there is no
> > side effects which current users of the kfifo API.
> 
> Hi Stefani,
> 
> Make with C=2 will produce tons of warnings, hard to tell it introduces
> new warnings or not. I build some drivers used kfifo and samples as you
> suggested with C=2, find no new warnings. I will build all drivers that
> used kfifo with C=2 later, and will post the result here.

Hi Stefani,

Done build all drivers used kfifo and kfifo samples with C=2, none new
warnigs and erros found :D

Thanks,
Yuanhan Liu
> 
> > That is exactly what
> > i did again and again as i developed the kfifo API.
> > 
> > Also you have to build the kfifo samples, since this example code use
> > all features of the kfifo API.
> > 
> > And again: The kfifo is designed to do the many things at compile time,
> > not at runtime. If you modify the code, you have to check the compiler
> > assembler output for no degradation, especially in kfifo_put, kfifo_get,
> > kfifo_in, kfifo_out, __kfifo_in and __kfifo_out. Prevent runtime checks
> > if you can do it at compile time. This is the basic reasons to do it in
> > macros.
> 
> Is it enought to check kernel/kfifo.o only? I build that file with
> and without this patch. And then  dump it by objdump -D kernel/fifo.o to
> /tmp/kfifo.dump.with and /tmp/kfifo.dump.without, respectively. And the
> two dump file are exactly same.
> 
> Thanks,
> Yuanhan Liu
