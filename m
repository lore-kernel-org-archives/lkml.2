Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab0FSNGF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 09:06:05 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:57810 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755848Ab0FSNGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 09:06:01 -0400
Date: Sat, 19 Jun 2010 15:05:47 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Sage Weil <sage@newdream.net>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: inconsistent lock state
Message-ID: <20100619130547.GA6424@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Sage Weil <sage@newdream.net>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Maciej Rutecki <maciej.rutecki@gmail.com>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Lai Jiangshan <laijs@cn.fujitsu.com>,
	"David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20100615112434.GA3967@swordfish.minsk.epam.com>
 <20100618133004.228c2223.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100618133004.228c2223.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Fri, Jun 18, 2010 at 01:30:04PM -0700, Andrew Morton wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> Fix a lockdep-splat-causing regression introduced by
> 
> : commit 989a2979205dd34269382b357e6d4b4b6956b889
> : Author:     Eric Dumazet <eric.dumazet@gmail.com>
> : AuthorDate: Wed Apr 14 09:55:35 2010 +0000
> : Commit:     David S. Miller <davem@davemloft.net>
> : CommitDate: Wed Apr 21 16:19:29 2010 -0700
> : 
> :     fasync: RCU and fine grained locking
> 
> kill_fasync() can be called from both process and hard-irq context, so
> fa_lock must be taken with IRQs disabled.
> 
> Addresses https://bugzilla.kernel.org/show_bug.cgi?id=16230

Seems to work fine -- thanks!

Best,
	Dominik
