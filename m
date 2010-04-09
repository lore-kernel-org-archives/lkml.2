Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751254Ab0DIBmu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 21:42:50 -0400
Received: from mga14.intel.com ([143.182.124.37]:50576 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833Ab0DIBmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 21:42:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,174,1270450800"; 
   d="scan'208";a="263695978"
Date: Fri, 9 Apr 2010 09:42:44 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Greg KH <greg@kroah.com>,
       Gerald Schaefer <gerald.schaefer@de.ibm.com>,
       "stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH] Revert "memory-hotplug: add 0x prefix to HEX
	block_size_bytes"
Message-ID: <20100409014244.GB5644@localhost>
References: <20100408151006.GB2446@osiris.boeblingen.de.ibm.com> <20100408153745.GA4213@hack> <20100408212918.GA2716@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100408212918.GA2716@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heiko,

On Fri, Apr 09, 2010 at 05:29:18AM +0800, Heiko Carstens wrote:
> On Thu, Apr 08, 2010 at 11:41:24PM +0800, Américo Wang wrote:
> > On Thu, Apr 08, 2010 at 05:10:06PM +0200, Heiko Carstens wrote:
> > >From: Heiko Carstens <heiko.carstens@de.ibm.com>
> > >
> > >Revert ba168fc37dea145deeb8fa9e7e71c748d2e00d74 "memory-hotplug: add 0x prefix
> > >to HEX block_size_bytes" since it changes the user space visible sysfs interface
> > >/sys/devices/system/memory/block_size_bytes.
> > >The change breaks existing user space applications which rely on the fact that
> > >the output does not contain the "0x" prefix.
> > 
> > Odd.
> > 
> > Which application relies on this? Isn't the application which should
> > be fixed?? It should use something like strtoul() which doesn't
> > rely on '0x' prefix.
> 
> Ok, consider it the other way round: your application is doing strtoul()
> with a base of 0 (since you rely on the 0x prefix) and for no good reason
> it doesn't work on older kernels.
> I really can't see a reason for adding additional pitfalls by _changing_
> a long existing user space interface.

Ack to revert it. Sorry for killing your time! 

Thanks,
Fengguang
