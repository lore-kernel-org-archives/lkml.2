Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab1HaHDc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 03:03:32 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52744 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377Ab1HaHD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 03:03:29 -0400
Date: Wed, 31 Aug 2011 09:03:13 +0200
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: rjw@sisk.pl, paul@paulmenage.org, lizf@cn.fujitsu.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, matthltc@us.ibm.com,
        kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 6/6] cgroup: kill subsys->can_attach_task(), pre_attach()
 and attach_task()
Message-ID: <20110831070313.GA29179@mtj.dyndns.org>
References: <1314312192-26885-1-git-send-email-tj@kernel.org>
 <1314312192-26885-7-git-send-email-tj@kernel.org>
 <20110830201030.GC15953@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110830201030.GC15953@somewhere.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Frederic.

On Tue, Aug 30, 2011 at 10:10:32PM +0200, Frederic Weisbecker wrote:
> In order to keep the fix queued in -mm (https://lkml.org/lkml/2011/8/26/262)
> the tasks that have failed to migrate should be removed from the iterator
> so that they are not included in the batch in ->attach().

I don't think that's a good approach.  It breaks the symmetry when
calling different callbacks.  What if ->can_attach() allocates
per-task resources and the task exits in the middle?  I think we
better lock down fork/exit/exec.  I'll send patches but I'm currently
moving / traveling w/ limited access to my toys so it might take some
time.

Thanks.

-- 
tejun
