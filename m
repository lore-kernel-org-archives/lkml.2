Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab1BFWxR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 17:53:17 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:45528 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759Ab1BFWxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 17:53:16 -0500
Date: Sun, 6 Feb 2011 22:53:09 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: akpm@linux-foundation.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, rpurdie@rpsys.net
Subject: Re: [PATCH 5/5] ACPI: Tie ACPI backlight devices to PCI devices if
	possible
Message-ID: <20110206225308.GA23557@srcf.ucam.org>
References: <1295033065-13450-1-git-send-email-mjg@redhat.com> <201102062135.08171.rjw@sisk.pl> <20110206205619.GA21472@srcf.ucam.org> <201102062341.19631.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102062341.19631.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 06, 2011 at 11:41:19PM +0100, Rafael J. Wysocki wrote:
> On Sunday, February 06, 2011, Matthew Garrett wrote:
> > Ugh. Ok, how can we fix this?
> 
> Not nicely, I'm afraid.
> 
> One possible way is to use device_pm_move_after() to rearrange the devices in
> the PM core's suspend list, but that will happen in the video device being
> suspended before the new parent (and resumed after it) -- of course, the only
> option is to move the ACPI video device after the new parent.

Hang on. Didn't we already have a related issue with the acpi video 
device being resumed before the video card, resulting in an SMI that 
hung the system? I thought we'd arranged things such that resuming the 
ACPI video device wouldn't actually do anything until after the PCI 
device had been handled? It seems like the correct thing is definitely 
for it to be suspended before and resumed after...

-- 
Matthew Garrett | mjg59@srcf.ucam.org
