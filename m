Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758952Ab1FVVu4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 17:50:56 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:42080 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758211Ab1FVVuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 17:50:54 -0400
From: Kevin Hilman <khilman@ti.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Walmsley <paul@pwsan.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org
Subject: Re: [Update][PATCH 7/8] PM / Domains: System-wide transitions support for generic domains (v3)
Organization: Texas Instruments, Inc.
References: <201106112223.04972.rjw@sisk.pl> <201106112239.16285.rjw@sisk.pl>
	<201106200006.07642.rjw@sisk.pl>
Date: Wed, 22 Jun 2011 14:50:51 -0700
In-Reply-To: <201106200006.07642.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Mon, 20 Jun 2011 00:06:07 +0200")
Message-ID: <8739j1lemc.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> Make generic PM domains support system-wide power transitions
> (system suspend and hibernation).  Add suspend, resume, freeze, thaw,
> poweroff and restore callbacks to be associated with struct
> generic_pm_domain objects and make pm_genpd_init() use them as
> appropriate.
>
> The new callbacks do nothing for devices belonging to power domains
> that were powered down at run time (before the transition).  

Great, this is the approach I prefer too, but...

Now I'm confused.  Leaving runtime suspended devices alone is what I was
doing in my subsystem but was told not to.  According to

    http://www.mail-archive.com/linux-omap@vger.kernel.org/msg50690.html

"it's generally agreed that _all_ devices should return to full 
power during system resume -- even if they were runtime suspended 
before the system sleep."

Kevin
