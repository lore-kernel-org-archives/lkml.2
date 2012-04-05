Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab2DEX3V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 19:29:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59480 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756557Ab2DEX3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 19:29:19 -0400
Date: Fri, 6 Apr 2012 01:29:13 +0200
From: Jan Kara <jack@suse.cz>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: dramatic I/O slowdown after upgrading 2.6.32->3.0
Message-ID: <20120405232913.GA6640@quack.suse.cz>
References: <4F75E46E.2000503@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F75E46E.2000503@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

On Fri 30-03-12 20:50:54, Michael Tokarev wrote:
> I'm observing a dramatic slowdown of several hosts after upgrading
> from 2.6.32.y to 3.0.x i686 kernels (in both cases from kernel.org,
> on both cases the last version is relatively latest).
> 
> On 2.6.32 everything is fast.  On 3.0 the same operations which goes
> instantly takes ages to complete.
> 
> For example, out of observed actual differences, munin-graph process
> on 2.6.32 completes in a few secs writing to a ext4 /var filesystem.
> On 3.0, the same process takes about a minute and keeps all 5 hard
> drives (md raid5) 99% busy all this time.
> 
> apt-get upgrade (from debian/ubuntu) first reads current package
> status database.  This process takes about 3 secs on a freshly
> booted 2.6.32, and about 40 seconds on a freshly booted 3.0,
> again, keeping all 5 hdds 99% busy (according to iostat).
> 
> Only the kernel is different, all the rest is exactly the same.
> I can reboot into 2.6.32 again after running 3.0, and the system
> is fast again.
> 
> The machine is relatively old, it is an IBM xSeries 345 server
> with some 2.66GHz Xeon (stepping 9) CPU, a Broadcom chipset, an
> LSI Logic / Symbios Logic 53c1030 PCI-X Fusion-MPT Dual Ultra320
> SCSI controller and 5x74Gb pSCSI drives.  But it is obviously not
> a reason for it to run _this_ slow... ;)
> 
> There's another machine here, with an AMD BE-2400 CPU, nVidia MCP55
> chipset, AHA-3940U2x pSCSI controller and a set of 74Gb HDDs.  It
> shows similar sympthoms after upgrading from 2.6.32 to 3.0 -- every
> I/O becomes very slow with all HDDs being busy for long periods.
> 
> What's the way to debug this issue?
  Identifying a particular kernel where things regresses might help as Jon
wrote. Just from top of my head, 3.0 had a bug in device plugging so
readahead was broken. I think it was addressed in -stable series so you
might want to check out latest 3.0-stable.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
