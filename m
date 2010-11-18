Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148Ab0KRUu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 15:50:59 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51494
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751443Ab0KRUu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 15:50:58 -0500
Date: Thu, 18 Nov 2010 12:51:23 -0800 (PST)
Message-Id: <20101118.125123.241932424.davem@davemloft.net>
To: npiggin@kernel.dk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 01/28] fs: d_validate fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101116142028.254946611@kernel.dk>
References: <20101116140900.039761100@kernel.dk>
	<20101116142028.254946611@kernel.dk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <npiggin@kernel.dk>
Date: Wed, 17 Nov 2010 01:09:01 +1100

> d_validate has been broken for a long time.
> 
> kmem_ptr_validate does not guarantee that a pointer can be dereferenced
> if it can go away at any time. Even rcu_read_lock doesn't help, because
> the pointer might be queued in RCU callbacks but not executed yet.
> 
> So the parent cannot be checked, nor the name hashed. The dentry pointer
> can not be touched until it can be verified under lock. Hashing simply
> cannot be used.
> 
> Instead, verify the parent/child relationship by traversing parent's
> d_child list. It's slow, but only ncpfs and the destaged smbfs care
> about it, at this point.
> 
> Signed-off-by: Nick Piggin <npiggin@kernel.dk>

This won't apply because is conflicts with Christoph Hellwig's
RCU conversion of d_validate().

Which is a change that went in more than a month ago.

Thus I'd really appreciate if you mentioned what tree your patches are
against in your "0/N" posting, always.

Thanks.
