Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666Ab0DHMXf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 08:23:35 -0400
Received: from mx1.gb1.humyo.com ([62.44.71.171]:46249 "EHLO mx1.gb1.humyo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758639Ab0DHMXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 08:23:34 -0400
Message-ID: <4BBDC92D.8060503@humyo.com>
Date: Thu, 08 Apr 2010 13:16:45 +0100
From: John Berthels <john@humyo.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: linux-kernel@vger.kernel.org, Nick Gregory <nick@humyo.com>,
       Rob Sanderson <rob@humyo.com>, xfs@oss.sgi.com, linux-mm@kvack.org
Subject: Re: PROBLEM + POSS FIX: kernel stack overflow, xfs, many disks, heavy
 write load, 8k stack, x86-64
References: <4BBC6719.7080304@humyo.com> <20100407140523.GJ11036@dastard> <4BBCAB57.3000106@humyo.com> <20100407234341.GK11036@dastard> <20100408030347.GM11036@dastard>
In-Reply-To: <20100408030347.GM11036@dastard>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner wrote:
> On Thu, Apr 08, 2010 at 09:43:41AM +1000, Dave Chinner wrote:
>   
> And there's a patch attached that stops direct reclaim from writing
> back dirty pages - it seems to work fine from some rough testing
> I've done. Perhaps you might want to give it a spin on a
> test box, John?
>   
Thanks very much for this. The patch is in and soaking on a THREAD_ORDER 
1 kernel (2.6.33.2 + patch + stack instrumentation), so far so good, but 
it's early days. After about 2hrs of uptime:

$ dmesg | grep stack | tail -1
[   60.350766] apache2 used greatest stack depth: 2544 bytes left

(which tallies well with your 5 1/2Kbytes usage figure).

I'll reply again after it's been running long enough to draw conclusions.

jb
