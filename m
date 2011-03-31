Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933507Ab1CaGOX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 02:14:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:4654 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933358Ab1CaGOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 02:14:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,273,1299484800"; 
   d="scan'208";a="903897950"
Subject: Re: [PATCH 0/4] use BUG_ON correctly, v4
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Coly Li <bosong.ly@taobao.com>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Wang Cong <xiyou.wangcong@gmail.com>, Dan <dan.j.williams@intel.com>
In-Reply-To: <1301160415-24569-1-git-send-email-bosong.ly@taobao.com>
References: <1301160415-24569-1-git-send-email-bosong.ly@taobao.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 31 Mar 2011 11:14:26 +0530
Message-ID: <1301550266.18522.6.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-03-27 at 01:26 +0800, Coly Li wrote:
> Most of BUG_ON() implementations use unlikely() internally for better
> branch prediction results. The following method to use BUG_ON() with
> an explicit unlikely() doesn't make things better and is unwelcome:
> 	BUG_ON(unlikely(condition));
> Source code should use BUG_ON() just with condition code.
> 
> For arch implementation of BUG_ON(), there are feed backs for v2 patch
> set from MIPS and PowerPC developers than neither explicit no implicit
> unlikely() does help anything.
> 
> Therefore using unlikely() explicit with BUG_ON() is always a bug. This
> patch set removes all incorrect BUG_ON() usage.
> 
> Patch "Staging: wl_cfg80211.c: use BUG_ON correctly" is merged into
> upstream (commit d7ddd169), no longer in v4 patch set. For v4 
> patch set, proper maintainers are added into Cc list by the help of
> scripts/get_maintainer.pl.
> 
> Cc: Greg KH <gregkh@suse.de>
> Cc: Yong Zhang <yong.zhang0@gmail.com>
> Cc: Wang Cong <xiyou.wangcong@gmail.com>
> Signed-off-by: Coly Li <bosong.ly@taobao.com>
> ---
>  drivers/dma/iop-adma.c    |    6 +++---
>  drivers/dma/mv_xor.c      |    6 +++---
>  drivers/dma/ppc4xx/adma.c |    8 ++++----
>  drivers/scsi/scsi_lib.c   |    4 ++--
>  4 files changed, 12 insertions(+), 12 deletions(-)
Thanks, Applied first 3 patches. 4th one should go to scsi folks.
It would help if you can split patch series per subsystem.

-- 
~Vinod

