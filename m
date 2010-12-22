Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab0LVIsZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 03:48:25 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:39765 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab0LVIsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 03:48:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=W+GOCDtIYaMObJGnfFWNIhgNN1tFHD98P6i7b2Hkp7Anv69N7MmhYylwdKd891jCzG
         Zbw692fhjxik8iCpKOMgSgzPZMwvyjMifhYMXcu4z+yiKi0AIlEruDFEOvrEh5B6Dn1l
         p645NcjJeeLnh83nSs3J8/z2Jx6KgrDiIPxpY=
Date: Wed, 22 Dec 2010 09:48:19 +0100
From: Tejun Heo <tj@kernel.org>
To: David Miller <davem@davemloft.net>
Cc: mchan@broadcom.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next-2.6] bnx2: remove cancel_work_sync() from
 remove_one
Message-ID: <20101222084816.GA27861@htj.dyndns.org>
References: <4D08C81D.8020606@kernel.org>
 <20101220.131146.115941299.davem@davemloft.net>
 <20101221105103.GA32744@htj.dyndns.org>
 <20101221.122000.183069341.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101221.122000.183069341.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Dec 21, 2010 at 12:20:00PM -0800, David Miller wrote:
> From: Tejun Heo <tj@kernel.org>
> Date: Tue, 21 Dec 2010 11:51:04 +0100
> 
> > Yeah, I agree the synchronize_rcu() there would guarantee the actual
> > timer completion but as it currently stands it looks a bit too subtle.
> > Maybe it's a good idea to add a big fat comment explaining that the
> > the timer is guaranteed to stop after close() and how it's guaranteed
> > through synchronize_rcu() at the moment?  Also, it might be better to
> > use synchronize_sched() there as timer synchronization through
> > synchronize_rcu() is more of a happy accident.
> 
> I'm not sure the synchronize_*() is even necessary to guarentee
> watchdog timer completion.
> 
> Like I said, I think the netif_tx_lock() held around both the timer
> function itself, and the del_timer() call, are sufficient.
> 
> So, this ensures that the watchdog timer either runs to completion or
> sees the no-op scheduler attached and returns immediately without
> rescheduling the timer.
> 
> In any event, I'm going to apply your bnx2 patch to net-next-2.6

Oh, yeah, all is good if the timer is guaranteed to stop after close
one way or the other.  Thanks and happy new year!

-- 
tejun
