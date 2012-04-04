Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab2DDXOZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 19:14:25 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56833 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757286Ab2DDXOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 19:14:24 -0400
Date: Wed, 4 Apr 2012 16:14:21 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tejun Heo <tj@kernel.org>
cc: Mike Galbraith <mgalbraith@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <paul@paulmenage.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] cgroups: disallow attaching kthreadd
In-Reply-To: <20120404230922.GC2173@dhcp-172-17-108-109.mtv.corp.google.com>
Message-ID: <alpine.DEB.2.00.1204041611430.18500@chino.kir.corp.google.com>
References: <1333475906.7439.7.camel@marge.simpson.net> <alpine.DEB.2.00.1204040008040.5356@chino.kir.corp.google.com> <1333535915.7188.18.camel@marge.simpson.net> <alpine.DEB.2.00.1204040419450.23137@chino.kir.corp.google.com> <1333542649.7188.40.camel@marge.simpson.net>
 <alpine.DEB.2.00.1204041414220.26086@chino.kir.corp.google.com> <20120404230922.GC2173@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2012, Tejun Heo wrote:

> I don't see much problem with the proposed solution and am gonna take
> it unless there are pretty good reasons not to.
> 

The only cgroup that cannot allow kthreadd is cpusets and that's 
illustrated by Mike's changelog.  Restricting it for all cgroups is 
completely unnecessary, as I've already said, and is the entire reason we 
have ->can_attach() functions for each cgroup.

Also see Paul Menage's suggestion for only isolating this fix to cpusets 
as well at 
http://lkml.indiana.edu/hypermail/linux/kernel/1110.2/01280.html.

Thanks.
