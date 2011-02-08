Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab1BHX3Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 18:29:16 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:29908 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091Ab1BHX3O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 18:29:14 -0500
MIME-Version: 1.0
Message-ID: <0d1aa13e-be1f-4e21-adf2-f0162c67ede3@default>
Date: Tue, 8 Feb 2011 15:27:30 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: gregkh@suse.de, Chris Mason <chris.mason@oracle.com>,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        matthew@wil.cx, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        ngupta@vflare.org, jeremy@goop.org,
        Kurt Hackel <kurt.hackel@oracle.com>, npiggin@kernel.dk,
        riel@redhat.com, Konrad Wilk <konrad.wilk@oracle.com>, mel@csn.ul.ie,
        kosaki.motohiro@jp.fujitsu.com, sfr@canb.auug.org.au,
        wfg@mail.ustc.edu.cn, tytso@mit.edu, viro@zeniv.linux.org.uk,
        hughd@google.com, hannes@cmpxchg.org
Subject: RE: [PATCH V2 2/3] drivers/staging: zcache: host services and PAM
 services
References: <20110207032608.GA27453@ca-server1.us.oracle.com
 AANLkTi=CEXiOdqPZgQZmQwatHqZ_nsnmnVhwpdt=7q3f@mail.gmail.com>
In-Reply-To: <AANLkTi=CEXiOdqPZgQZmQwatHqZ_nsnmnVhwpdt=7q3f@mail.gmail.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6550.5003]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D51D182.0116:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Minchan --

> First of all, thanks for endless effort.

Sometimes it does seem endless ;-)
 
> I didn't look at code entirely but it seems this series includes
> frontswap.

The "new zcache" optionally depends on frontswap, but frontswap is
a separate patchset.  If the frontswap patchset is present
and configured, zcache will use it to dynamically compress swap pages.
If frontswap is not present or not configured, zcache will only
use cleancache to dynamically compress clean page cache pages.
For best results, both frontswap and cleancache should be enabled.
(and see the link in PATCH V2 0/3 for a monolithic patch against
2.6.37 that enabled both).

> Finally frontswap is to replace zram?

Nitin and I have agreed that, for now, both frontswap and zram
should continue to exist.  They have similar functionality but
different use models.  Over time we will see if they can be merged.

Nitin and I agreed offlist that the following summarizes the
differences between zram and frontswap:

===========

Zram uses an asynchronous model (e.g. uses the block I/O subsystem)
and requires a device to be explicitly created.  When used for
swap, mkswap creates a fixed-size swap device (usually with higher
priority than any disk-based swap device) and zram is filled
until it is full, at which point other lower-priority (disk-based)
swap devices are then used.  So zram is well-suited for a fixed-
size-RAM machine with a known workload where an administrator
can pre-configure a zram device to improve RAM efficiency during
peak memory load.

Frontswap uses a synchronous model, circumventing the block I/O
subsystem.  The frontswap "device" is completely dynamic in size,
e.g. frontswap is queried for every individual page-to-be-swapped
and, if rejected, the page is swapped to the "real" swap device.
So frontswap is well-suited for highly dynamic conditions where
workload is unpredictable and/or RAM size may "vary" due to
circumstances not entirely within the kernel's control.

==========

Does that make sense?

> Regardless of my suggestion, I will look at the this series in my spare
> time.

Thanks, we are looking forward to your always excellent and
thorough review!

Dan

