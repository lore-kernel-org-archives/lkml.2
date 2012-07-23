Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab2GWICQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 04:02:16 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42931 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab2GWICK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 04:02:10 -0400
Date: Mon, 23 Jul 2012 01:02:09 -0700 (PDT)
Message-Id: <20120723.010209.288436778718842333.davem@davemloft.net>
To: wpan@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] rds: set correct msg_namelen
From: David Miller <davem@davemloft.net>
In-Reply-To: <5181687def9991f9878460d932bd31c64f9ad0cb.1343010976.git.wpan@redhat.com>
References: <5181687def9991f9878460d932bd31c64f9ad0cb.1343010976.git.wpan@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Weiping Pan <wpan@redhat.com>
Date: Mon, 23 Jul 2012 10:37:48 +0800

> Jay Fenlason (fenlason@redhat.com) found a bug,
> that recvfrom() on an RDS socket can return the contents of random kernel
> memory to userspace if it was called with a address length larger than
> sizeof(struct sockaddr_in).
> rds_recvmsg() also fails to set the addr_len paramater properly before
> returning, but that's just a bug.
> There are also a number of cases wher recvfrom() can return an entirely bogus
> address. Anything in rds_recvmsg() that returns a non-negative value but does
> not go through the "sin = (struct sockaddr_in *)msg->msg_name;" code path
> at the end of the while(1) loop will return up to 128 bytes of kernel memory
> to userspace.
> 
> And I write two test programs to reproduce this bug, you will see that in
> rds_server, fromAddr will be overwritten and the following sock_fd will be
> destroyed.
> Yes, it is the programmer's fault to set msg_namelen incorrectly, but it is
> better to make the kernel copy the real length of address to user space in
> such case.
> 
> How to run the test programs ?
> I test them on 32bit x86 system, 3.5.0-rc7.
 ...
> Signed-off-by: Weiping Pan <wpan@redhat.com>

Applied, thanks.
