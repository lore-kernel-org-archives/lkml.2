Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933145Ab2AFJt2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 04:49:28 -0500
Received: from one.firstfloor.org ([213.235.205.2]:46857 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933000Ab2AFJt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 04:49:26 -0500
Date: Fri, 6 Jan 2012 10:49:22 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Jan Beulich <JBeulich@suse.com>,
        mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: x86-64: memset()/memcpy() not fully standards compliant
Message-ID: <20120106094922.GU11715@one.firstfloor.org>
References: <4F05BBFE020000780006A983@nat28.tlf.novell.com> <20120105182846.GQ11715@one.firstfloor.org> <4F0630CC.7050001@zytor.com> <20120106014748.GS11715@one.firstfloor.org> <4F06566B.8080708@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F06566B.8080708@zytor.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 06:03:23PM -0800, H. Peter Anvin wrote:
> On 01/05/2012 05:47 PM, Andi Kleen wrote:
> >>
> >> Is that still true, and do we even use string instructions still on
> >> those old CPUs?  Jan's fixes don't introduce any additional delays in
> >> the non-string-instruction paths.
> > 
> > Yes various of the CPUs with bugs used string instructions.
> > 
> 
> Which CPUs are you talking about here?

This was various iterations of K8 and PSC. Early Meroms may also have
had issues (not 100% sure).

> 
> > 
> > Both string and non string instructions are used on modern CPUs,
> > so making any of that slower is not a good idea.
> > 
> 
> Obviously not, but I'm perfectly fine turning REP_GOOD off on old broken
> CPUs.

That would be even worse.

You would slow a critical fast path operation down for something
that never happens?!?  There were big differences between strings
and the unrolled loop for several.

IMHO it's a war games situation: "the only way to win is not to play"

-Andi

