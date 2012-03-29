Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933835Ab2C2Uqh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 16:46:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40742 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933711Ab2C2UqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 16:46:15 -0400
Date: Thu, 29 Mar 2012 13:46:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>, bhelgaas@google.com,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        stable@vger.kernel.org, Romain Francoise <romain@orebokech.com>,
        Chris Holland <bandidoirlandes@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Hatem Masmoudi <hatem.masmoudi@gmail.com>, janek <jan0x6c@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH resend] ASPM: Fix pcie devices with non-pcie children
Message-Id: <20120329134614.438e8aaf.akpm@linux-foundation.org>
In-Reply-To: <20120329163206.GA3480@burratino>
References: <1332857861-11562-1-git-send-email-mjg@redhat.com>
	<20120329163206.GA3480@burratino>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Mar 2012 11:32:06 -0500
Jonathan Nieder <jrnieder@gmail.com> wrote:

> From: Matthew Garrett <mjg@redhat.com>
> Date: Tue, 27 Mar 2012 10:17:41 -0400
> 
> Since 3.2.12 and 3.3, some systems are failing to boot with a BUG_ON.
> Some other systems using the pata_jmicron driver fail to boot because
> no disks are detected.  Passing pcie_aspm=force on the kernel command
> line works around it.
> 
> The cause: commit 4949be16822e ("PCI: ignore pre-1.1 ASPM quirking
> when ASPM is disabled") changed the behaviour of
> pcie_aspm_sanity_check() to always return 0 if aspm is disabled, in
> order to avoid cases where we changed ASPM state on pre-PCIe 1.1
> devices.  This skipped the secondary function of
> pcie_aspm_sanity_check which was to avoid us enabling ASPM on devices
> that had non-PCIe children, causing trouble later on.  Move the
> aspm_disabled check so we continue to honour that scenario.
> 
> Addresses https://bugzilla.kernel.org/show_bug.cgi?id=42979 and
>           http://bugs.debian.org/665420
> 
> [jn: with more symptoms in log message]
> 
> Reported-by: Romain Francoise <romain@orebokech.com> # kernel panic
> Reported-by: Chris Holland <bandidoirlandes@gmail.com> # disk detection trouble
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> Cc: stable@vger.kernel.org
> Tested-by: Hatem Masmoudi <hatem.masmoudi@gmail.com> # Dell Latitude E5520
> Tested-by: janek <jan0x6c@gmail.com> # pata_jmicron with JMB362/JMB363
> Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
> ---
> Hi Andrew,
> 
> This patch only appeared a couple of days ago[1], but it fixes a
> noticeable regression so I would like to make sure the patch becomes
> part of mainline and the 3.2.y- and 3.3.y-stable trees soon.  Could
> you pick it up for linux-next until it makes its way to the PCI tree?
> 
> Regression was introduced between 3.3-rc7 and 3.3 and between 3.2.11
> and 3.2.12.  Prevents boot on affected machines, though there is a
> workaround.  Details about the symptoms and fix are above.

Just about the only person who wasn't copied on this email is, umm, the
PCI maintainer!
