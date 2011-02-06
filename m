Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab1BFXBm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:01:42 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48629 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759Ab1BFXBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:01:40 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 5/5] ACPI: Tie ACPI backlight devices to PCI devices if possible
Date: Mon, 7 Feb 2011 00:01:25 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc3+; KDE/4.4.4; x86_64; ; )
Cc: akpm@linux-foundation.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, rpurdie@rpsys.net
References: <1295033065-13450-1-git-send-email-mjg@redhat.com> <201102062341.19631.rjw@sisk.pl> <20110206225308.GA23557@srcf.ucam.org>
In-Reply-To: <20110206225308.GA23557@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102070001.25814.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, February 06, 2011, Matthew Garrett wrote:
> On Sun, Feb 06, 2011 at 11:41:19PM +0100, Rafael J. Wysocki wrote:
> > On Sunday, February 06, 2011, Matthew Garrett wrote:
> > > Ugh. Ok, how can we fix this?
> > 
> > Not nicely, I'm afraid.
> > 
> > One possible way is to use device_pm_move_after() to rearrange the devices in
> > the PM core's suspend list, but that will happen in the video device being
> > suspended before the new parent (and resumed after it) -- of course, the only
> > option is to move the ACPI video device after the new parent.
> 
> Hang on. Didn't we already have a related issue with the acpi video 
> device being resumed before the video card, resulting in an SMI that 
> hung the system? I thought we'd arranged things such that resuming the 
> ACPI video device wouldn't actually do anything until after the PCI 
> device had been handled? It seems like the correct thing is definitely 
> for it to be suspended before and resumed after...

Yes, it seems so, but I'm not sure what the short term consequences of that
change will be.  Perhaps there will be none. :-)
