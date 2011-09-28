Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406Ab1I1Nwc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 09:52:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54970 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab1I1Nwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 09:52:30 -0400
X-Authority-Analysis: v=1.1 cv=XWD5/VRj2HUJOhsR8cgmvPBlhMACpZXxseY1Kn/ehQI= c=1 sm=0 a=ygIOiH7ERsYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=meVymXHHAAAA:8 a=1XWaLZrsAAAA:8 a=7CQSdrXTAAAA:8 a=JtDQKuRoJBMKwgVXE0wA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=UTB_XpHje0EA:10 a=ESTKKtUg-DoA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [PATCH] kmemleak: Show where early_log issues come from
From: Steven Rostedt <rostedt@goodmis.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@google.com>
Date: Wed, 28 Sep 2011 09:52:28 -0400
In-Reply-To: <20110928130553.8707.82034.stgit@e102109-lin.cambridge.arm.com>
References: <20110928130553.8707.82034.stgit@e102109-lin.cambridge.arm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1317217949.4588.1.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-28 at 14:07 +0100, Catalin Marinas wrote:
> Based on initial patch by Steven Rostedt.
> 
> Early kmemleak warnings did not show where the actual kmemleak API had
> been called from but rather just a backtrace to the kmemleak_init()
> function. By having all early kmemleak logs record the stack_trace, we
> can have kmemleak_init() write exactly where the problem occurred. This
> patch adds the setting of the kmemleak_warning variable every time a
> kmemleak warning is issued. The kmemleak_init() function checks this
> variable during early log replaying and prints the log trace if there
> was any warning.
> 
> Reported-by: Steven Rostedt <rostedt@goodmis.org>
> Cc: Andrew Morton <akpm@google.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
> 
> Steven, a simpler implementation of your idea. Basically we have
> kmemleak_warn() called in several places where errors actually occur. We
> can just reuse this for printing the early log information rather than
> changing the function prototypes to return an error code.

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


