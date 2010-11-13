Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab0KMM6E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 07:58:04 -0500
Received: from canuck.infradead.org ([134.117.69.58]:35553 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322Ab0KMM6C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 07:58:02 -0500
Subject: Re: [BUG 2.6.27-rc1] find_busiest_group() LOCKUP
From: Peter Zijlstra <peterz@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Nikanth Karthikesan <knikanth@suse.de>,
        Yinghai Lu <yinghai@kernel.org>, David Rientjes <rientjes@google.com>,
        "Zheng, Shaohui" <shaohui.zheng@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-hotplug@vger.kernel.org" <linux-hotplug@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        Venkatesh Pallipadi <venki@google.com>, Nikhil Rao <ncrao@google.com>,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20101113120030.GA31517@localhost>
References: <20101111100628.GA24728@localhost>
	 <1289478978.2084.74.camel@laptop> <20101111124015.GA9706@localhost>
	 <1289480656.2084.80.camel@laptop> <20101113084018.GA23098@localhost>
	 <1289644224.2084.521.camel@laptop>  <20101113120030.GA31517@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 13 Nov 2010 13:57:58 +0100
Message-ID: <1289653078.2084.675.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-11-13 at 20:00 +0800, Wu Fengguang wrote:
> On Sat, Nov 13, 2010 at 06:30:24PM +0800, Peter Zijlstra wrote:
> > On Sat, 2010-11-13 at 16:40 +0800, Wu Fengguang wrote:
> > > > Will try and figure out how the heck that's happening, Ingo any clue?
> > > 
> > > It's back to normal on 2.6.37-rc1 when reverting commit 50f2d7f682f9
> > > ("x86, numa: Assign CPUs to nodes in round-robin manner on fake NUMA").
> > > 
> > > The interesting part is, the commit was introduced in 
> > > 2.6.36-rc7..2.6.36, however 2.6.36 boots OK, while 2.6.37-rc1 panics.
> > 
> > Argh, that commit again..
> > 
> > Does this fix it: http://lkml.org/lkml/2010/11/12/8
> 
> No it still panics. Here is the dmesg.

OK, I'll let Nikanth have a look, if all else fails we can always revert
that patch.
