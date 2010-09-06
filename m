Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab0IFULO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 16:11:14 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61446 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894Ab0IFULI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 16:11:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kulikov Vasiliy <segooon@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] md: do not use ++ in rcu_dereference() argument
Date: Mon, 6 Sep 2010 22:10:55 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3; KDE/4.5.1; x86_64; ; )
Cc: kernel-janitors@vger.kernel.org, Neil Brown <neilb@suse.de>,
        Jens Axboe <jaxboe@fusionio.com>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1283711539-7123-1-git-send-email-segooon@gmail.com>
In-Reply-To: <1283711539-7123-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201009062210.56824.arnd@arndb.de>
X-Provags-ID: V02:K0:aBZBb8txuTNmRWCTNh1rBJC/EikPflajfiwJAm304He
 5rZj1xqLBdOzRHfjmFuKsewkWvuI5PbVRiMoXEvSxVlD5zPK45
 7A4hj+g+6Yu69EfwJ3eX/BNqmWqoRJr4Crt/4sSaypksesfKFM
 wygrDJiygiQxwR/8vDt5Hign6dREAlQjwbyX+e3i8ch2aES4A/
 tFpehkTcw8zQKZigj/GuQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 05 September 2010 20:32:18 Kulikov Vasiliy wrote:
> From: Vasiliy Kulikov <segooon@gmail.com>
> 
> rcu_dereference() is macro, so it might use its argument twice.
> Argument must not has side effects.
> 
> It was found by compiler warning:
> drivers/md/raid1.c: In function ‘read_balance’:
> drivers/md/raid1.c:445: warning: operation on ‘new_disk’ may be undefined

I think the rcu_dereference macro should really not evaluate its argument
twice, and I don't see where it does.
As a general rule, we try to write macros in Linux such that they behave
like functions and don't have surprising side-effects.

Which kernel and gcc version do you see the warning with?

	Arnd
