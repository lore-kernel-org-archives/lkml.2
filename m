Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab1GXBlO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 21:41:14 -0400
Received: from netrider.rowland.org ([192.131.102.5]:42853 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751844Ab1GXBlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 21:41:07 -0400
Date: Sat, 23 Jul 2011 21:41:05 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Colin Cross <ccross@android.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-pm@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, Kevin Hilman <khilman@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: Re: [PATCH] PM: runtime: add might_sleep to PM runtime functions
In-Reply-To: <CAMbhsRTdQLd5GRew9GMx6O287k3O17SKE18jvK2k7oyZpOrZfg@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1107232136490.26837-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jul 2011, Colin Cross wrote:

> On Sat, Jul 23, 2011 at 3:57 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Saturday, July 23, 2011, Colin Cross wrote:
> >> The list of functions that can be called in atomic context is
> >> non-intuitive (pm_runtime_put_sync can not, but
> >> pm_runtime_put_sync_suspend can, if pm_runtime_irq_safe has
> >> been called?).
> >
> > However, this behavior is documented.
> >
> > Also, if you have a clean use case for calling rpm_idle() with interrupts
> > off, it can be modified to work in analogy with rpm_suspend() in that respect.
> 
> Yes, Kevin posted that patch in response to a bug that would never
> have existed with this patch.  Even with Kevin's change, this patch
> still detects drivers that are missing pm_runtime_irq_safe().

I suggest that adding the annotations to __pm_runtime_idle(),
__pm_runtime_suspend(), and __pm_runtime_resume() is entirely
reasonable.  But the annotations to __pm_runtime_disable() and
__pm_runtime_use_autosuspend() do seem unnecessary.

Alan Stern

