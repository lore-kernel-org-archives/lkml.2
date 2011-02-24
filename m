Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381Ab1BXT5A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 14:57:00 -0500
Received: from www.tglx.de ([62.245.132.106]:45324 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753687Ab1BXT45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 14:56:57 -0500
Date: Thu, 24 Feb 2011 20:56:45 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stephen Boyd <sboyd@codeaurora.org>
cc: David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/4] msm: scm: Get cacheline size from CTR
In-Reply-To: <4D66B505.6010702@codeaurora.org>
Message-ID: <alpine.LFD.2.00.1102242056010.2701@localhost6.localdomain6>
References: <1298573085-23217-1-git-send-email-sboyd@codeaurora.org> <1298573085-23217-5-git-send-email-sboyd@codeaurora.org> <alpine.LFD.2.00.1102241959290.2701@localhost6.localdomain6> <4D66B505.6010702@codeaurora.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Feb 2011, Stephen Boyd wrote:

> On 02/24/2011 11:01 AM, Thomas Gleixner wrote:
> > On Thu, 24 Feb 2011, Stephen Boyd wrote:
> >
> >>
> >>  /**
> >>   * scm_call() - Send an SCM command
> >>   * @svc_id: service identifier
> >> @@ -243,11 +248,13 @@ int scm_call(u32 svc_id, u32 cmd_id, const void *cmd_buf, size_t cmd_len,
> >>  	do {
> >>  		u32 start = (u32)rsp;
> >>  		u32 end = (u32)scm_get_response_buffer(rsp) + resp_len;
> >> -		start &= ~(CACHELINESIZE - 1);
> >> +		u32 cacheline_size = dcache_line_size();
> >
> > And why do you want to do that on every scm_call() invocation and on
> > every loop of that code? If your dcache_line_size() changes at
> > runtime, then you might have other problems.
> 
> I definitely don't want to do it for every loop. I'm fine with getting
> it every scm_call() invocation though.
> 
> For now, I'll pull the end and cacheline_size variables out of the
> do-while loop.

Why not do it correct right away and retrieve it in an __init
function?

Thanks,

	tglx
