Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037Ab1HXHyk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 03:54:40 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46227 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab1HXHyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 03:54:38 -0400
Date: Wed, 24 Aug 2011 09:54:33 +0200
From: Tejun Heo <tj@kernel.org>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: rjw@sisk.pl, paul@paulmenage.org, lizf@cn.fujitsu.com,
        containers@lists.linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 4/6] cgroup: don't use subsys->can_attach_task() or
 ->attach_task()
Message-ID: <20110824075433.GB14170@htj.dyndns.org>
References: <1314138000-2049-1-git-send-email-tj@kernel.org>
 <1314138000-2049-5-git-send-email-tj@kernel.org>
 <20110824015739.GE28444@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110824015739.GE28444@count0.beaverton.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Aug 23, 2011 at 06:57:39PM -0700, Matt Helsley wrote:
> On Wed, Aug 24, 2011 at 12:19:58AM +0200, Tejun Heo wrote:
> 
> <snip>
> 
> > * In cgroup_freezer, remove unnecessary NULL assignments to unused
> >   methods.  It's useless and very prone to get out of sync, which
> >   already happened.
> 
> You could post this part independently -- that might be best since
> I guess the taskset bits will need more discussion.

Urgh... I really think subsystems which aren't very isolated should
have its own tree.  Going through -mm works well if the changes are
isolated or all inter-dependent changes go through -mm too but it
stops working as soon as the changes start span across other git
trees.  If cgroup isn't expected to see a lot of changes in this cycle
(if so, please set up a git tree, it isn't difficult), the best
solution, I think, would be sticking w/ Rafael's branch.

Thanks.

-- 
tejun
