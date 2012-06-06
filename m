Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372Ab2FFRMj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 13:12:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:40764 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab2FFRMh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 13:12:37 -0400
Message-ID: <1339002747.2749.153.camel@twins>
Subject: Re: [tip:perf/core] perf/x86: Fix wrmsrl() debug wrapper
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Date: Wed, 06 Jun 2012 19:12:27 +0200
In-Reply-To: <4FCF8397.6090505@zytor.com>
References: <tip-l4gkfnivwv4yi5mqxjlovymx@git.kernel.org>
	 <4FCF8397.6090505@zytor.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 09:21 -0700, H. Peter Anvin wrote:
> On 06/06/2012 09:15 AM, tip-bot for Peter Zijlstra wrote:
> > 
> > perf/x86: Fix wrmsrl() debug wrapper
> > 
> > Move the wrmslr() debug wrapper to the common header now that all the
> > include games are gone. Also clean it up a bit to avoid multiple
> > evaluation of the argument.
> > 
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Link: http://lkml.kernel.org/n/tip-l4gkfnivwv4yi5mqxjlovymx@git.kernel.org
> > Signed-off-by: Ingo Molnar <mingo@kernel.org>
> 
> Could you please call this something like trace_wrmsrl() instead of
> silently tacking something onto something else that already had meaning?

Its #if 0, its broken on CONFIG_PARAVIRT etc.. The whole purpose was to
hijack wrmsrl() for perf_event*.c so that I don't have to do
s/wrmsrl/trace_&/ on those files.

Its a crude debug aid, nothing more.
