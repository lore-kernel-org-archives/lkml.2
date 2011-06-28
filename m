Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760500Ab1F1RqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 13:46:18 -0400
Received: from lo.gmane.org ([80.91.229.12]:47305 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760424Ab1F1RpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 13:45:08 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Aditya Kali <adityakali@google.com>
Subject: Re: [RFC PATCH 4/4] cgroups: Add an rlimit subsystem
Date: Tue, 28 Jun 2011 17:37:17 +0000 (UTC)
Message-ID: <loom.20110628T193035-346@post.gmane.org>
References: <1308527474-20704-1-git-send-email-fweisbec@gmail.com> <1308527474-20704-5-git-send-email-fweisbec@gmail.com> <BANLkTin_MA+Yc7=q=cK5s2CbCfu_xmqTAQ@mail.gmail.com> <20110623134759.GC8058@somewhere.redhat.com> <BANLkTimiQBkDZ=L9UR-yGMATw9o-3JVtMEaMP36zey=_9pxL9Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 216.239.45.4 (Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.77 Safari/534.30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage <menage <at> google.com> writes:
> What we need is a res_counter_move_charge(A, B, amount) function which will:
> 
> - locate C, the nearest common ancestor of A and B
> - lock up the chain from B up to but not including C, adding the new charge
> - unlock up the chain from B to C
> - uncharge along the chain from A up to but not including C (not sure
> how much locking is needed there since there's no need for roll back).
> 
> Paul
> 

Another alternative is to use the 'attach' callback in struct cgroup_subsys which
gets both the old cgroup and the new cgroup as parameters and do
rlim_remove_proc(old_cgrp) and res_counter_charge(new_cgrp) in this same
function under the protection of a spinlock.
It would be good to add a return value to the 'attach' callback too.



