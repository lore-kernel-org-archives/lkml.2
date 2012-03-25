Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382Ab2CYPSe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 11:18:34 -0400
Received: from netrider.rowland.org ([192.131.102.5]:38771 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756290Ab2CYPSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 11:18:33 -0400
Date: Sun, 25 Mar 2012 11:18:31 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: NeilBrown <neilb@suse.de>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-pm@lists.linux-foundation.org>,
        Chris Ball <cjb@laptop.org>, <linux-mmc@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Recent "Run the driver callback directly" patch breaks
 libertas suspend
In-Reply-To: <20120325203849.7a908e32@notabene.brown>
Message-ID: <Pine.LNX.4.44L0.1203251116290.16994-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Mar 2012, NeilBrown wrote:

> Hi Rafael,
> 
>  Your recent patch:
>    commit 35cd133c
>    PM: Run the driver callback directly if the subsystem one is not there
> 
>  breaks suspend for my libertas wifi and probably other SDIO devices.
> 
>  SDIO (and possible MMC in general) has a protocol where the suspend
>  method can return -ENOSYS and this means "There is no point in suspending,
>  just turn me off".
> 
>  The device itself "mmc1:0001" (I think) doesn't have any bus etc 'suspend'
>  function so the new code call the device's suspend function which returns
>  ENOSYS and the suspend fails.
> 
>  The previous code ignores the device as there is no bus suspend, and when it
>  gets to suspend the ancestor - which for me is omap_hsmmc.1, it calls the
>  device suspend function catches the ENOSYS, and turns it off.
> 
>  I suspect just reverting it isn't the right long term solution, however I
>  can confirm that it works for me for now.
> 
>  I'm happy to try any alternate fixes you would like to suggest (but I cannot
>  promise how quickly I will get the testing done).

With a little restructuring, this might be a good application for
pm_runtime_no_callbacks().

Alan Stern

