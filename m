Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809Ab2CZPX6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 11:23:58 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55605 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303Ab2CZPX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 11:23:56 -0400
Message-ID: <1332775433.22830.7.camel@ayu>
Subject: Re: Linux 3.3 release
From: Calvin Walton <calvin.walton@kepstin.ca>
To: Romain Francoise <romain@orebokech.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Date: Mon, 26 Mar 2012 11:23:53 -0400
In-Reply-To: <87r4wpx7lr.fsf@silenus.orebokech.com>
References: <CA+55aFyR2TXcKdzXontH8B4Reu40bdY_APhuUJeUxm6D-OuQkg@mail.gmail.com>
	 <87r4wpx7lr.fsf@silenus.orebokech.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-19 at 10:28 +0100, Romain Francoise wrote:
> There seems to be a regression in the final release compared to -rc7,
> specifically this commit:
> 
> > Matthew Garrett (1):
> >       PCI: ignore pre-1.1 ASPM quirking when ASPM is disabled
> 
> causes an early kernel panic on my machine (Intel DP67BG). Reverting the
> change fixes it. Unfortunately it crashes before setting up the video mode
> so I don't have the full stack trace, but RIP points to
> pcie_aspm_init_link_state().
> 
> When the machine boots successfully, dmesg contains the following related
> to ASPM:
> 
> [    0.382384] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
> [    0.433016] pci 0000:06:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'

This commit is also breaking boot on one of my boxes; it's causing the
pata_jmicron driver to fail to detect my IDE boot drive. This was
reported in this thread as well:
https://lkml.org/lkml/2012/3/22/6

Apparently, using the 'pcie_aspm=force' may work around the issue, from
some reports that I've seen when searching around. Haven't tried it
myself, yet.

-- 
Calvin Walton <calvin.walton@kepstin.ca>

