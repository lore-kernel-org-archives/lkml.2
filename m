Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554Ab1BAARJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 19:17:09 -0500
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:44721 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754175Ab1BAARH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 19:17:07 -0500
From: Kevin Hilman <khilman@ti.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Grant Likely <grant.likely@secretlab.ca>, Len Brown <lenb@kernel.org>
Subject: Re: [RFC][PATCH] Power domains for platform bus type
Organization: Texas Instruments, Inc.
References: <201101300107.19389.rjw@sisk.pl>
Date: Mon, 31 Jan 2011 16:17:02 -0800
In-Reply-To: <201101300107.19389.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Sun, 30 Jan 2011 01:07:19 +0100")
Message-ID: <878vy01udd.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> Hi,
>
> This is something we discussed during the last Linux Plumbers Conference.
>
> The problem appears to be that the same device may be used in different
> systems in different configurations such that actions necessary for the
> device's power management can vary from one system to another.  In those
> cases the drivers' power management callbacks are generally not sufficient,
> because they can't take the configuration of the whole system into account.
>
> I think this issue may be addressed by adding objects that will represent
> power domains and will provide power management callbacks to be executed
> in addition to the device driver's PM callbacks, which is done by the patch
> below.
>
> Please have a look at it and tell me what you think.
>

FYI... I just tested this patch on OMAP by converting our existing use
of platform_bus_set_ops() to use this approach by adding a powerdomain
to each omap_device.   

Note we're currently only overriding the runtime_[suspend|resume]
methods, so those are the only paths I've tested.

Kevin
