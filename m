Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605Ab0DCCGE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 22:06:04 -0400
Received: from ozlabs.org ([203.10.76.45]:41361 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755431Ab0DCCGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 22:06:00 -0400
Date: Sat, 3 Apr 2010 13:03:42 +1100
From: Anton Blanchard <anton@samba.org>
To: Greg KH <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>, Andi Kleen <ak@linux.intel.com>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] devmem: Handle class_create() failure
Message-ID: <20100403020342.GJ5594@kryten>
References: <20100402072920.GH5594@kryten>
 <20100402165324.GD32081@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100402165324.GD32081@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
Hi Greg,

> Is this something that we need for .34?  How were you getting this to
> fail in the first place?

I hit this when we broke the IDR allocator for a few days.  The bug got
introduced in commit 859ddf09743a8cc680af33f7259ccd0fd36bfe9d (idr: fix a
critical misallocation bug), and was backed out a few days later in commit
6f14a668f1a8b715a6e855f4e32705e54a6e86a1 (idr: revert misallocation bug fix).

The sysfs inode allocator which uses IDR was getting back a bogus ENOSPC
return code. I think the chances of seeing this fail otherwise would be pretty
remote, you'd have to use up 2^31 sysfs inodes before hitting the real IDR
limit.

Anton
