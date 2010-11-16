Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678Ab0KPGZg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 01:25:36 -0500
Received: from mga11.intel.com ([192.55.52.93]:24441 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932251Ab0KPGZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 01:25:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,204,1288594800"; 
   d="scan'208";a="858006202"
Date: Tue, 16 Nov 2010 13:05:07 +0800
From: Shaohui Zheng <shaohui.zheng@intel.com>
To: "shaohui.zheng@linux.intel.com" <shaohui.zheng@linux.intel.com>,
        lethal@linux-sh.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [v2,5/8] NUMA Hotplug emulator
Message-ID: <20101116050507.GA21317@shaohui>
Reply-To: shaohui.zheng@linux.intel.com
Mail-Followup-To: "shaohui.zheng@linux.intel.com" <shaohui.zheng@linux.intel.com>,
	lethal@linux-sh.org, linux-kernel@vger.kernel.org
References: <20101116041330.GA20694@shaohui>
 <20101116054747.GA1064@linux-sh.org>
 <A24AE1FFE7AEC5489F83450EE98351BF27D53BCC36@shsmsx502.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A24AE1FFE7AEC5489F83450EE98351BF27D53BCC36@shsmsx502.ccr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> On Tue, Nov 16, 2010 at 12:13:30PM +0800, Shaohui Zheng wrote:
> > >This looks like an incredibly painful interface. How about scrapping all
> > >of this _emu() mess and just reworking the register_cpu() interface?
> > > Something like:
> > 
> > hi, Paul
> > 	I saw your reply on patchwork.kernel.org, but I did not find your email 
> > in my mailbox, you might forget to cc to me.
> > 
> Then fix your mailer. You are presently forcing Mail-Followup-To to the
> list, which in turn is dropping you from the cc on a group reply.

My mailer is mutt, and I did not configure "Mail-Follow-To", it should use the
default value. I add "set followup_to=no" to my ~/muttrc file now.

Hope it is got fixed, thanks you for your remind.

> 
> > 	I think that your register_cpu_node interface seems good, but this will 
> > remove the interface register_cpu. it is not the original purpose of the 
> > emulator, we want to emulate the oringal process, but we did not want to change
> > the old interface, that is a rule.
> > 
> Wait, what? How does my patch remove register_cpu()? It does no such
> thing, all it does is add a supplemental register_cpu_node() for you to
> call in to, without needing to carry any of the _emu() damage around. The
> old interface has not been modified in any way whatsoever.

I recheck your patch, It seems that I misunderstand it. with your function
register_cpu_node, we can call it in arch_cpu_probe, and then we need not the _emu()
any more. Our _emu() functions work, but it get thing complicated. :)

I will rework patch 4 and patch 5 with your suggestion, thanks.

-- 
Thanks & Regards,
Shaohui

