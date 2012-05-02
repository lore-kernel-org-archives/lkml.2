Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab2EBOcn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 10:32:43 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58363 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193Ab2EBOcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 10:32:41 -0400
Subject: Re: [PATCH v2] net: l2tp: unlock socket lock before returning from
 l2tp_ip_sendmsg
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: davem@davemloft.net, jchapman@katalix.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davej@redhat.com
In-Reply-To: <1335967123-2588-1-git-send-email-levinsasha928@gmail.com>
References: <1335967123-2588-1-git-send-email-levinsasha928@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 May 2012 16:32:36 +0200
Message-ID: <1335969156.22133.570.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-02 at 15:58 +0200, Sasha Levin wrote:
> l2tp_ip_sendmsg could return without releasing socket lock, making it all the
> way to userspace, and generating the following warning:
> 
> [  130.891594] ================================================
> [  130.894569] [ BUG: lock held when returning to user space! ]
> [  130.897257] 3.4.0-rc5-next-20120501-sasha #104 Tainted: G        W
> [  130.900336] ------------------------------------------------
> [  130.902996] trinity/8384 is leaving the kernel with locks still held!
> [  130.906106] 1 lock held by trinity/8384:
> [  130.907924]  #0:  (sk_lock-AF_INET){+.+.+.}, at: [<ffffffff82b9503f>] l2tp_ip_sendmsg+0x2f/0x550
> 
> Introduced by commit 2f16270 ("l2tp: Fix locking in l2tp_ip.c").
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> ---

Oh well, please read Documentation/stable_kernel_rules.txt

Also, David prefers to handle stable submissions himself for net tree.

Anyway :

Acked-by: Eric Dumazet <edumazet@google.com>


