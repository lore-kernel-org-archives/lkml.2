Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab1KWOfQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 09:35:16 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51895 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab1KWOfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 09:35:13 -0500
Date: Wed, 23 Nov 2011 15:34:53 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: paul@paulmenage.org, rjw@sisk.pl, lizf@cn.fujitsu.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, matthltc@us.ibm.com,
        akpm@linux-foundation.org, oleg@redhat.com,
        kamezawa.hiroyu@Jp.fujitsu.com
Subject: Re: [PATCH 03/10] threadgroup: extend threadgroup_lock() to cover
 exit and exec
Message-ID: <20111123143444.GA14549@somewhere.redhat.com>
References: <1320191193-8110-1-git-send-email-tj@kernel.org>
 <1320191193-8110-4-git-send-email-tj@kernel.org>
 <20111113164426.GB9446@somewhere>
 <20111114135404.GD9446@somewhere>
 <20111121220326.GM25776@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111121220326.GM25776@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 02:03:26PM -0800, Tejun Heo wrote:
> On Mon, Nov 14, 2011 at 02:54:08PM +0100, Frederic Weisbecker wrote:
> > > Also note this is currently protected by the tasklist readlock. Cred guard mutex is
> > > certainly better, I just don't remember if you remove the tasklist lock in a
> > > further patch.
> > 
> > Ah recalling what Ben Blum said, we also need the leader to stay stable because it
> > is excpected to be passed in ->can_attach(), ->attach(), ->cancel_attach(), ...
> > Although that's going to change after your patches that pass a flex array.
> 
> Not really without locking out exec.  The thing is whoever is exec'ing
> will be the leader and we can't guarantee that the first in the flex
> array is always the leader.  One method may see it as the leader, the
> next one might not.

Exactly!
