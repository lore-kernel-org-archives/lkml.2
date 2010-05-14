Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab0ENQv3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 12:51:29 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:51470 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab0ENQv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 12:51:27 -0400
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-omap@vger.kernel.org, Madhusudhan Chikkature <madhu.cr@ti.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Lindgren <tony@atomide.com>,
       Denis Karpov <ext-denis.2.karpov@nokia.com>,
       linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: Re: [PATCH] MMC: OMAP HS-MMC: convert to dev_pm_ops
References: <1273615036-4516-1-git-send-email-khilman@deeprootsystems.com>
	<87k4r74p01.fsf@linux-g6p1.site>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Fri, 14 May 2010 09:51:21 -0700
In-Reply-To: <87k4r74p01.fsf@linux-g6p1.site> (Matt Fleming's message of "Thu\, 13 May 2010 19\:48\:14 +0100")
Message-ID: <87ljbmmnp2.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Fleming <matt@console-pimps.org> writes:

> On Tue, 11 May 2010 14:57:16 -0700, Kevin Hilman <khilman@deeprootsystems.com> wrote:
>> 
>> Note that dev_pm_ops version of the suspend hook no longer takes a
>> 'state' argument.  However, the MMC core function mmc_suspend_host()
>> still takes a 'state' argument, but it is unused, so a dummy
>> state variable was created to pass to the MMC core.
>
> Hmm.. instead of passing this dummy state argument why don't we just
> remove the argument from mmc_suspend_host()? Like you said, it's unused,
> so I don't see a reason to keep it around?

I don't see a reason either, but it requires patching the MMC core as
well as all the users.  As I'm not an MMC core person, I thought this
best left to someone in that domain.

Fixing the core and callers could easily be done on top of this patch.

Kevin


