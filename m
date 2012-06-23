Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab2FWU5r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 16:57:47 -0400
Received: from 1wt.eu ([62.212.114.60]:3419 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754732Ab2FWU5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 16:57:46 -0400
Date: Sat, 23 Jun 2012 22:57:34 +0200
From: Willy Tarreau <w@1wt.eu>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, lwn@lwn.net,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Linux 2.6.32.55
Message-ID: <20120623205734.GF18996@1wt.eu>
References: <20120125223434.GA31647@kroah.com> <4FE4C1A3.4080804@suse.cz> <20120622193824.GA3371@kroah.com> <4FE4DF41.30400@suse.cz> <20120622211824.GB18996@1wt.eu> <4FE4E4A8.1010105@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FE4E4A8.1010105@suse.cz>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Fri, Jun 22, 2012 at 11:33:28PM +0200, Jiri Slaby wrote:
> On 06/22/2012 11:18 PM, Willy Tarreau wrote:
> >> Given nobody noticed till now, I would incline to drop that patch from
> >> 2.6.32 series. Opinions?
> > 
> > Which one would you drop then ? You got me lost now. I mean, since you've
> > been the only one to notice an issue, I have no problem with following you
> > on the best way to fix it but I need to understand what you want then :-)
> 
> Ok, now I spent some time to look into that.

thank you.

> I thought suse does not need the original patch (PNP: work around Dell
> 1536/1546 BIOS MMCONFIG bug that breaks USB) as we do not support
> CONFIG_AMD_NB. But in 2.6.32.55, it is named CONFIG_K8_NB. So actually
> we need it.
> 
> There are two problems with the backport:
> * missing amd_get_mmconfig_range (added by 24d25dbfa6)

Indeed I can see it now. Thanks for the pointer to the patch.

> * used wrong names: CONFIG_AMD_NB and asm/amd_nb.h
>
> The latter can be fixed in two ways:
> * easier: change CONFIG_AMD_NB to CONFIG_K8_NB and asm/amd_nb.h to
> asm/k8.h (obviously, there will be no "upstream commit" for that)

OK I can see it in quirks.c. Indeed, it looks like this is the way to
go. I'm not opposed to merging it even without upstream commit since
it's a fix for a regression we introduced during a backport. So that's
fine.

> * maybe harder: backport 23ac4ae827 including dependencies (I haven't
> looked if there are any)

I'd rather avoid backporting such changes into stable when the fix is
obvious.

Thanks for these precisions, it's clear to me now. I'm queuing it.

Cheers,
Willy

