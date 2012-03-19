Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758697Ab2CSJiC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 05:38:02 -0400
Received: from stringer.orebokech.com ([88.190.240.207]:47021 "EHLO
	stringer.orebokech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173Ab2CSJiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 05:38:00 -0400
X-Greylist: delayed 565 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Mar 2012 05:38:00 EDT
From: Romain Francoise <romain@orebokech.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Linux 3.3 release
Organization: orebokech dot com
References: <CA+55aFyR2TXcKdzXontH8B4Reu40bdY_APhuUJeUxm6D-OuQkg@mail.gmail.com>
X-Face: }9mYu,e_@+e!`Z-P5kVXa3\_b:hdJ"B)ww[&=b<2=awG:GOIM</2q'*t@MNa)R`k0h1KbUu "Ek%gXCQA(?k=Uf9}qgF_x#7/+Ql\R!NJ9[Z[ky\CTYI<H(kc][?[m%*rsf!OG11|f&H[VgX;),"!N JG6IziY\~""3M
Date: Mon, 19 Mar 2012 10:28:32 +0100
In-Reply-To: <CA+55aFyR2TXcKdzXontH8B4Reu40bdY_APhuUJeUxm6D-OuQkg@mail.gmail.com>
	(Linus Torvalds's message of "Sun, 18 Mar 2012 18:25:05 -0700")
Message-ID: <87r4wpx7lr.fsf@silenus.orebokech.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There seems to be a regression in the final release compared to -rc7,
specifically this commit:

> Matthew Garrett (1):
>       PCI: ignore pre-1.1 ASPM quirking when ASPM is disabled

causes an early kernel panic on my machine (Intel DP67BG). Reverting the
change fixes it. Unfortunately it crashes before setting up the video mode
so I don't have the full stack trace, but RIP points to
pcie_aspm_init_link_state().

When the machine boots successfully, dmesg contains the following related
to ASPM:

[    0.382384] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.433016] pci 0000:06:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
