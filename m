Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab2HBUWL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 16:22:11 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:10489 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab2HBUWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 16:22:08 -0400
Date: Thu, 2 Aug 2012 22:22:05 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Engelhardt <jengelh@inai.de>
Cc: "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, pv-drivers@vmware.com,
        vm-crosstalk@vmware.com, cschamp@vmware.com,
        gregkh@linuxfoundation.org
Subject: Re: [vmw_vmci 11/11] Apply the header code to make VMCI build
Message-ID: <20120802202205.GA9096@merkur.ravnborg.org>
References: <1343345980-32397-1-git-send-email-astiegmann@vmware.com> <1343345980-32397-12-git-send-email-astiegmann@vmware.com> <20120727103455.GA4639@merkur.ravnborg.org> <alpine.LNX.2.01.1208022145380.30631@frira.zrqbmnf.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1208022145380.30631@frira.zrqbmnf.qr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2012 at 09:50:02PM +0200, Jan Engelhardt wrote:
> 
> On Friday 2012-07-27 12:34, Sam Ravnborg wrote:
> >> +#ifndef _VMCI_COMMONINT_H_
> >> +#define _VMCI_COMMONINT_H_
> >> +
> >> +#include <linux/printk.h>
> >> +#include <linux/vmw_vmci_defs.h>
> >
> >Use inverse chrismas tree here.
> >Longer include lines first, and soret alphabetically when
> >lines are of the same length.
> 
> So that's where unreadable include lists come from.
> Depth-first lexicographically-sorted is a lot less hassle,
> especially when it comes to merging patches that each
> add one different include.
This is applied in many parts of the kernels and has some benefits:
- easy to spot duplicates
- clash is less likely when two commit adds includes
- easy to do so it looks the same across different files

Obviously <linux/*> comes before include <asm/*> as this is
separate blocks of includes.

net/ and arch/x86/ is two places where this is getting the norm,
and these are trendsetters for the rest of the kernel.

> 
> >> +/*
> >> + * Utilility function that checks whether two entities are allowed
> >> + * to interact. If one of them is restricted, the other one must
> >> + * be trusted.
> >> + */
> >> +static inline bool vmci_deny_interaction(uint32_t partOne,
> >> +					 uint32_t partTwo)
> >
> >The kernel types are u32 not uint32_t - these types belongs in user-space.
> 
> Not really. uint32_t is the C99 type for a 32-bit quantity, and I see
> absolutely zero reason not to use standardized things.
Found the following somewhere on the net:

On Mon, 29 Nov 2004, Paul Mackerras wrote:
>
> uint32_t is defined to be exactly 32 bits wide, so where's the problem
> in using it instead of __u32 in the headers that describe the
> user/kernel interface?  (Ditto for uint{8,16,64}_t, of course.

Ok, this discussion has gone on for too long anyway, but let's make it
easier for everybody. The kernel uses u8/u16/u32 because:

	- the kernel should not depend on, or pollute user-space naming.
	  YOU MUST NOT USE "uint32_t" when that may not be defined, and
	  user-space rules for when it is defined are arcane and totally
	  arbitrary.
...

See http://yarchive.net/comp/linux/kernel_headers.html for additional
rationale. (Second mail listed).

	Sam



