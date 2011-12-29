Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab1L2EUQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 23:20:16 -0500
Received: from mga14.intel.com ([143.182.124.37]:19800 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583Ab1L2EUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 23:20:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="90413553"
Date: Thu, 29 Dec 2011 12:20:10 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Bug in BLKBSZSET/GET ioctl ?
Message-ID: <20111229042010.GA22132@localhost>
References: <4EFBE3D1.5030608@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EFBE3D1.5030608@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 29, 2011 at 11:51:45AM +0800, Wanlong Gao wrote:
> Hi all:
> 
> This is first reported to *libguestfs*: https://bugzilla.redhat.com/show_bug.cgi?id=624335
> 
> Then, I looked into upstream util-linux and it seems nothing wrong. I'm not convinced that it's a kernel bug.
> 
> produce:
> 
> ---
> # ./util-linux/disk-utils/blockdev --getbsz /dev/sda6
> 4096
> # ./util-linux/disk-utils/blockdev --setbsz 2048 /dev/sda6
> # ./util-linux/disk-utils/blockdev --getbsz /dev/sda6
> 4096
> # ./util-linux/disk-utils/blockdev --setbsz 512 /dev/sda6
> # ./util-linux/disk-utils/blockdev --getbsz /dev/sda6
> 4096

I think each blockdev invocation is working on a *new* bdev object.
You'll get consistent results if somehow keep it referenced, for
example, run a background copy task:

# cp /dev/sda6 /dev/null &

# ./util-linux/disk-utils/blockdev --getbsz /dev/sda6
# ./util-linux/disk-utils/blockdev --setbsz 512 /dev/sda6
# ./util-linux/disk-utils/blockdev --getbsz /dev/sda6

Thanks,
Fengguang
