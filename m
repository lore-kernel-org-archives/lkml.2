Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab1HROCW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 10:02:22 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52632 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767Ab1HROCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 10:02:20 -0400
Date: Thu, 18 Aug 2011 16:02:16 +0200
From: Tejun Heo <tj@kernel.org>
To: Jan Beulich <JBeulich@novell.com>
Cc: mingo@elte.hu, stable@kernel.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] i386/bigsmp: eliminate false warnings regarding logical
 APIC ID mismatches
Message-ID: <20110818140216.GD20085@htj.dyndns.org>
References: <4E4D27B40200007800051D40@nat28.tlf.novell.com>
 <20110818130424.GC20085@htj.dyndns.org>
 <4E4D36980200007800051D6E@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E4D36980200007800051D6E@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 02:58:16PM +0100, Jan Beulich wrote:
> >>> On 18.08.11 at 15:04, Tejun Heo <tj@kernel.org> wrote:
> > On Thu, Aug 18, 2011 at 01:54:44PM +0100, Jan Beulich wrote:
> >> Fix this (for the time being, i.e. until x86_32_early_logical_apicid()
> >> will get removed again, as Tehun says ought to be possible) by
> >> overriding the previously stored values at the point where the APIC
> >> driver gets overridden.
> > 
> > Hmmm... how about just removing the WARN_ON() in setup_local_APIC()?
> > We already don't depend on the value so just overriding it isn't
> > dangerous at all.
> 
> I was not able to prove for myself that all of the uses of
> early_per_cpu(x86_cpu_to_logical_apicid, ...) are actually only
> possible to be hit after setup_local_APIC(), so I can't really
> propose a patch like this.

Hmmm... the only thing it can break is numa affinity of static percpu
areas (it doesn't even affect that anymore), which didn't work at all
on i386 before and keeps to not working for those exotic apic machines
anyway.  Silencing the warnings wouldn't hurt anything at all.  If
you're still concerned that something legitimate might trigger it,
wouldn't converting WARN_ON() there to printk_once() be enough?  That
doesn't change the behavior at all sans lesser noise.

Thanks.

-- 
tejun
