Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776Ab2IHNHF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 09:07:05 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:46769 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab2IHNG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 09:06:59 -0400
Date: Sat, 8 Sep 2012 15:06:50 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/7] perf: Enable function tracing for perf core
Message-ID: <20120908130646.GA2122@somewhere.redhat.com>
References: <20120908115515.211175517@goodmis.org>
 <20120908115640.032328533@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120908115640.032328533@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 08, 2012 at 07:55:16AM -0400, Steven Rostedt wrote:
> According to Steven R. there is no reason left to not support
> function tracing for the perf core. This makes it easier to debug
> perf.
> 
> Don't remove -pg for the x86 and generic perf core.

Actually, perf can use function tracing. A good reason for disabling
function tracing in perf is to avoid the overhead of recursive function
tracing, even though we are protected against tracing re-entrancy, this
still result in some overhead.
