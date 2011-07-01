Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906Ab1GAOpF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 10:45:05 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54556 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756621Ab1GAOpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 10:45:03 -0400
Date: Fri, 1 Jul 2011 10:45:02 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Kevin Hilman <khilman@ti.com>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Walmsley <paul@pwsan.com>,
        LKML <linux-kernel@vger.kernel.org>, <linux-sh@vger.kernel.org>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 7/10 v6] PM / Domains: Don't stop wakeup devices during
 system sleep transitions
In-Reply-To: <201107010125.25875.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1107011043410.1988-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jul 2011, Rafael J. Wysocki wrote:

> So the only way forward I can see is to add a special PM domain callback,
> say .active_wakeup(), that will return "true" if the device is to be left
> active if wakeup-enabled.  So the check you don't like will become
> something like:
> 
> if (device_may_wakeup(dev) && genpd->active_wakeup
>     && genpd->active_wakeup(dev))
>         return 0;
> 
> Would that be better?

Another option, less flexible but perhaps easier to use, would be to 
set a couple of bitflags indicating whether the device needs power or 
clocks to handle wakeup signals.

Alan Stern

