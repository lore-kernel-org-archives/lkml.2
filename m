Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363Ab0HUFvz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 01:51:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:19743 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099Ab0HUFvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 01:51:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,243,1280732400"; 
   d="scan'208";a="649858505"
Date: Fri, 20 Aug 2010 22:51:52 -0700
From: Fenghua Yu <fenghua.yu@intel.com>
To: "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Joerg.Roedel@amd.com" <Joerg.Roedel@amd.com>,
        "maciej.rutecki@gmail.com" <maciej.rutecki@gmail.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "sergey.senozhatsky@gmail.com" <sergey.senozhatsky@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Cc: "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/urgent] x86, hwmon: Fix unsafe smp_processor_id() in thermal_throttle_add_dev
Message-ID: <20100821055152.GD22602@linux-os.sc.intel.com>
References: <20100820073634.GB5209@swordfish.minsk.epam.com> <tip-51e3c1b558b31b11bf5fc66d3c6f5adacf3573f7@git.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-51e3c1b558b31b11bf5fc66d3c6f5adacf3573f7@git.kernel.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 09:43:03PM -0700, tip-bot for Sergey Senozhatsky wrote:
> Commit-ID:  51e3c1b558b31b11bf5fc66d3c6f5adacf3573f7
> Gitweb:     http://git.kernel.org/tip/51e3c1b558b31b11bf5fc66d3c6f5adacf3573f7
> Author:     Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> AuthorDate: Fri, 20 Aug 2010 10:36:34 +0300
> Committer:  H. Peter Anvin <hpa@zytor.com>
> CommitDate: Fri, 20 Aug 2010 19:56:00 -0700
> 
> x86, hwmon: Fix unsafe smp_processor_id() in thermal_throttle_add_dev
> 
> Fix BUG: using smp_processor_id() in preemptible thermal_throttle_add_dev.
> We know the cpu number when calling thermal_throttle_add_dev, so we can
> remove smp_processor_id call in thermal_throttle_add_dev by supplying
> the cpu number as argument.
> 
> This should resolve kernel bugzilla 16615/16629.

The fix is right. Current thermal_throttle_add_dev checks local processor to
determine PTS and PLN features on another processor. Logically that is wrong.

Thanks.

-Fenghua
