Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab2IZHmP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 03:42:15 -0400
Received: from tee.schottelius.org ([77.109.138.222]:41443 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752778Ab2IZHmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 03:42:12 -0400
Date: Wed, 26 Sep 2012 08:03:12 +0200
From: Nico Schottelius <nico-kernel20120920@schottelius.org>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: David Rientjes <rientjes@google.com>,
        Nico Schottelius <nico-kernel20120920@schottelius.org>,
        Arend van Spriel <arend@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Dave Kleikamp <shaggy@kernel.org>,
        jfs-discussion@lists.sourceforge.net
Subject: Re: Out of memory on 3.5 kernels
Message-ID: <20120926060312.GC16575@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-kernel20120920@schottelius.org>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	David Rientjes <rientjes@google.com>,
	Arend van Spriel <arend@broadcom.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Dave Kleikamp <shaggy@kernel.org>,
	jfs-discussion@lists.sourceforge.net
References: <505B1FA0.6030100@broadcom.com>
 <20120921194931.GA732@schottelius.org>
 <alpine.DEB.2.00.1209241538310.6356@chino.kir.corp.google.com>
 <5061C8A2.1020605@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5061C8A2.1020605@oracle.com>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: brief (Linux 3.5.4-1-ARCH x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good morning,

Dave Kleikamp [Tue, Sep 25, 2012 at 10:07:14AM -0500]:
> >>  Active / Total Objects (% used)    : 1165130 / 1198087 (97.2%)
> >>  Active / Total Slabs (% used)      : 81027 / 81027 (100.0%)
> >>  Active / Total Caches (% used)     : 69 / 101 (68.3%)
> >>  Active / Total Size (% used)       : 1237249.81K / 1246521.94K (99.3%)
> >>  Minimum / Average / Maximum Object : 0.01K / 1.04K / 15.23K
> >>
> >>   OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME                   
> >> 993607 993607 100%    1.21K  75358       26   2411456K jfs_ip
> > 
> > Well that doesn't look good.  100% of the inode cache for jfs are being 
> > used which either means
> > 
> >  - there's a memory leak, or
> 
> maybe a missing iput() somewhere?
> 
> Nico, does unmounting the usb drive after killing the backup clean up
> the jfs inode cache?

Iirc, it does not. I'll check this evening, because doing the backup
currently forces me to reboot my productive system.

> >  - there's some sort of throttling issue in jfs.
> > 
> > And those objects are consuming ~2.3GB of slab on your 4GB machine and 
> > seems to only have occurred between v3.4.2 to v3.5.3.
> 
> Almost nothing in jfs has changed between these releases. Only this:
> 
> vfs: Rename end_writeback() to clear_inode()

The other obscurity is that the root filesystem is also jfs - it's not
only the usb disk.

Cheers,

Nico

-- 
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
