Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab2DPRIi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 13:08:38 -0400
Received: from ocelot.phlegethon.org ([81.29.64.94]:49352 "EHLO
	mail.phlegethon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab2DPRIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 13:08:36 -0400
Date: Mon, 16 Apr 2012 18:08:27 +0100
From: Tim Deegan <tim@xen.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>, Jan Beulich <JBeulich@suse.com>,
        Konrad Wilk <konrad.wilk@oracle.com>, linux-kernel@vger.kernel.org,
        xen-devel <xen-devel@lists.xen.org>, Sheng Yang <sheng@yasker.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Xen-devel] [PATCH] xen: always set the sched clock as unstable
Message-ID: <20120416170827.GE13111@ocelot.phlegethon.org>
References: <1334341255-11153-1-git-send-email-david.vrabel@citrix.com> <4F8C1F6D020000780007E11A@nat28.tlf.novell.com> <4F8C33E0.2080007@citrix.com> <049b7b93-fb37-4962-b272-d786e1dcfacb@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <049b7b93-fb37-4962-b272-d786e1dcfacb@default>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 09:05 -0700 on 16 Apr (1334567132), Dan Magenheimer wrote:
> Hmmm... I spent a great deal of time on TSC support in the hypervisor
> 2-3 years ago.  I worked primarily on PV, but Intel supposedly was tracking
> everything on HVM as well.  There's most likely a bug or two still lurking
> but, for all guests, with the default tsc_mode, TSC is provided by Xen
> as an absolutely stable clock source.  If Xen determines that the underlying
> hardware declares that TSC is stable, guest rdtsc instructions are not trapped.
> If it is not, Xen emulates all guest rdtsc instructions.  After a migration or
> save/restore, TSC is always emulated.  The result is (ignoring possible
> bugs) that TSC as provided by Xen is a) monotonic; b) synchronized across
> CPUs; and c) constant rate.  Even across migration/save/restore.

AIUI, this thread is about the PV-time clock source, not about the TSC
itself.  Even if the TSC is emulated (or in some other way made
"stable") the PV wallclock is not necessarily stable across migration.
But since migration is controlled by the kernel, presumably the kernel
can DTRT about it.

> In fact, it might be wise for a Xen-savvy kernel to check to see
> if it is running on Xen-4.0+ and, if so, force clocksource=tsc
> and tsc=reliable.

That seems like overdoing it.  Certainly it's not OK unless it can also
check that Xen is providing a stable TSC (i.e. that tscmode==1).

In the case where the PV clock has been selected, can it not be marked
unstable without also marking the TSC unstable?

Tim.
