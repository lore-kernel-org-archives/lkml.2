Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab2DEIAY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 04:00:24 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56621 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab2DEIAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 04:00:23 -0400
Date: Thu, 5 Apr 2012 01:00:20 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mike Galbraith <mgalbraith@suse.de>
cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Menage <paul@paulmenage.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [patch] cgroups: disallow attaching kthreadd
In-Reply-To: <1333611379.7783.143.camel@marge.simpson.net>
Message-ID: <alpine.DEB.2.00.1204050055180.13439@chino.kir.corp.google.com>
References: <1333475906.7439.7.camel@marge.simpson.net> <alpine.DEB.2.00.1204040008040.5356@chino.kir.corp.google.com> <1333535915.7188.18.camel@marge.simpson.net> <alpine.DEB.2.00.1204040419450.23137@chino.kir.corp.google.com> <1333542649.7188.40.camel@marge.simpson.net>
 <alpine.DEB.2.00.1204041414220.26086@chino.kir.corp.google.com> <20120404230922.GC2173@dhcp-172-17-108-109.mtv.corp.google.com> <1333601231.7783.31.camel@marge.simpson.net> <alpine.DEB.2.00.1204042157530.31186@chino.kir.corp.google.com>
 <1333604949.7783.76.camel@marge.simpson.net> <alpine.DEB.2.00.1204042303510.7035@chino.kir.corp.google.com> <1333608177.7783.106.camel@marge.simpson.net> <alpine.DEB.2.00.1204042344090.8991@chino.kir.corp.google.com>
 <1333611379.7783.143.camel@marge.simpson.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Apr 2012, Mike Galbraith wrote:

> That question made perfect sense to me.  Putting a global resource in
> any bin of any sort makes little if any sense.
> 

This has nothing to do with global resources, it has to do with 
PF_THREAD_BOUND since those threads cannot move amongst these cgroups.

For cgroups that do not have anything to do with cpu affinity, 
PF_THREAD_BOUND means nothing to their attachment rules.  This patch is 
addressing kthreadd since it, as the changelog says, has the ability to 
spawn threads that become PF_THREAD_BOUND.  By logic, we then can't allow 
kthreadd to be attached to cgroups where PF_THREAD_BOUND matters either.

I know we've been through several iterations on this over the past several 
months and the patch getting dropped a couple times along the way, but I 
really do appreciate your time and effort spent in developing this fix, 
it's very helpful.
