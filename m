Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964918Ab2EWC4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 22:56:13 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:53745 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964786Ab2EWC4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 22:56:12 -0400
Date: Tue, 22 May 2012 22:55:12 -0400 (EDT)
Message-Id: <20120522.225512.1427265315315004011.davem@davemloft.net>
To: anton.vorontsov@linaro.org
Cc: torvalds@linux-foundation.org, ccross@android.com,
        gregkh@linuxfoundation.org, keescook@chromium.org, tony.luck@intel.com,
        arnd@arndb.de, john.stultz@linaro.org, shuahkhan@gmail.com,
        arve@android.com, rebecca@android.com, jj@chaosbits.net,
        rdunlap@xenotime.net, sboyd@codeaurora.org, thomas@m3y3r.de,
        akpm@linux-foundation.org, marco.stornelli@gmail.com,
        xiyou.wangcong@gmail.com, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com, mingo@elte.hu,
        a.p.zijlstra@chello.nl, rusty@rustcorp.com.au
Subject: Re: [PATCH/RFC] Make sure linux_banner is the first message in
 log_buf
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120523023513.GA22235@lizard>
References: <1337696279-8994-3-git-send-email-anton.vorontsov@linaro.org>
	<CAMbhsRQPYzXregvvgQZD1dV_m4tgx0hQqnYPyaO3mV0hRpc5JQ@mail.gmail.com>
	<20120523023513.GA22235@lizard>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 22 May 2012 19:55:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Vorontsov <anton.vorontsov@linaro.org>
Date: Tue, 22 May 2012 19:35:16 -0700

> For scripting it is important to have a consistent header that tells
> where the kernel log starts. At least to me it always seemed that
> linux_banner served this purpose.

Your change will not achieve this goal, many architectures
print things long before control passes to init/main.c
