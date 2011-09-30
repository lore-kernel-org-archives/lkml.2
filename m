Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932475Ab1I3ULK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 16:11:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531Ab1I3ULH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 16:11:07 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAOH1cHkVjTSBvqvaoWnxTB1V-dOtj1cCT_kMZpJdsyNNeUoBag@mail.gmail.com>
References: <CAOH1cHkVjTSBvqvaoWnxTB1V-dOtj1cCT_kMZpJdsyNNeUoBag@mail.gmail.com> <CAOH1cHnymZ1WasD4q+HXbeQb9wBAWmS9f451gEekA0-YjCZtLA@mail.gmail.com> <2150.1314882260@redhat.com> <CAOH1cHnLfLQzZ8022ivfFkbug=adU1AYZPJOqdTnrqh9vuAAxg@mail.gmail.com> <CAOH1cHm-hbC=KZJsT1H5ohVEJVzNvqaKatKVS+s2nKVkAMgX9w@mail.gmail.com> <5149.1317036720@redhat.com> <CAOH1cHn3QF0QtR7KKN9gk5CiUvLqxsni0yi9bgCmJ8f=N1v27Q@mail.gmail.com> <CAOH1cHmTWdCHAprmbH7cfmZCVakdayR3jd031da2X2N3FmjfPw@mail.gmail.com> <6324.1317308270@redhat.com> <CAOH1cHn0tc-_dFe1PovpKmTE5pnMp40ZXi5TR9+i=ozviTdinA@mail.gmail.com> <12748.1317313818@redhat.com> <CAOH1cHmFuXn3uZbyZy94-cBGCPDxLsJuskkYRteeBs75iLhssw@mail.gmail.com> <CAOH1cHn3_aeVYC73YO43zf5piKOO_=MJwbbVfhW8eAWnDahRrw@mail.gmail.com> <18003.1317336244@redhat.com> <CAOH1cHmeX56+dZEidR4AAwEkz2kr7-J12vky5G8s0vzfbO39yw@mail.gmail.com> <6261.1317385734@redhat.com> 
To: Linux filesystem caching discussion list 
	<linux-cachefs@redhat.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [Linux-cachefs] 3.0.3 64-bit Crash running fscache/cachefilesd
Date: Fri, 30 Sep 2011 21:10:15 +0100
Message-ID: <29780.1317413415@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Moseley <moseleymark@gmail.com> wrote:

> [ 6052.503856] [kworke] <== __fscache_write_page() = -ENOBUFS [invalidating]

Nothing to worry about.  I have some kleave() calls to turn into _leave().

> [ 7720.060050]  [<ffffffff81197b24>] fscache_put_operation+0x304/0x330
> [ 7720.060050]  [<ffffffff81197b8b>] fscache_op_work_func+0x3b/0xd0
> [ 7720.060050]  [<ffffffff810660c4>] process_one_work+0x164/0x440
> [ 7720.060050]  [<ffffffff81197b50>] ? fscache_put_operation+0x330/0x330
> [ 7720.060050]  [<ffffffff8106674b>] worker_thread+0x19b/0x430
> [ 7720.060050]  [<ffffffff810665b0>] ? manage_workers+0x210/0x210
> [ 7720.060050]  [<ffffffff8106d11e>] kthread+0x9e/0xb0
> [ 7720.060050]  [<ffffffff8162d4f4>] kernel_thread_helper+0x4/0x10
> [ 7720.060050]  [<ffffffff8162ab8a>] ? retint_restore_args+0xe/0xe
> [ 7720.060050]  [<ffffffff8106d080>] ? kthread_worker_fn+0x190/0x190
> [ 7720.060050]  [<ffffffff8162d4f0>] ? gs_change+0xb/0xb

Hmmm...  That's a new one.  Looks like I've missed another op put.

Thanks for testing!

David
