Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449Ab1JNMVg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 08:21:36 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60627 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756298Ab1JNMVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 08:21:35 -0400
Date: Fri, 14 Oct 2011 14:21:30 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ben Blum <bblum@andrew.cmu.edu>, Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, NeilBrown <neilb@suse.de>,
        paulmck@linux.vnet.ibm.com, Paul Menage <paul@paulmenage.org>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 2/2] cgroups: convert ss->attach to use whole threadgroup
 flex_array (cpuset, memcontrol)
Message-ID: <20111014122126.GL14968@somewhere>
References: <20110727171101.5e32d8eb@notabene.brown>
 <20110727150710.GB5242@unix33.andrew.cmu.edu>
 <20110727234235.GA2318@linux.vnet.ibm.com>
 <20110728110813.7ff84b13@notabene.brown>
 <20110728062616.GC15204@unix33.andrew.cmu.edu>
 <20110728171345.67d3797d@notabene.brown>
 <20110729142842.GA8462@unix33.andrew.cmu.edu>
 <20110815184957.GA16588@redhat.com>
 <20111014003601.GC22527@ghc17.ghc.andrew.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111014003601.GC22527@ghc17.ghc.andrew.cmu.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 08:36:01PM -0400, Ben Blum wrote:
> Convert ss->attach to take a flex_array of tasks instead of just the leader.
> 
> From: Ben Blum <bblum@andrew.cmu.edu>
> 
> This lets subsystems with whole-threadgroup attach calls (i.e., cpuset and
> memcontrol) to accurately find the group's mm even when a non-leader does exec
> and leaves the leader with a NULL mm pointer.
> 
> Also converts cpuset and memcontrol to take the flex_array and iterate down it
> until an mm is found, instead of just attempting to use the leader's mm.
> 
> Signed-off-by: Ben Blum <bblum@andrew.cmu.edu>

I think there are patches from Tejun that handle that did that already?

https://lkml.org/lkml/2011/8/23/418
