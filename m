Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759424Ab1LOTVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 14:21:39 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34185 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759366Ab1LOTVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 14:21:37 -0500
Date: Thu, 15 Dec 2011 11:21:31 -0800
From: Tejun Heo <tj@kernel.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        kay.sievers@vrfy.org
Subject: Re: [RFC][PATCH 4/4] ahci: support hot plug when port/controller
 is runtime suspended
Message-ID: <20111215192131.GE32002@google.com>
References: <1323954769-3918-1-git-send-email-ming.m.lin@intel.com>
 <1323954769-3918-5-git-send-email-ming.m.lin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323954769-3918-5-git-send-email-ming.m.lin@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Dec 15, 2011 at 09:12:49PM +0800, Lin Ming wrote:
> I use eSATA to test disk hot plug.
> With previous 3 patches applied, disk hot plug does not wok
> when ahci port/controller is runtime suspended.
> 
> There are 2 cases we need to handle for hot plug:
> 
> 1. port suspended, controller active
>    Is IRQ need to be enabled for port to detect hot plug? 
> 
> 2. port suspended, controller suspended
>    Will controller get a PME when hot plug happens?
> 
> I'm still investigating hot plug support.
> 
> Anyone has comment?

SATA link detection requires hot wire and keeping wire hot takes
power.  I think it's fair tradeoff to not support hotplug while
powersaving is on.  We have warm plug mechanism (the SCSI rescan
trigger via sysfs) after all.  It would be nice if things like that is
somehow exported to userland in easy way tho (cc'ing Kay), but I
frankly don't have much idea where that would fit.

Thanks.

-- 
tejun
