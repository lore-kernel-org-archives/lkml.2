Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758418Ab2F0SPJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 14:15:09 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:51163 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014Ab2F0SPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 14:15:07 -0400
Date: Wed, 27 Jun 2012 19:15:03 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: UEFI Secure boot using qemu-kvm
Message-ID: <20120627181503.GA7775@srcf.ucam.org>
References: <1340818445.3175.73.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340818445.3175.73.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 06:34:05PM +0100, James Bottomley wrote:

> The purpose of this email is to widen the pool of people who are playing
> with UEFI Secure boot.  The Linux Foundation Technical Advisory Board
> have been looking into this because it turns out to be rather difficult
> to lay your hands on real UEFI Secure Boot enabled hardware.

http://tunnelmountain.net/ is the canonical source, but I believe that 
these are now out of stock and waiting for Intel to finish the 
firmware for the replacement.

> The current state is that I've managed to lock down the secure boot
> virtual platform with my own PK and KEK and verified that I can generate
> signed efi binaries that will run on it (and that it will refuse to run
> unsigned efi binaries).  Finally I've demonstrated that I can sign
> elilo.efi (this has to be built specially because of the bug in gnu-efi)
> and have it boot an unsigned linux kernel when the platform is in secure
> mode (I've booted up to an initrd root prompt).

It's probably worth noting that booting unsigned kernels violates the 
expectations of various vendors 
(http://msdn.microsoft.com/en-us/library/windows/desktop/hh848062%28v=vs.85%29.aspx 
would be unnecessary if you're supporting unsigned kernels, for 
example). There's no public cross-vendor guidance on this, but I'm 
trying to get that rectified.

As well as sbsign there's also https://github.com/vathpela/pesign for 
anyone stuck relying on nss rather than openssl for awkward regulatory 
reasons.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
