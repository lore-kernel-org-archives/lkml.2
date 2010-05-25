Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab0EYPcX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 11:32:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:36835 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab0EYPcW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 11:32:22 -0400
Subject: Re: [PATCH] perf_events: fix event scheduling issues introduced by
  transactional API (take 2)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: eranian@gmail.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
       acme@infradead.org, ming.m.lin@intel.com, perfmon2-devel@lists.sf.net
In-Reply-To: <AANLkTimWx4fnqA5hviwv8gOTH1eydC0SMllcmsQp8jSB@mail.gmail.com>
References: <4bfbceef.e495e30a.5dae.61b6@mx.google.com>
	 <1274794518.5882.1280.camel@twins>
	 <AANLkTilEnIrY2HDdxDMdDIfkz8j1ueTbOf0CmD1y14ra@mail.gmail.com>
	 <1274796225.5882.1389.camel@twins>
	 <AANLkTinTfqLdRbgqRfn4Avl6bedB6xyLbRybwencYRiF@mail.gmail.com>
	 <AANLkTimWx4fnqA5hviwv8gOTH1eydC0SMllcmsQp8jSB@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 25 May 2010 17:32:11 +0200
Message-ID: <1274801531.5882.1670.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-25 at 17:02 +0200, Stephane Eranian wrote:
> Ok, the patch look good expect it needs:
> 
> static int x86_pmu_commit_txn(const struct pmu *pmu)
> {
>         ......
>         /*
>          * copy new assignment, now we know it is possible
>          * will be used by hw_perf_enable()
>          */
>         memcpy(cpuc->assign, assign, n*sizeof(int));
> 
>         cpuc->n_txn = 0;
> 
>         return 0;
> }
> 
> Because you always call cancel_txn() even when commit()
> succeeds. I don't really understand why. I think it could be
> avoided by clearing the group_flag in commit_txn() if it
> succeeds. It would also make the logical flow more natural. Why
> cancel something that has succeeded. You cancel when you fail/abort.

Gah, I forgot about that. I think I suggested to Lin to do that and then
promptly forgot.

Let me add that and at least push this patch fwd, we can try and clean
up that detail later on.
