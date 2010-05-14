Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab0ENFnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 01:43:18 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:59426 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab0ENFnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 01:43:17 -0400
Date: Fri, 14 May 2010 14:42:26 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Shaohui Zheng <shaohui.zheng@intel.com>, akpm@linux-foundation.org,
       linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, Yinghai Lu <yinghai@kernel.org>,
       David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       linux-kernel@vger.kernel.org, ak@linux.intel.co, fengguang.wu@intel.com,
       haicheng.li@linux.intel.com, shaohui.zheng@linux.intel.com
Subject: Re: [RFC,2/7] NUMA Hotplug emulator
Message-ID: <20100514054226.GB12002@linux-sh.org>
References: <20100513114544.GC2169@shaohui> <20100514111615.c7ca63a5.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100514111615.c7ca63a5.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 11:16:15AM +0900, KAMEZAWA Hiroyuki wrote:
> On Thu, 13 May 2010 19:45:44 +0800
> Shaohui Zheng <shaohui.zheng@intel.com> wrote:
> 
> > x86: infrastructure of NUMA hotplug emulation
> > 
> 
> Hmm. do we have to create this for x86 only ?
> Can't we live with lmb ? as
> 
> 	lmb_hide_node() or some.
> 
> IIUC, x86-version lmb is now under development.
> 
Indeed. There is very little x86-specific about this patch series at all
except for the e820 bits and tying in the CPU topology. Most of what this
series is doing wrapping around e820 could be done on top of LMB, which
would also make it possible to use on non-x86 architectures.
