Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab1KUOBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 09:01:20 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:39833 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab1KUOBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 09:01:18 -0500
X-Authority-Analysis: v=2.0 cv=Pdt9d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=cXTrsohjeOsA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=yPCof4ZbAAAA:8 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=QyXUC8HyAAAA:8 a=qMcsTUr77fFu4I-QPwsA:9 a=QEXdDO2ut3YA:10 a=7DSvI1NPTFQA:10 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=dGJ0OcVc7YAA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH 6/8] readahead: add debug tracing event
From: Steven Rostedt <rostedt@goodmis.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        linux-fsdevel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Jens Axboe <jens.axboe@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20111121093846.764030336@intel.com>
References: <20111121091819.394895091@intel.com>
	 <20111121093846.764030336@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Nov 2011 09:01:15 -0500
Message-ID: <1321884075.20742.5.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-21 at 17:18 +0800, Wu Fengguang wrote:
> plain text document attachment (readahead-tracer.patch)
> This is very useful for verifying whether the algorithms are working
> to our expectaions.
> 
> Example output:
> 
> # echo 1 > /debug/tracing/events/vfs/readahead/enable
> # cp test-file /dev/null
> # cat /debug/tracing/trace  # trimmed output
> readahead-initial(dev=0:15, ino=100177, req=0+2, ra=0+4-2, async=0) = 4
> readahead-subsequent(dev=0:15, ino=100177, req=2+2, ra=4+8-8, async=1) = 8
> readahead-subsequent(dev=0:15, ino=100177, req=4+2, ra=12+16-16, async=1) = 16
> readahead-subsequent(dev=0:15, ino=100177, req=12+2, ra=28+32-32, async=1) = 32
> readahead-subsequent(dev=0:15, ino=100177, req=28+2, ra=60+60-60, async=1) = 24
> readahead-subsequent(dev=0:15, ino=100177, req=60+2, ra=120+60-60, async=1) = 0
> 
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Jens Axboe <jens.axboe@oracle.com>
> CC: Steven Rostedt <rostedt@goodmis.org>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Acked-by: Rik van Riel <riel@redhat.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>


