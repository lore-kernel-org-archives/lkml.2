Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759446Ab0JYSzG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 14:55:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55871
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755049Ab0JYSzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 14:55:03 -0400
Date: Mon, 25 Oct 2010 11:55:27 -0700 (PDT)
Message-Id: <20101025.115527.226780270.davem@davemloft.net>
To: namhyung@gmail.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] sparc32: remove CONFIG_HAVE_PERF_EVENTS option
From: David Miller <davem@davemloft.net>
In-Reply-To: <1288024279.1689.23.camel@leonhard>
References: <1288021958-3130-2-git-send-email-namhyung@gmail.com>
	<20101025.085937.226775583.davem@davemloft.net>
	<1288024279.1689.23.camel@leonhard>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=euc-kr
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@gmail.com>
Date: Tue, 26 Oct 2010 01:31:19 +0900

> 2010-10-25 (¿ù), 08:59 -0700, David Miller:
>> From: Namhyung Kim <namhyung@gmail.com>
>> Date: Tue, 26 Oct 2010 00:52:37 +0900
>> 
>> > Remove HAVE_PERF_EVENTS and PERF_USE_VMALLOC under config
>> > SPARC because they're under SPARC64 too. Supporting
>> > perf_event needs atomic64 operations but AFAIK sparc32
>> > doesn't provide them, CMIIW. ;-) Also removes redundant
>> > HAVE_IRQ_WORK line.
>> > 
>> > Signed-off-by: Namhyung Kim <namhyung@gmail.com>
>> 
>> The generic non-hw perf event stuff builds fine on sparc32,
>> please don't remove this unless you have a legitimate build
>> failure to report and fix.
>> 
>> Even if sparc32 doesn't provide atomic64_t support, it very
>> easily could do so using include/asm-generic/atomic64.h which
>> implements them using spinlocks.
> 
> Now I see following build failure without this patch. Maybe some work is
> needed to deal with atomic64_t. I'll try to prepare for it soon. Thanks.

Nevermind, I see the issue.  Ok, your patch is fine:

Acked-by: David S. Miller <davem@davemloft.net>
