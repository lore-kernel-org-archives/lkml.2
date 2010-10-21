Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239Ab0JUCsH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 22:48:07 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57395 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757028Ab0JUCsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 22:48:06 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 21 Oct 2010 11:42:40 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Steve Magnani" <steve@digidescorp.com>
Cc: balbir@linux.vnet.ibm.com, linux-mm@kvack.org, dhowells@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] nommu: add anonymous page memcg accounting
Message-Id: <20101021114240.8d27d39f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <WC20101021023516.32042E@digidescorp.com>
References: <1287491654-4005-1-git-send-email-steve@digidescorp.com>
	<20101019154819.GC15844@balbir.in.ibm.com>
	<1287512657.2500.31.camel@iscandar.digidescorp.com>
	<20101020091746.f0cc5dc2.kamezawa.hiroyu@jp.fujitsu.com>
	<1287578957.2603.34.camel@iscandar.digidescorp.com>
	<20101021090847.b4e23dde.kamezawa.hiroyu@jp.fujitsu.com>
	<WC20101021023516.32042E@digidescorp.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Oct 2010 21:35:16 -0500
"Steve Magnani" <steve@digidescorp.com> wrote:

> On Thu, 2010-10-21 at 09:08 +0900, KAMEZAWA Hiroyuki wrote:
> > I myself can't maintain NOMMU kernel. So, please test every -rc1 when
> > this patch merged. OK ?
> 
> It's reasonable to ask that features be tested every so often, and since the memory cgroup code seems to be 
> changing relatively frequently it probably needs exercising more often. I can't commit to this, though - I 
> don't know how much longer I'll be working with NOMMU kernels, and they are notoriously fragile. Any memory 
> access bug that would cause an oops (or SEGV) in a "normal" kernel can cause subtle and almost impossible to 
> debug behavior on a NOMMU system. For this reason I always try to work with "stable" kernels (recent threads 
> debating the term notwithstanding)...so it would be a pretty far jump to a -rc1 kernel.
> 
> Is this a showstopper (in which case David's patch to make the CGROUP_MEM_RES_CTLR Kconfig option depend on MMU 
> should be implemented), or should I post V3 of the patch that has Balbir's suggested change? 
> 

I asked just because I'm curious and maintainance is always a concern.
But it's not showstopper.

BTW, my request is updating Documentaion as:
 
 1. Please clarify "When reaching limit, OOM-Kill is inoved."
 2. Add TODO List.
    For example)For NOMMU guys, you don't need page_cgroup->lru because no page reclaim happens.
    I think you can delete page_cgroup->lru and save much memmory.

I'll ack if v3 seems O.K. But I'm sorry it's in merge-window and people will be busy
for a while. please be patient.

Thanks,
-Kame

