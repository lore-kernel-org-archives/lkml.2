Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759615Ab0JFUF1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 16:05:27 -0400
Received: from relais.videotron.ca ([24.201.245.36]:32997 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755902Ab0JFUF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 16:05:26 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Wed, 06 Oct 2010 16:05:25 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>, Russell King <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Saravana Kannan <skannan@codeaurora.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Colin Cross <ccross@android.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] [ARM] Translate delay.S into (mostly) C
In-reply-to: <1286393743.22265.129.camel@m0nster>
Message-id: <alpine.LFD.2.00.1010061553350.3107@xanadu.home>
References: <1285644827-6846-1-git-send-email-sboyd@codeaurora.org>
 <1285644827-6846-2-git-send-email-sboyd@codeaurora.org>
 <1286299355.18791.11.camel@c-dwalke-linux.qualcomm.com>
 <4CABEECB.4030301@codeaurora.org>
 <alpine.LFD.2.00.1010061024220.3107@xanadu.home>
 <4CACC053.2090509@codeaurora.org> <1286393743.22265.129.camel@m0nster>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Oct 2010, Daniel Walker wrote:

> On Wed, 2010-10-06 at 11:30 -0700, Stephen Boyd wrote:
> > Is there some way to force GCC to do what I want (interleave the
> > functions)? It seems happy to inline them and then optimize the
> > register
> > usage and instruction ordering. Perhaps that is OK though and we're
> > wasting our time trying to be conservative in code size. 

You could use the noinline qualifier from <linux/compiler.h> with those 
functions you don't want inlined.

> Is it possible to do all this in assembly ? Can't you have the default
> implementation using this assembly with different function names, then
> just set the assembly function names in C code someplace?

That weould be my preference too.  Being in assembly means that this 
code is unlikely to change with different optimization levels and/or gcc 
versions which would otherwise require different calibration values. 
Relying on stable calibration is necessary for the lpj kernel cmdline 
parameter to have some meaning.


Nicolas
