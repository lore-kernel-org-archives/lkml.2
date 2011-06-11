Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab1FKJpG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 05:45:06 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55935 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342Ab1FKJpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 05:45:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Q2UWug5/WBq7UCP6MXvEZ3NQx/cGvE9mlMTL1B3iieR4RcJPbhDmjXgGGzYlCFSLRH
         UZsLFkL7TP1dRS+qo6SqjHOK7mg8lOyDt01tVONhVnPFA1yfTnXIdIDhLYb+00qLM1J4
         0Ks56xLSBi8ZipoOS+bLoF8oIee0cDSIBVk8E=
Date: Sat, 11 Jun 2011 10:45:00 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: David Rientjes <rientjes@google.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, tglx@linutronix.de,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, mel@csn.ul.ie,
        kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com, pavel@ucw.cz
Subject: Re: [PATCH] Make GFP_DMA allocations w/o ZONE_DMA emit a warning
 instead of failing
Message-ID: <20110611094500.GA2356@debian.cable.virginmedia.net>
References: <20110610004331.13672278.akpm@linux-foundation.org>
 <BANLkTimC8K2_H7ZEu2XYoWdA09-3XxpV7Q@mail.gmail.com>
 <20110610091233.GJ24424@n2100.arm.linux.org.uk>
 <alpine.DEB.2.00.1106101150280.17197@chino.kir.corp.google.com>
 <20110610185858.GN24424@n2100.arm.linux.org.uk>
 <alpine.DEB.2.00.1106101456080.23076@chino.kir.corp.google.com>
 <20110610220748.GO24424@n2100.arm.linux.org.uk>
 <alpine.DEB.2.00.1106101510000.23076@chino.kir.corp.google.com>
 <20110610222020.GP24424@n2100.arm.linux.org.uk>
 <alpine.DEB.2.00.1106101526390.24646@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1106101526390.24646@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 03:30:35PM -0700, David Rientjes wrote:
> On Fri, 10 Jun 2011, Russell King - ARM Linux wrote:
> > So those platforms which don't have a DMA zone, don't have any problems
> > with DMA, yet want to use the very same driver which does have a problem
> > on ISA hardware have to also put up with a useless notification that
> > their kernel might be broken?
> > 
> > Are you offering to participate on other architectures mailing lists to
> > answer all the resulting queries?
> 
> It all depends on the wording of the "warning", it should make it clear 
> that this is not always an error condition and only affects certain types 
> of hardware which the user may or may not have.

I think people will still be worried when they get a warning. And there
are lots of platforms that don't need ZONE_DMA just because devices can
access the full RAM. As Russell said, same drivers may be used on
platforms that can actually do DMA only to certain areas of memory and
require ZONE_DMA (there are several examples on ARM).

If you want, you can add something like CONFIG_ARCH_HAS_ZONE_DMA across
all the platforms that support ZONE_DMA and only get the warning if
ZONE_DMA is available but not enabled.

-- 
Catalin
