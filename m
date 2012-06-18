Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab2FRX1t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 19:27:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:23268 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464Ab2FRX1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 19:27:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="181812340"
From: Andi Kleen <andi@firstfloor.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Li Yu <raise.sail@gmail.com>, Changli Gao <xiaosuo@gmail.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        davidel@xmailserver.org
Subject: Re: [RFC] Introduce to batch variants of accept() and epoll_ctl() syscall
References: <4FDAB652.6070201@gmail.com>
	<CABa6K_H3NrvvZ3Bh7JqsR6h33BSqYPBenUDG5Yt1U=2VvP700g@mail.gmail.com>
	<4FDACA26.70004@gmail.com> <1339750318.7491.70.camel@edumazet-glaptop>
Date: Mon, 18 Jun 2012 16:27:47 -0700
In-Reply-To: <1339750318.7491.70.camel@edumazet-glaptop> (Eric Dumazet's
	message of "Fri, 15 Jun 2012 10:51:58 +0200")
Message-ID: <m2fw9s8aks.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> writes:
>
> I believe accept() is the problem here, because it contends with the
> softirq processing the tcp session handshake.

The MOSBENCH people some time ago did a per CPU accept queue. This is
probably overkill, but there are clearly some scaling problems here
with enough cores.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
