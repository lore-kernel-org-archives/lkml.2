Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab0DTBqz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 21:46:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473Ab0DTBqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 21:46:50 -0400
Date: Mon, 19 Apr 2010 22:45:04 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: Re: [BUG] kvm: dereference srcu-protected pointer without
 srcu_read_lock() held
Message-ID: <20100420014504.GB17981@amt.cnet>
References: <4BCC2543.7050104@cn.fujitsu.com>
 <4BCC295D.1040807@cn.fujitsu.com>
 <4BCC2B9D.8050008@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BCC2B9D.8050008@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 19, 2010 at 01:08:29PM +0300, Avi Kivity wrote:
> On 04/19/2010 12:58 PM, Lai Jiangshan wrote:
> >Applied the patch I just sent and let CONFIG_PROVE_RCU=y,
> >we can got the following dmesg. And we found that it is
> >because some codes in KVM dereferences srcu-protected pointer without
> >srcu_read_lock() held or update-side lock held.
> >
> >It is not hard to fix, the problem is that:
> >Where is the most proper place to put a srcu_read_lock()?
> >
> >I can not determine the answer, so I report this bug
> >instead of fixing it.
> >
> 
> I think the else branch in complete_pio() should work.  Marcelo?
> 
> Longer term I'd like to see the lock taken at the high levels
> (ioctls, in virt/kvm) and dropped only for guest entry and when we
> explicitly sleep (hlt emulation).
> 
> Note: complete_pio() is gone in the current code.

Yes, this was fixed by 7fb2ea1e6.

