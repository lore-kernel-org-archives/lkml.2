Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248Ab1KUWDg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 17:03:36 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59390 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab1KUWDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 17:03:33 -0500
Date: Mon, 21 Nov 2011 14:03:26 -0800
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: paul@paulmenage.org, rjw@sisk.pl, lizf@cn.fujitsu.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, matthltc@us.ibm.com,
        akpm@linux-foundation.org, oleg@redhat.com,
        kamezawa.hiroyu@Jp.fujitsu.com
Subject: Re: [PATCH 03/10] threadgroup: extend threadgroup_lock() to cover
 exit and exec
Message-ID: <20111121220326.GM25776@google.com>
References: <1320191193-8110-1-git-send-email-tj@kernel.org>
 <1320191193-8110-4-git-send-email-tj@kernel.org>
 <20111113164426.GB9446@somewhere>
 <20111114135404.GD9446@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111114135404.GD9446@somewhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 14, 2011 at 02:54:08PM +0100, Frederic Weisbecker wrote:
> > Also note this is currently protected by the tasklist readlock. Cred guard mutex is
> > certainly better, I just don't remember if you remove the tasklist lock in a
> > further patch.
> 
> Ah recalling what Ben Blum said, we also need the leader to stay stable because it
> is excpected to be passed in ->can_attach(), ->attach(), ->cancel_attach(), ...
> Although that's going to change after your patches that pass a flex array.

Not really without locking out exec.  The thing is whoever is exec'ing
will be the leader and we can't guarantee that the first in the flex
array is always the leader.  One method may see it as the leader, the
next one might not.

Thanks.

-- 
tejun
