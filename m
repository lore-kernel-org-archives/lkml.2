Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919Ab1EKXIE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 19:08:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:7472 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753402Ab1EKXIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 19:08:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,354,1301900400"; 
   d="scan'208";a="1091436"
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Lutomirski <luto@mit.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel falls apart under light memory pressure (i.e. linking vmlinux)
References: <BANLkTi=XqROAp2MOgwQXEQjdkLMenh_OTQ@mail.gmail.com>
Date: Wed, 11 May 2011 16:07:40 -0700
In-Reply-To: <BANLkTi=XqROAp2MOgwQXEQjdkLMenh_OTQ@mail.gmail.com> (Andrew
	Lutomirski's message of "Wed, 11 May 2011 18:42:38 -0400")
Message-ID: <m2fwokj0oz.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Lutomirski <luto@mit.edu> writes:
>
> I can sometimes (but not always) trigger this by enabling swap and
> running dirty_ram 2048 (attached).  (One time it took the system down
> completely.  I have ~8 GB of swap, all of which was empty when I ran

Never configure that much swap (> 1*RAM). It will just make any OOM more
painful because it'll thrash forever. If you're 4x overcommited
no workload will be happy.

> This box is a Lenovo X220 Sandy Bridge laptop with 2G of RAM (the old
> box had more) and runs ext4 on LVM on dm-crypt on an SSD.  I see the

FWIW i had problems in swapping over dmcrypt for a long time -- not
quite as severe as you. Never really tracked it down.

But I suspect just not doing the swap over dmcrypt would make
it a lot more usable.

> If I had to guess, I'd say that the VM gets confused when it's forced
> to write data out to my LVM-over-dm-crypt partition and either starts
> OOM-killing things when it's not out of memory or deadlocks because it
> runs out of available RAM and can't service new dm-crypt and block
> requests.
>
> Please help fix/debug this.  It's making my shiny new laptop almost useless.

I would add some tracing to the dmcrypt paths and then log 
it over the network during the problem. Most likely some part
of it stalls or tries to allocate more memory.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
