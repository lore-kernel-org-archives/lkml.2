Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758711Ab1ELVGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 17:06:19 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:59490 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758662Ab1ELVGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 17:06:17 -0400
Date: Thu, 12 May 2011 17:06:03 -0400 (EDT)
Message-Id: <20110512.170603.549349521517995900.davem@davemloft.net>
To: joe@perches.com
Cc: vladislav.yasevich@hp.com, sri@us.ibm.com, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] sctp: sctp_sendmsg: Don't initialize default_sinfo
From: David Miller <davem@davemloft.net>
In-Reply-To: <a4e846ed62d7f9222dc9b09ca00b5356a1eb9b73.1305227620.git.joe@perches.com>
References: <cover.1305227620.git.joe@perches.com>
	<a4e846ed62d7f9222dc9b09ca00b5356a1eb9b73.1305227620.git.joe@perches.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 12 May 2011 14:06:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Thu, 12 May 2011 12:19:09 -0700

> This variable only needs initialization when cmsgs.info
> is NULL.
> 
> Don't use memset, just initialize every struct member.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

I don't think you do this, this structure has padding holes on pretty
much every architecture.

It starts with 3 u16's, then there is a u32, so there is a 2-byte
piece of padding after the 3rd u16.

Can you prove that these uninitialized portions never make it to
userspace?  If you can, that proof belongs in the commit message.

I think it's too risky.
