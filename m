Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758928Ab1CCV7H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 16:59:07 -0500
Received: from mout.perfora.net ([74.208.4.194]:65386 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758263Ab1CCV7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 16:59:05 -0500
Date: Thu, 3 Mar 2011 16:58:49 -0500
From: Stephen Wilson <wilsons@start.ca>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Nick Piggin <npiggin@kernel.dk>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Enable writing to /proc/PID/mem.
Message-ID: <20110303215849.GA5893@fibrous.localdomain>
References: <1299118074-13342-1-git-send-email-wilsons@start.ca> <20110303111240.B942.A69D9226@jp.fujitsu.com> <20110303193802.GA4994@fibrous.localdomain> <20110303194626.GN22723@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110303194626.GN22723@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Provags-ID: V02:K0:+ixpW+GJXKfnQ0pg51JFWZX/H4WeFTG9klFGGJQbyQM
 mR6J43toJDBacJQFMGd0AypwXY4NFnqMPN9D87YaR6+C4OuJnP
 8cDGiJ38b7chPY4sd90G4mR26/41Z6u5pm9g9mA4N9AAdUcgo/
 ZlhDccmi2Pm40Ne7dLaVY1VyoBS+XPSMPvO4VqtSKTR9u2ZG88
 lxooI5gWbpBPSOVtt3bcNyEQA8PgE4oSV/lxc6nrb0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 07:46:26PM +0000, Al Viro wrote:
> Think what happens if the target execs suid-root binary in the middle of your
> call.  After you've done your check.  E.g. during copy_from_user().
> 
> On the read side we actually recheck permissions after having copied into
> buffer and if the check fails we don't copy that buffer into userland.
> Not feasible on the write side...

You are right.  Looks like we would need to hold task_lock over both the
permission check and write -- but I do not see a clean/simple way of doing
that today.  Might be worth looking into...

Thanks!

-- 
steve

