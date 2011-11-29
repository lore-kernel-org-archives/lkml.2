Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab1K2Td1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 14:33:27 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:42300 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626Ab1K2Td0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 14:33:26 -0500
Date: Tue, 29 Nov 2011 14:35:28 -0500 (EST)
Message-Id: <20111129.143528.342322755.davem@davemloft.net>
To: xi.wang@gmail.com
Cc: vladislav.yasevich@hp.com, linux-kernel@vger.kernel.org, sri@us.ibm.com,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        security@kernel.org
Subject: Re: [PATCH v2] sctp: better integer overflow check in
 sctp_auth_create_key()
From: David Miller <davem@davemloft.net>
In-Reply-To: <125BB325-72D4-4FEF-A5CC-118680EC78D2@gmail.com>
References: <4ED4F428.9030807@hp.com>
	<A1A6AF9D-8C35-4702-9693-7BCBEDE27219@gmail.com>
	<125BB325-72D4-4FEF-A5CC-118680EC78D2@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 29 Nov 2011 11:31:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xi Wang <xi.wang@gmail.com>
Date: Tue, 29 Nov 2011 14:26:30 -0500

> The check from commit 30c2235c is incomplete and cannot prevent
> cases like key_len = 0x80000000 (INT_MAX + 1).  In that case, the
> left-hand side of the check (INT_MAX - key_len), which is unsigned,
> becomes 0xffffffff (UINT_MAX) and bypasses the check.
> 
> However this shouldn't be a security issue.  The function is called
> from the following two code paths:
> 
>  1) setsockopt()
> 
>  2) sctp_auth_asoc_set_secret()
> 
> In case (1), sca_keylength is never going to exceed 65535 since it's
> bounded by a u16 from the user API.  As such, the key length will
> never overflow.
> 
> In case (2), sca_keylength is computed based on the user key (1 short)
> and 2 * key_vector (3 shorts) for a total of 7 * USHRT_MAX, which still
> will not overflow.
> 
> In other words, this overflow check is not really necessary.  Just
> make it more correct.
> 
> Signed-off-by: Xi Wang <xi.wang@gmail.com>
> Cc: Vlad Yasevich <vladislav.yasevich@hp.com>

I already applied your patch, you cannot just post a patch as if
it hasn't been applied to the tree, it doesn't work like that.

Once I've applied one of your patches, it is "cast in stone" and
cannot be reverted.  You must therefore develop relative to the
change.
