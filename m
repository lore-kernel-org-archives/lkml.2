Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040Ab1CBWeJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 17:34:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46203 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757860Ab1CBWeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 17:34:07 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [PATCH 0/2] Re: 2.6.38 regression caused by commit 415e12b
Date: Wed, 2 Mar 2011 23:30:49 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc6+; KDE/4.4.4; x86_64; ; )
Cc: linux-usb@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ozan Caglayan <ozan@pardus.org.tr>
References: <20110228014218.GA11083@xanatos> <20110302034140.GA2205@xanatos> <201103021221.06312.rjw@sisk.pl>
In-Reply-To: <201103021221.06312.rjw@sisk.pl>
MIME-Version: 1.0
Message-Id: <201103022330.49297.rjw@sisk.pl>
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 02, 2011, Rafael J. Wysocki wrote:
> On Wednesday, March 02, 2011, Sarah Sharp wrote:
> > On Wed, Mar 02, 2011 at 01:17:04AM +0100, Rafael J. Wysocki wrote:
> > > On Wednesday, March 02, 2011, Sarah Sharp wrote:
> > > > On Wed, Mar 02, 2011 at 12:30:16AM +0100, Rafael J. Wysocki wrote:
> > > > > On Tuesday, March 01, 2011, Sarah Sharp wrote:
> > > > > > On Tue, Mar 01, 2011 at 09:55:33PM +0100, Rafael J. Wysocki wrote:
> > > > > > > Please check if the appended patch (on top of the Linus' current) helps.
> > > > > > 
> > > > > > Sorry, it doesn't help.  Same message as before.
> > > > > 
> > > > > Can you send dmesg with the patch applied, please?
> > > > 
> > > > Attached.
> > > 
> > > Something's fishy.  Evidently, _OSC is not executed on your system
> > > although it should be with the patch.
> > > 
> > > Please try the patch below instead and send dmesg (either way).
> > 
> > The host controller works with that patch.  dmesg is attached.
> 
> OK, thanks.
> 
> There are two problems.  First, your BIOS says that ASPM is not supported
> by it, so we don't call _OSC, which should be fixed by the previous patch.
> Second, pci_msi_enabled() returns 0 on your system, which is kind of strange,
> because it evidently uses MSIs (as visible in the dmesg).
> 
> While I think we can safely request _OSC control even if ASPM is not supported
> by the hardware (according to the BIOS), which is done after the first patch,
> we need to figure out why 0 is returned by pci_msi_enabled() on your system
> and try to work around that.

Regardless, I think we should report MSI and ASPM support to the BIOS unless
directly disabled via the kernel command line or .config.

I'm going to send two patches in replies to this message.  Please apply them
both on top of 2.6.38-rc7 and report back.

Thanks,
Rafael

