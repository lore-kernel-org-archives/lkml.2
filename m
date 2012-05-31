Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932565Ab2EaPQ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 11:16:29 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:42147 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932349Ab2EaPQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 11:16:27 -0400
X-AuditID: b753bd60-922cbba000001453-a2-4fc78b47f715
X-AuditID: b753bd60-922cbba000001453-a2-4fc78b47f715
Message-ID: <4FC78B45.9060806@hitachi.com>
Date: Fri, 01 Jun 2012 00:16:21 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: Re: [PATCH 1/5] ftrace: Synchronize variable setting with
 breakpoints
References: <20120531012829.160060586@goodmis.org>  <20120531020440.476352979@goodmis.org> <1338462398.28384.52.camel@twins> <1338473302.13348.336.camel@gandalf.stny.rr.com>
In-Reply-To: <1338473302.13348.336.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/05/31 23:08), Steven Rostedt wrote:
> Now Masami said he thinks the text_poke should also do the change of
> kernel protection as well, and not do the FIXMAP mapping. At least for
> bulk changes. The added breakpoint code that we have can be shared
> between ftrace and text_poke. That is something we want to do. After we
> get ftrace working, we'll go ahead and make it work for text_poke as
> well ;-)

Indeed, ftrace can be a better test case for breakpoint-based self-
modifying. So after we can make sure that is safely work on x86
widely, it is better to rewrite text_poke with that method.

Perhaps, kprobes-*jump*-optimization may be better to handle it
because the target probe is simultaneously working while
optimizing (modifying code). This means that if someone hits
breakpoint of such kprobe, it must be handled by kprobes, not
only just tweaking IP address.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
