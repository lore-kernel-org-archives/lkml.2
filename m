Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155Ab1IHJkw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 05:40:52 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56677 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758126Ab1IHJku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 05:40:50 -0400
Date: Thu, 8 Sep 2011 10:40:00 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Keng-Yu Lin <kengyu@canonical.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH] achi, ata_generic: Add ASMedia ASM1061 support
Message-ID: <20110908104000.53823901@lxorguk.ukuu.org.uk>
In-Reply-To: <1315453426-8796-1-git-send-email-kengyu@canonical.com>
References: <1315453426-8796-1-git-send-email-kengyu@canonical.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  8 Sep 2011 11:43:46 +0800
Keng-Yu Lin <kengyu@canonical.com> wrote:

> ASM1061 PCI-E to SATA bridge controller has two variants.
> One works under AHCI and the other works with ata_generic.

ata_generic should be an absolute last resort - it doesn't support error
recovery by speed dropping, mode setting, hotplug, timing tuning etc. 

Is there any documentation on the device or does it appear to follow the
usual mode setting behaviours ? The web page merely says

"Bus Master Programming Interface to IDE ATA Controller Rev. 1.0"

which covers only the basic transfers and not timing (ie ata_generic) as
you say but there are a few ways to find out more about how it works

- dump the PCI space in IDE mode and see if it looks like d1510r1 - some
  controllers are pretty unimaginative and so follow follow Appendix B
  of this document.

- see if it will run with the pata_acpi driver (ie it has _GTM and
  similar methods in the BIOS). If it does then this is preferable as it
  can do limited mode handling and you can also see what the ACPI code
  itself actually does for _GTM/_STM.

- See if Asmedia will provide documentation. I don't see anything useful
  on the English web site but perhaps someone has as Asmedia contact ?

The AHCI one looks good - AHCI standardises all this
stuff so the AHCI one can just be a device id.

