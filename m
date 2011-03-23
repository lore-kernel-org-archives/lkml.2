Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881Ab1CWRcK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 13:32:10 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36647 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755176Ab1CWRcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 13:32:08 -0400
Date: Wed, 23 Mar 2011 18:32:06 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>,
        Jin Dongming <jin.dongming@np.css.fujitsu.com>,
        linux-kernel@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>, hughd@google.com
Subject: Re: [PATCH 3/4] Check whether pages are poisoned before copying
Message-ID: <20110323173206.GG21838@one.firstfloor.org>
References: <4D817234.9070106@jp.fujitsu.com> <4D8172D7.3040201@jp.fujitsu.com> <20110317041424.GD11094@one.firstfloor.org> <4D819A2A.8050606@jp.fujitsu.com> <20110317062612.GE11094@one.firstfloor.org> <4D81BB87.10803@jp.fujitsu.com> <20110317140401.GX10696@random.random> <20110323172616.GA2170@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110323172616.GA2170@in.ibm.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On an extended note, I don't understand why hwpoison code should not
> handle Ksm pages the same way as other user-space pages. While it is

Noone has done the work for it so far.

However we did some evaluation some time ago with some simple 
KVM setups and it turned out KSM was only very little physical memory 
overall (< few percent) Normally it's better to focus on areas with more 
payoff (= more memory), unless you can find a workload where KSM is actually 
significant.

> It appears that the restriction for PageKsm() can be removed from
> memory-failure.c code without making the races any better or worse. Any
> opinions on that?

I don't know. The KSM code paths would need to be audited first.
Hugh added the checks originally and may have an opinion.

-Andi
