Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426Ab2HHVeR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 17:34:17 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46453 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073Ab2HHVeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 17:34:13 -0400
Date: Wed, 08 Aug 2012 14:34:10 -0700 (PDT)
Message-Id: <20120808.143410.991859746378752444.davem@davemloft.net>
To: ycheng@google.com
Cc: skinsbursky@parallels.com, netdev@vger.kernel.org, ruanzhijie@hotmail.com,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [RFC PATCH] tun: don't zeroize sock->file on detach
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAK6E8=cpODYa1xURk7BZBnWwx5q3OD8-xkCau7GNPn+1BS0oQQ@mail.gmail.com>
References: <20120711114753.24395.53193.stgit@localhost6.localdomain6>
	<50226147.3010309@parallels.com>
	<CAK6E8=cpODYa1xURk7BZBnWwx5q3OD8-xkCau7GNPn+1BS0oQQ@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yuchung Cheng <ycheng@google.com>
Date: Wed, 8 Aug 2012 10:48:32 -0700

> On Wed, Aug 8, 2012 at 5:53 AM, Stanislav Kinsbursky
> <skinsbursky@parallels.com> wrote:
>> Hi, Dave.
>> What about this patch?
>>
>>
>> On Wed, Jul 11, 2012 at 03:48:20PM +0400, Stanislav Kinsbursky wrote:
>>>
>>> This is a fix for bug, introduced in 3.4 kernel by commit
>>> 1ab5ecb90cb6a3df1476e052f76a6e8f6511cb3d, which, among other things,
>>> replaced
>>> simple sock_put() by sk_release_kernel(). Below is sequence, which leads
>>> to
>>> oops for non-persistent devices:
>>>
>>> tun_chr_close()
>>> tun_detach()                            <== tun->socket.file = NULL
>>> tun_free_netdev()
>>> sk_release_sock()
>>> sock_release(sock->file == NULL)
>>> iput(SOCK_INODE(sock))                  <== dereference on NULL pointer
>>>
>>> This patch just removes zeroing of socket's file from __tun_detach().
>>> sock_release() will do this.
>>>
>>> Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
> Acked-by: Yuchung Cheng <ycheng@google.com>
> 
> I has tested this patch and it works (so my kernel stops crashing
> using tun devices).

This patch needs to be formally resubmitted to netdev.
