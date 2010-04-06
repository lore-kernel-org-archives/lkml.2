Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324Ab0DFGwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 02:52:39 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41767 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab0DFGwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 02:52:35 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 6 Apr 2010 15:48:31 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       San Mehat <san@google.com>, linux-kernel@vger.kernel.org,
       Brian Swetland <swetland@google.com>, Dave Hansen <haveblue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, n-horiguchi@ah.jp.nec.com
Subject: Re: [PATCH] proc: pagemap: Hold mmap_sem during page walk
Message-Id: <20100406154831.3d10ee7a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100402143058.GA22639@waste.org>
References: <20100401144329.BE42.A69D9226@jp.fujitsu.com>
	<20100401145509.47f7f1c3.kamezawa.hiroyu@jp.fujitsu.com>
	<20100401150128.BE45.A69D9226@jp.fujitsu.com>
	<20100401150956.4f6821c2.kamezawa.hiroyu@jp.fujitsu.com>
	<20100401153428.d49c6345.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.LFD.2.00.1004010747540.3707@i5.linux-foundation.org>
	<20100402091129.bca35057.kamezawa.hiroyu@jp.fujitsu.com>
	<20100402143058.GA22639@waste.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Apr 2010 09:30:58 -0500
Matt Mackall <mpm@selenic.com> wrote:

> On Fri, Apr 02, 2010 at 09:11:29AM +0900, KAMEZAWA Hiroyuki wrote:
> 
> >  	int ret = -ESRCH;
> ...
> > +	pm.len = PM_ENTRY_BYTES * (PAGEMAP_WALK_SIZE >> PAGE_SHIFT);
> > +	pm.buffer = kmalloc(pm.len, GFP_TEMPORARY);
> > +	if (!pm.buffer)
> >  		goto out_mm;
> ...
> >  out_mm:
> >  	mmput(mm);
> 
> Looks like this gets the wrong return code?
> 
I'm sorry. And thank you for pointing out.
I confirmed merged one has fixed code.

Regards,
-Kame

