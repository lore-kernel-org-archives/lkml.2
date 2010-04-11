Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab0DKUsY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 16:48:24 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39221 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab0DKUsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 16:48:23 -0400
To: David Miller <davem@davemloft.net>
Cc: cristiklein@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tcp: add setsockopt to disable slow start after idle
From: Andi Kleen <andi@firstfloor.org>
References: <1270863015-19597-1-git-send-email-cristiklein@gmail.com>
	<20100409.221307.246951787.davem@davemloft.net>
Date: Sun, 11 Apr 2010 22:48:19 +0200
In-Reply-To: <20100409.221307.246951787.davem@davemloft.net> (David Miller's message of "Fri, 09 Apr 2010 22:13:07 -0700 (PDT)")
Message-ID: <87hbnhbtrg.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:
>
> It is a very dangerous option to enable, and depends deeply
> upon the characteristics of your network and the paths by
> which remote hosts are reached.
>
> Therefore, only the system administrator can determine whether it is
> safe to enable this, and that's why it can only be changed via sysctl.
> Lettting arbitrary applications change this aspect of TCP is beyond
> dangerous.
>
> I will not be applying this patch.

It should be safe as long as you don't have any packet loss (which
means the network can take it). Or I am missing something?

So perhaps allow it, but force disable it on the first retransmit?

There could be still some over subscription in the first window,
but hopefully not too bad.

Ok it could be still gamed by opening lots of sockets, but that
problem is there anyways.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
