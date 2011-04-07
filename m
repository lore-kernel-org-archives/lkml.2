Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab1DGRRK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 13:17:10 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:41362 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751385Ab1DGRRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 13:17:08 -0400
From: Kevin Hilman <khilman@ti.com>
To: "Rafael J. Wysocki" <rjw@suse.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH/RFC 0/6] ARM: runtime PM: consolidate runtime PM implementations
Organization: Texas Instruments, Inc.
References: <1302134569-22825-1-git-send-email-khilman@ti.com>
	<201104070738.42956.rjw@suse.com> <871v1eaz0u.fsf@ti.com>
Date: Thu, 07 Apr 2011 10:17:03 -0700
In-Reply-To: <871v1eaz0u.fsf@ti.com> (Kevin Hilman's message of "Thu, 07 Apr
	2011 07:58:57 -0700")
Message-ID: <87hbaa7zhs.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Hilman <khilman@ti.com> writes:

[...]

> Replacing the PM ops for all devices was done on OMAP and SH-mobile
> because that was the only approach we had.  Now that we have device
> power domains (thanks Rafael!), we can be more selective about which
> devices to apply them to.
>
> Note that my RFC patch/series did not do the selective part of deciding
> which devices to override and which ones not to, that part will be
> platform specific.  

Actually, thinking about this a little more, my patch actually does
select only relevant devices, and not *all* platform devices.

In my patch, the device power domain pointers are only added for devices
where a clk_get() actually succeeds.  In the original version, the
runtime PM hooks are overridden for *all* platform devices, but ones
that have no clock (or where clk_get() failed) have the additional
overhead of still calling the custom PM ops, but the custom ops have
nothing to do.

Kevin

