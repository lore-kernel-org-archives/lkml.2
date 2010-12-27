Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab0L0QlH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 11:41:07 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:23874 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721Ab0L0QlG (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 27 Dec 2010 11:41:06 -0500
Date: Mon, 27 Dec 2010 11:39:18 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Vasiliy G Tolstov <v.tolstov@selfip.ru>
Cc: jeremy@goop.org, xen-devel@lists.xensource.com,
        haicheng.li@linux.intel.com, dan.magenheimer@oracle.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, andi.kleen@intel.com,
        akpm@linux-foundation.org, fengguang.wu@intel.com,
        Daniel Kiper <dkiper@net-space.pl>
Subject: Re: [Xen-devel] Re: [PATCH 2/3] drivers/xen/balloon.c: Various
 balloon features and fixes
Message-ID: <20101227163918.GB7189@dumpdata.com>
References: <20101220134724.GC6749@router-fw-old.local.net-space.pl>
 <20101227150847.GA3728@dumpdata.com>
 <947c7677e042b3fd1ca22d775ca9aeb9@imap.selfip.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <947c7677e042b3fd1ca22d775ca9aeb9@imap.selfip.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 27, 2010 at 07:27:56PM +0300, Vasiliy G Tolstov wrote:
> On Mon, 27 Dec 2010 10:08:47 -0500, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
> > On Mon, Dec 20, 2010 at 02:47:24PM +0100, Daniel Kiper wrote:
> >> Features and fixes:
> >>   - HVM mode is supported now,
> >>   - migration from mod_timer() to schedule_delayed_work(),
> >>   - removal of driver_pages (I do not have seen any
> >>     references to it),
> >>   - protect before CPU exhaust by event/x process during
> >>     errors by adding some delays in scheduling next event,
> >>   - some other minor fixes.
> 
> I have apply this patch to bare 2.6.36.2 kernel from kernel.org. If
> memory=maxmemory pv guest run's on migrating fine.
> If on already running domU i have xm mem-max xxx 1024 (before that it
> has 768) and do xm mem-set 1024 guest now have 1024 memory, but after
> that it can't migrate to another host.
> 
> Step to try to start guest with memory=512 and maxmemory=1024 it boot
> fine, xm mem-set work's fine, but.. it can't migrate. Sorry but nothing
> on screen , how can i help to debug this problem?

You can play with 'xenctx' to see where the guest is stuck. You can also
look in the 'xm dmesg' to see if there is something odd. Lastly, if you
mean by 'can't migrate to another host' as the command hangs stops, look
at the error code (or in /var/log/xen files) and also look in the source
code.

> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel
