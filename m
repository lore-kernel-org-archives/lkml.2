Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab2CHCbk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 21:31:40 -0500
Received: from mga09.intel.com ([134.134.136.24]:1294 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752833Ab2CHCbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 21:31:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="118882982"
Subject: Re: [RFC patch] spindep: add cross cache lines checking
From: Alex Shi <alex.shi@intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: gcc@gcc.gnu.org, Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
        "mingo@redhat.com" <mingo@redhat.com>, hpa@zytor.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, andi.kleen@intel.com, gcc-help@gcc.gnu.org
In-Reply-To: <201203071154.36059.arnd@arndb.de>
References: <1330917630.18835.44.camel@debian>
	 <201203060932.45223.arnd@arndb.de> <1331108607.18835.343.camel@debian>
	 <201203071154.36059.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Mar 2012 10:30:47 +0800
Message-ID: <1331173847.18835.355.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 1, it is alignof bug for default gcc on my fc15 and Ubuntu 11.10 etc?
> > 
> > struct sub {
> >         int  raw_lock;
> >         char a;
> > };
> > struct foo {
> >         struct sub z;
> >         int slk;
> >         char y;
> > }__attribute__((packed));
> > 
> > struct foo f1;
> > 
> > __alignof__(f1.z.raw_lock) is 4, but its address actually can align on
> > one byte. 
> 
> That looks like correct behavior, because the alignment of raw_lock inside of
> struct sub is still 4. But it does mean that there can be cases where the
> compile-time check is not sufficient, so we might want the run-time check
> as well, at least under some config option.

According to explanation of gcc, seems it should return 1 when it can be
align on char. And then it's useful for design intend. Any comments from
gcc guys? 
====
http://gcc.gnu.org/onlinedocs/gcc/Alignment.html
The keyword __alignof__ allows you to inquire about how an object is
aligned, or the minimum alignment usually required by a type. Its syntax
is just like sizeof.



