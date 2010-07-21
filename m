Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232Ab0GUNeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 09:34:19 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50485 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070Ab0GUNeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 09:34:14 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Eric B Munson <emunson@mgebm.net>
Subject: Re: [PATCH 1/2] Add trace points to mmap, munmap, and brk
Cc: kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
        mingo@redhat.com, hugh.dickins@tiscali.co.uk, riel@redhat.com,
        peterz@infradead.org, anton@samba.org, hch@infradead.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <f6a595dfac141397dcac8c29475be73d10f5248c.1279558781.git.emunson@mgebm.net>
References: <cover.1279558781.git.emunson@mgebm.net> <f6a595dfac141397dcac8c29475be73d10f5248c.1279558781.git.emunson@mgebm.net>
Message-Id: <20100721223359.8710.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 21 Jul 2010 22:34:12 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch adds trace points to mmap, munmap, and brk that will report
> relevant addresses and sizes before each function exits successfully.
> 
> Signed-off-by: Eric B Munson <emunson@mgebm.net>

I don't think this is good idea. if you need syscall result, you should 
use syscall tracer. IOW, This tracepoint bring zero information.

Please see perf_event_mmap() usage. Our kernel manage adress space by
vm_area_struct. we need to trace it if we need to know what kernel does.

Thanks.


