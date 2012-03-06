Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab2CFGSZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 01:18:25 -0500
Received: from mga09.intel.com ([134.134.136.24]:29461 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523Ab2CFGSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 01:18:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="118075790"
Subject: Re: [RFC patch] spindep: add cross cache lines checking
From: Alex Shi <alex.shi@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnd Bergmann <arnd@arndb.de>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, hpa@zytor.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, andi.kleen@intel.com, gcc-help@gcc.gnu.org
In-Reply-To: <1331014414.18835.254.camel@debian>
References: <1330917630.18835.44.camel@debian>
	 <1330917889.18835.46.camel@debian> <1330926234.18835.51.camel@debian>
	 <201203050941.56502.arnd@arndb.de>  <20120305104311.GA18556@elte.hu>
	 <1331014414.18835.254.camel@debian>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Mar 2012 14:18:22 +0800
Message-ID: <1331014702.18835.255.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resend for correct tglx's address. Sorry!
> > > 
> > > Have you tried making this a compile-time check using 
> > > __alignof__? I would say that any spinlock in a packed data 
> > > structure is basically a bug, even more so on most other 
> > > architectures besides x86.
> 
> I have one concern and one questions here:
> concern: maybe the lock is in a well designed 'packed' struct, and it is
> safe for cross lines issue. but __alignof__ will return 1;
> 
> struct abc{
> 	raw_spinlock_t lock1;
> 	char 		a;
> 	char		b;
> }__attribute__((packed));
> 
> Since the lock is the first object of struct, usually it is well placed.
> 
> question: I am a idiot on gcc, I tried some parameters of gcc " --param
> l1-cache-line-size=1  -mno-align-double" and can not make a cross lines
> variable without 'packed' structure, but I still don't find a grantee
> why gcc can avoid the cross line variable if it's not in 'packed'
> structure? 
> 
> > agreed.
> > 
> > Thanks,
> > 
> > 	Ingo
> 


