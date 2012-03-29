Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758754Ab2C2DME (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 23:12:04 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:32934 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758049Ab2C2DL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 23:11:57 -0400
Date: Thu, 29 Mar 2012 11:11:37 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Sven Eckelmann <sven@narfation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, simon.wunderlich@s2003.tu-chemnitz.de,
        Marek Lindner <lindner_marek@yahoo.de>
Subject: Re: Using nested locking for spin_lock_bh
Message-ID: <20120329031136.GA2062@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <2108147.Aqyix6xDmB@bentobox>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2108147.Aqyix6xDmB@bentobox>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 06:36:39PM +0200, Sven Eckelmann wrote:
> Hi,
> 
> I started to run some experimental batman-adv code inside some virtual 
> machines with different debugging functions enabled. One of them was lockdep. 
> There we noticed a false positive for a lock class that is actually used in 
> two different data structures.

Hmm, I think you can initialize the lock class in the two differnent data
structures with differnt lock_class_key.

Thanks,
Yong

> Therefore, lockdep noticed that there could be 
> a deadlock for this class in a function that locks the two different data 
> structures.
> 
> To resolve this problem, I wanted to define two different subclasses and 
> replace the spin_lock_bh with its nested version. The only problem now is the 
> absence of spin_lock_bh_nested. I could only find spin_lock_bh and 
> spin_lock_irqsave_nested.
> 
> Is there another way how this should be done or is there a general problem why 
> there is no nested support for this incarnation of spin_lock?
> 
> Kind regards,
> 	Sven



-- 
Only stand for myself
