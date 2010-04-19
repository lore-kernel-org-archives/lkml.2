Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab0DSKIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 06:08:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35728 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753540Ab0DSKIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 06:08:35 -0400
Message-ID: <4BCC2B9D.8050008@redhat.com>
Date: Mon, 19 Apr 2010 13:08:29 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: Re: [BUG] kvm: dereference srcu-protected pointer without srcu_read_lock()
 held
References: <4BCC2543.7050104@cn.fujitsu.com> <4BCC295D.1040807@cn.fujitsu.com>
In-Reply-To: <4BCC295D.1040807@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2010 12:58 PM, Lai Jiangshan wrote:
> Applied the patch I just sent and let CONFIG_PROVE_RCU=y,
> we can got the following dmesg. And we found that it is
> because some codes in KVM dereferences srcu-protected pointer without
> srcu_read_lock() held or update-side lock held.
>
> It is not hard to fix, the problem is that:
> Where is the most proper place to put a srcu_read_lock()?
>
> I can not determine the answer, so I report this bug
> instead of fixing it.
>
>    

I think the else branch in complete_pio() should work.  Marcelo?

Longer term I'd like to see the lock taken at the high levels (ioctls, 
in virt/kvm) and dropped only for guest entry and when we explicitly 
sleep (hlt emulation).

Note: complete_pio() is gone in the current code.

-- 
error compiling committee.c: too many arguments to function

