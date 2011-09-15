Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934288Ab1IORoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 13:44:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:53659 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934182Ab1IORoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 13:44:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="48832400"
From: Andi Kleen <andi@firstfloor.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Thomas Meyer <thomas@m3y3r.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        viro@zeniv.linux.org.uk, mingo@redhat.com
Subject: Re: a question regarding sys_poll() on x86_64 via tha ia32 layer
References: <1316086860.6545.66.camel@localhost.localdomain>
	<1316089435.2893.6.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Date: Thu, 15 Sep 2011 10:44:13 -0700
In-Reply-To: <1316089435.2893.6.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	(Eric Dumazet's message of "Thu, 15 Sep 2011 14:23:55 +0200")
Message-ID: <m2boulg0pe.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> writes:
>  
>  SYSCALL_DEFINE3(poll, struct pollfd __user *, ufds, unsigned int, nfds,
> -		long, timeout_msecs)
> +		int, timeout_msecs)

The preferred fix is normally to write a compat wrapper that sign
extends.

Maybe someone on 64bit really wants to wait for a long time, but 
not forever.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
