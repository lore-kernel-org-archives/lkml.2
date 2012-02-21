Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab2BUBBr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 20:01:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21430 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909Ab2BUBBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 20:01:46 -0500
X-Authority-Analysis: v=2.0 cv=fNy7LOme c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=ntpRP-UOdioA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=KWw57ePhm3b483ZPotsA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1329786103.25686.48.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] x86 fixes for 3.3 impacting distros (v1).
From: Steven Rostedt <rostedt@goodmis.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Date: Mon, 20 Feb 2012 20:01:43 -0500
In-Reply-To: <1328888091-9692-1-git-send-email-konrad.wilk@oracle.com>
References: <1328888091-9692-1-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-10 at 10:34 -0500, Konrad Rzeszutek Wilk wrote:
>    66 66 66 90          	data32 data32 xchg %ax,%ax
> 
> [the 66 66 .. is 'nop']. Looks good right? Well, it does work very well on Intel
> (used an i3 2100), but on AMD A8-3850 it hits a performance wall - that I found out
> is a result of CONFIG_FUNCTION_TRACER (too many nops??) being compiled in (but the tracer
> is set to the default 'nop'). If I disable that specific config option the numbers
> are the same as the baseline (with CONFIG_FUNCTION_TRACER disabled) on the AMD box.
> Interestingly enough I only see these on AMD machines - not on the Intel ones.

All paravirt ops should be labeled with "notrace" so that function
tracer does not trace those functions. Have you annotated your new
paravirt ops with notrace?

-- Steve


