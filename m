Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab0C3VOM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 17:14:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40482 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754668Ab0C3VOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 17:14:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [Regression, post-rc2] Commit a5ee4eb7541 breaks OpenGL on RS780 (was: Re: Linux 2.6.34-rc3)
Date: Tue, 30 Mar 2010 23:16:45 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc2-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@gmail.com>, dri-devel@lists.sourceforge.net,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Clemens Ladisch <clemens@ladisch.de>,
       Alex Deucher <alexdeucher@gamil.com>, stable@kernel.org,
       Greg KH <gregkh@suse.de>
References: <alpine.LFD.2.00.1003301029250.3707@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1003301029250.3707@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201003302316.45651.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 March 2010, Linus Torvalds wrote:
...
> Other than that? Random fixes and updates all over. Mostly drivers and 
> filesystems, and mostly fairly small things. If you had PCI resource 
> conflict problems with the early -rc's due to the _CRS window thing, for 
> example, that should hopefully be fixed. See the appended shortlog for 
> other details.

...

> Clemens Ladisch (4):
>       firewire: core: fw_iso_resource_manage: fix error handling
>       firewire: ohci: add cycle timer quirk for the TI TSB12LV22
>       ALSA: cmipci: work around invalid PCM pointer
>       PCI quirk: RS780/RS880: work around missing MSI initialization

This one (commit a5ee4eb7541) broke OpenGL acceleration on my new test box
which happens to have a RS780.

The symptom is that every operation involving the GPU is _very_ slow, so the
window manager eventually disables compositing.  Reverting this commit makes
things work flawlessly again.

So, please revert.

BTW, I don't think it's a -stable material.

Thanks,
Rafael
