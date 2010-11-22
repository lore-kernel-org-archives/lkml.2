Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622Ab0KWAox (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 19:44:53 -0500
Received: from mga01.intel.com ([192.55.52.88]:48559 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932339Ab0KWAow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 19:44:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,239,1288594800"; 
   d="scan'208";a="629358437"
Date: Tue, 23 Nov 2010 07:23:02 +0800
From: Shaohui Zheng <shaohui.zheng@intel.com>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, ak@linux.intel.com, shaohui.zheng@linux.intel.com,
        Haicheng Li <haicheng.li@intel.com>
Subject: Re: [8/8,v3] NUMA Hotplug Emulator: documentation
Message-ID: <20101122232302.GA11727@shaohui>
References: <20101117020759.016741414@intel.com>
 <20101117021000.985643862@intel.com>
 <20101121150344.GK9099@hack>
 <20101121233351.GA7626@shaohui>
 <20101122160412.GE4137@hack>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101122160412.GE4137@hack>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 12:04:12AM +0800, Américo Wang wrote:
> On Mon, Nov 22, 2010 at 07:33:51AM +0800, Shaohui Zheng wrote:
> >On Sun, Nov 21, 2010 at 11:03:45PM +0800, Américo Wang wrote:
> >> 
> >> >From your documentation above, it looks like you are trying
> >> to move one CPU between nodes?
> >Yes, you are correct. With cpu probe/release interface, you can hot-remove a
> >CPU from a node, and hot-add it to another node.
> 
> 
> Can I also move the CPU to another node _after_ it is hot-added?
> Or I have to hot-remove it first and then hot-add it again?
of course you can. you can hot-remove it via cpu/release interface, and then hot-add 
it by cpu/probe interface.

With the cpu probe/reelase interface, we can design some stress test cases to hot add/remove
cpu by script.
> 
> >> 
> >> >+	cpu_hpe=on/off
> >> >+		Enable/disable cpu hotplug emulation with software method. when cpu_hpe=on,
> >> >+		sysfs provides probe/release interface to hot add/remove cpu dynamically.
> >> >+		this option is disabled in default.
> >> >+			
> >> 
> >> Why not just a CONFIG? IOW, why do we need to make another boot
> >> parameter for this?
> >Only the developer or QA will use the emulator, we did not want to change the
> >default action for common user who does not care the hotplug emulator, so we
> >use a kernel parameter as a switch. The common user is not aware the existence
> >of the emulator.
> >
> 
> I think it is also useful to other Linux users, e.g. after I
> boot with "maxcpus=1", I can still bring the rest 3 CPU's
> back without reboot.
You understand it very well. the probe/release on ppc is already implemented,
but for x86, it is a feature missing, so we finished it with these patches.

> 
> Thanks.
> 
> -- 
> Live like a child, think like the god.
>  

-- 
Thanks & Regards,
Shaohui

