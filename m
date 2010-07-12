Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab0GLB6I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 21:58:08 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45925 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724Ab0GLB6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 21:58:06 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] Add trace events to mmap and brk
Cc: kosaki.motohiro@jp.fujitsu.com, Eric B Munson <emunson@mgebm.net>,
        akpm@linux-foundation.org, mingo@redhat.com,
        hugh.dickins@tiscali.co.uk, riel@redhat.com, peterz@infradead.org,
        anton@samba.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20100709160342.GB3281@infradead.org>
References: <1278690830-22145-1-git-send-email-emunson@mgebm.net> <20100709160342.GB3281@infradead.org>
Message-Id: <20100712104602.EA1A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 12 Jul 2010 10:58:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmm, thinking about it a bit more, what do you trace events give us that
> the event based syscall tracer doesn't?

Yup. I think we need two tracepoint.

 1) need to know userland argument.
    -> syscall tracer
 2) need to know actual vma change.
    -> need to trace more low layer


As I said, if userland app have following code,

	mmap(0x10000, PROT_READ|PROT_WRITE)
	mmap(0x10000, PROT_NONE)

second mmap implicitly unmap firt mmap region and map another region.
so if we want to track munmap activity, syscall exiting point is not
so good place. we need to trace per-vma activity.

btw, perf_event_mmap() already take vma argument.





