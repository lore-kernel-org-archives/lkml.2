Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930Ab2CMAOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:14:22 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:53126 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756570Ab2CMAOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:14:21 -0400
Date: Mon, 12 Mar 2012 17:14:11 -0700 (PDT)
Message-Id: <20120312.171411.899890153797891857.davem@davemloft.net>
To: skinsbursky@parallels.com
Cc: xemul@parallels.com, ebiederm@aristanetworks.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, shemminger@vyatta.com, devel@openvz.org
Subject: Re: [PATCH v3] tun: don't hold network namespace by tun sockets
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120312125833.24166.72610.stgit@localhost6.localdomain6>
References: <20120312125833.24166.72610.stgit@localhost6.localdomain6>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 12 Mar 2012 17:14:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

aFrom: Stanislav Kinsbursky <skinsbursky@parallels.com>
Date: Mon, 12 Mar 2012 16:59:41 +0400

> v3: added previously removed sock_put() to the tun_release() callback, because
> sk_release_kernel() doesn't drop the socket reference.
> 
> v2: sk_release_kernel() used for socket release. Dummy tun_release() is
> required for sk_release_kernel() ---> sock_release() ---> sock->ops->release()
> call.
> 
> TUN was designed to destroy it's socket on network namesapce shutdown. But this
> will never happen for persistent device, because it's socket holds network
> namespace.
> This patch removes of holding network namespace by TUN socket and replaces it
> by creating socket in init_net and then changing it's net it to desired one. On
> shutdown socket is moved back to init_net prior to final put.
> 
> Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>

Looks good, applied, thanks.
