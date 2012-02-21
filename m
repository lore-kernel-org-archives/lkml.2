Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab2BUDgG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 22:36:06 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:48357 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab2BUDgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 22:36:04 -0500
Date: Mon, 20 Feb 2012 22:32:31 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: [PATCH] x86 fixes for 3.3 impacting distros (v1).
Message-ID: <20120221033231.GA3776@phenom.dumpdata.com>
References: <1328888091-9692-1-git-send-email-konrad.wilk@oracle.com>
 <1329786103.25686.48.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329786103.25686.48.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090205.4F431115.0050,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 08:01:43PM -0500, Steven Rostedt wrote:
> On Fri, 2012-02-10 at 10:34 -0500, Konrad Rzeszutek Wilk wrote:
> >    66 66 66 90          	data32 data32 xchg %ax,%ax
> > 
> > [the 66 66 .. is 'nop']. Looks good right? Well, it does work very well on Intel
> > (used an i3 2100), but on AMD A8-3850 it hits a performance wall - that I found out
> > is a result of CONFIG_FUNCTION_TRACER (too many nops??) being compiled in (but the tracer
> > is set to the default 'nop'). If I disable that specific config option the numbers
> > are the same as the baseline (with CONFIG_FUNCTION_TRACER disabled) on the AMD box.
> > Interestingly enough I only see these on AMD machines - not on the Intel ones.
> 
> All paravirt ops should be labeled with "notrace" so that function
> tracer does not trace those functions. Have you annotated your new
> paravirt ops with notrace?

No. I hadn't realized that flag existed until your email a couple of days ago - I hadn't
had a chance to see if the notrace would solve this. But let me do that and get
back on this.
