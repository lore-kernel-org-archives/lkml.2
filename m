Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856Ab0EYQKN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 12:10:13 -0400
Received: from smtp-out.google.com ([74.125.121.35]:27347 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756255Ab0EYQKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 12:10:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=rOvHISN/UEO84AvUvi1DXNGSas2Jf9DGjNvsVHqpBPtMrHePXaia558vDTqz17uoc
	eO5cTz/r47YTIwbO4/YXg==
MIME-Version: 1.0
In-Reply-To: <1274803086.5882.1752.camel@twins>
References: <4bfbceef.e495e30a.5dae.61b6@mx.google.com>
	<1274794518.5882.1280.camel@twins>
	<AANLkTilEnIrY2HDdxDMdDIfkz8j1ueTbOf0CmD1y14ra@mail.gmail.com>
	<1274796225.5882.1389.camel@twins>
	<AANLkTinTfqLdRbgqRfn4Avl6bedB6xyLbRybwencYRiF@mail.gmail.com>
	<AANLkTimWx4fnqA5hviwv8gOTH1eydC0SMllcmsQp8jSB@mail.gmail.com>
	<1274801531.5882.1670.camel@twins>
	<1274803086.5882.1752.camel@twins>
Date: Tue, 25 May 2010 18:10:06 +0200
Message-ID: <AANLkTilwlZKx0k-Z_6LHVXIM561JLcWV4mX4Wcwgb7r0@mail.gmail.com>
Subject: Re: [PATCH] perf_events: fix event scheduling issues introduced by 
	transactional API (take 2)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: eranian@gmail.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
       acme@infradead.org, ming.m.lin@intel.com, perfmon2-devel@lists.sf.net
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o4PGANaS007394

> Index: linux-2.6/kernel/perf_event.c> ===================================================================> --- linux-2.6.orig/kernel/perf_event.c> +++ linux-2.6/kernel/perf_event.c> @@ -668,15 +668,9 @@ group_sched_in(struct perf_event *group_> Â  Â  Â  Â  Â  Â  Â  Â }> Â  Â  Â  Â }>> - Â  Â  Â  if (!txn)> + Â  Â  Â  if (!txn || !pmu->commit_txn(pmu))> Â  Â  Â  Â  Â  Â  Â  Â return 0;>> - Â  Â  Â  ret = pmu->commit_txn(pmu);> - Â  Â  Â  if (!ret) {> - Â  Â  Â  Â  Â  Â  Â  pmu->cancel_txn(pmu);> - Â  Â  Â  Â  Â  Â  Â  return 0;> - Â  Â  Â  }> -> Â group_error:> Â  Â  Â  Â /*> Â  Â  Â  Â  * Groups can be scheduled in as one unit only, so undo any>Looks okay.
I believe you can also drop the txn test in group_sched_in() after group_error:,given you have the if !(txn) return 0.ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
