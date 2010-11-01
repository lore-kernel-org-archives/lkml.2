Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949Ab0KAVZa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 17:25:30 -0400
Received: from straum.hexapodia.org ([207.7.131.186]:40877 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab0KAVZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 17:25:28 -0400
X-Greylist: delayed 340 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Nov 2010 17:25:28 EDT
Date: Mon, 1 Nov 2010 14:19:48 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: srajiv@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: [2.6.37-rc1 REGRESSION] suspend fails on x200 (was Re: [PATCH]
	tpm: Autodetect itpm devices)
Message-ID: <20101101211948.GA19250@hexapodia.org>
References: <1287697360-31273-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287697360-31273-1-git-send-email-mjg@redhat.com>
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 05:42:40PM -0400, Matthew Garrett wrote:
> Some Lenovos have TPMs that require a quirk to function correctly. This can
> be autodetected by checking whether the device has a _HID of INTC0102. This
> is an invalid PNPid, and as such is discarded by the pnp layer - however
> it's still present in the ACPI code, so we can pull it out that way. This
> means that the quirk won't be automatically applied on non-ACPI systems,
> but without ACPI we don't have any way to identify the chip anyway so I
> don't think that's a great concern.

Matthew,

Thanks for coming up with a clean way to integrate this iTPM support!

Unfortunately, automagically loading tpm_tis results in a suspend
regression on my X200:

(hand-transcribed, sorry for any typos)

[   16.759044] tpm_tis 00:0a: 1.2 TPM (device-id 0x1020, rev-id 6)
[ 7537.636134] PM: Entering mem sleep
[ 7537.636221] Suspending console(s) (use no_console_suspend to debug)
[ 7537.636668] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[ 7537.658111] tpm_tis 00:0a: tpm_transmit: tpm_send: error -5
[ 7537.658119] legacy_suspend(): pnp_bus_suspend+0x0/0x6a returns -5
[ 7537.658122] PM: Device 00:0a failed to suspend: error -5
[ 7537.681940] sd 0:0:0:0: [sda] Stopping disk
[ 7538.564024] PM: Some devices failed to suspend

I suspect that it would have failed previously if I'd forced the module
to load, but since tpm_tis now loads automatically as of 2.6.37-rc1, I
have to "rmmod tpm_tis" for suspend to work.

-andy
