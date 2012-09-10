Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab2IJH5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 03:57:01 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:54269 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab2IJH47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 03:56:59 -0400
MIME-Version: 1.0
In-Reply-To: <1347240876.28607.26.camel@yhuang-dev>
References: <1347009393-8751-1-git-send-email-benjamin.gaignard@stericsson.com>
	<1347240876.28607.26.camel@yhuang-dev>
Date: Mon, 10 Sep 2012 09:56:59 +0200
Message-ID: <CA+M3ks7mYF1q3VOgA65V5DOj_1-MFDnqweoM+UMA_YHveOm+rw@mail.gmail.com>
Subject: Re: [PATCH] genalloc: make possible to use a custom allocation algorithm
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: Huang Ying <ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Benjamin Gaignard <benjamin.gaignard@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In my mind 'data' is for custom algorithms that could need additional
data to perform the allocation (it is very similar to what is done in
gen_pool_for_each_chunk function).

In gen_pool_set_algo function I have test 'algo' just be sure that we
alway have a valid algorithm function.
gen_pool_alloc doesn't take pool->lock, only rcu_lock, and I want to
avoid changing allocation function while gen_pool_alloc use it, so I
have only protect pool->algo with rcu_lock.
I need to export gen_pool_best_fit so I have do the same for gen_pool_first_fit.

I will add more detail about that in kerneldoc and fix the other
mistakes before send a new version of this patch.

Regards,
Benjamin Gaignard
