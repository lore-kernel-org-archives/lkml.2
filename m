Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761435Ab2BOBJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 20:09:41 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:41011 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761351Ab2BOBJi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 20:09:38 -0500
MIME-Version: 1.0
In-Reply-To: <20120214181245.GS12117@google.com>
References: <20120214181245.GS12117@google.com>
Date: Wed, 15 Feb 2012 09:09:37 +0800
X-Google-Sender-Auth: N2FDvpXB2XE_9SP3elO-Hw799gQ
Message-ID: <CANejiEVmBOJ7ggD1O6tbXhvZAzZCa6VCi4D421Kqnszx_6QL-Q@mail.gmail.com>
Subject: Re: [PATCH block/for-linus 1/3] block: replace icq->changed with icq->flags
From: Shaohua Li <shaohua.li@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>, mroos@linux.ee,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/15 Tejun Heo <tj@kernel.org>:
> icq->changed was used for ICQ_*_CHANGED bits.  Rename it to flags and
> access it under ioc->lock instead of using atomic bitops.
> ioc_get_changed() is added so that the changed part can be fetched and
> cleared as before.
>
> icq->flags will be used to carry other flags.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
> Jens, these three patches are to fix the swap heavy workload
> regression reported by Shaohua.
>
> Shaohua, I ended up changing the second patch, which shouldn't change
> anything but it would be great if you can verify this series once
> more.
yes, confirmed the patches fix the regression. Thanks for fixing it.
Tested-by: Shaohua Li <shaohua.li@intel.com>
