Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab2EWHOH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 03:14:07 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36499 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab2EWHOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 03:14:05 -0400
Subject: Re: [PATCH] ipv4: fix the rcu race between free_fib_info and
 ip_route_output_slow
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Cc: David Miller <davem@davemloft.net>, kunx.jiang@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1337756138.3361.1922.camel@edumazet-glaptop>
References: <4FBB6105.2060808@intel.com>
	 <20120522.151554.106838106733194160.davem@davemloft.net>
	 <1337742123.14538.175.camel@ymzhang.sh.intel.com>
	 <20120522.232310.911242148705021745.davem@davemloft.net>
	 <1337747829.3361.1599.camel@edumazet-glaptop>
	 <1337748897.14538.184.camel@ymzhang.sh.intel.com>
	 <1337749339.3361.1655.camel@edumazet-glaptop>
	 <1337753757.14538.190.camel@ymzhang.sh.intel.com>
	 <1337754459.3361.1850.camel@edumazet-glaptop>
	 <1337755623.14538.194.camel@ymzhang.sh.intel.com>
	 <1337756138.3361.1922.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 May 2012 09:13:58 +0200
Message-ID: <1337757238.3361.1965.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 08:55 +0200, Eric Dumazet wrote:

> Please hold on, I'll send a v2

I believe your patch should be fine, if you move back the
fib_info_cnt--;

So only do the dev_put() in free_fib_info_rcu().

No need to clear nh_dev to NULL since we are freeing fi at the end of
function.



