Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab1FSXYJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 19:24:09 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:51437 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754765Ab1FSXYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 19:24:06 -0400
Date: Sun, 19 Jun 2011 16:22:18 -0700 (PDT)
Message-Id: <20110619.162218.1110628316477222542.davem@davemloft.net>
To: ebiederm@xmission.com
Cc: containers@lists.osdl.org, adobriyan@gmail.com, netdev@vger.kernel.org,
        equinox@diac24.net, linux-kernel@vger.kernel.org, serge@hallyn.com
Subject: Re: [PATCH 2/2] proc: Usable inode numbers for the namespace file
 descriptors.
From: David Miller <davem@davemloft.net>
In-Reply-To: <m1mxhgav9c.fsf_-_@fess.ebiederm.org>
References: <20110523014751.GB2351982@jupiter.n2.diac24.net>
	<m1wrgkavbm.fsf_-_@fess.ebiederm.org>
	<m1mxhgav9c.fsf_-_@fess.ebiederm.org>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 19 Jun 2011 16:22:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 17 Jun 2011 16:33:19 -0700

> 
> Assign a unique proc inode to each namespace, yielding an
> identifier that userspace can use for identifying a namespace.
> 
> This has been a long requested feature and only blocked because
> a naive implementation would put the id in a global space and
> would ultimately require having a namespace for the names of
> namespaces, making migration and certain virtualization tricks
> impossible.
> 
> We still don't have per superblock inode numbers for proc, which
> appears necessary for application unaware checkpoint/restart and
> migrations (if the application is using namespace filedescriptors)
> but that is now allowd by the design if it becomes important.
> 
> I have preallocated the ipc and uts initial proc inode numbers so
> their structures can be statically initialized.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

For networking bits:

Acked-by: David S. Miller <davem@davemloft.net>
