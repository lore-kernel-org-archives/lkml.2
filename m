Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab1DTPrL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 11:47:11 -0400
Received: from smtpout.karoo.kcom.com ([212.50.160.34]:65291 "EHLO
	smtpout.karoo.kcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629Ab1DTPrG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 11:47:06 -0400
X-IronPort-AV: E=Sophos;i="4.64,246,1301871600"; 
   d="scan'208";a="763086672"
MIME-Version: 1.0
X-Priority: Normal
X-Mailer: AtMail PHP 5.62
Message-ID: <18563.1303314382@jupiter.eclipse.co.uk>
To: "Borislav Petkov" <bp@amd64.org>, <rwhitton@iee.org>
Reply-To: rwhitton@iee.org
Content-Type: text/plain; charset="utf-8"
X-Origin: 213.121.168.130
X-Atmail-Account: rwhitton@jupiter.eclipse.co.uk
Date: Wed, 20 Apr 2011 16:46:22 +0100
Subject: Re: Background memory scrubbing
From: Robert Whitton <rwhitton@iee.org>
Cc: "Clemens Ladisch" <clemens@ladisch.de>, <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Wed, Apr 20, 2011 at 05:19:41PM +0200, Clemens Ladisch wrote:
> > > Unfortunately in common with a large number of hardware platforms
> > > background scrubbing isn't supported in the hardware (even though ECC
> > > error correction is supported) and thus there is no BIOS option to
> > > enable it.
> > 
> > Which hardware platform is this? AFAICT all architectures with ECC
> > (old AMD64, Family 0Fh, Family 10h) also have scrubbing support.
> > If your BIOS is too dumb, just try enabling it directly (bits 0-4 of
> > PCI configuration register 0x58 in function 3 of the CPU's northbridge
> > device, see the BIOS and Kernel's Developer's Guide for details).
> 
> Or even better, if on AMD, you can build the amd64_edac module
> (CONFIG_EDAC_AMD64) and do
> 
> echo  > /sys/devices/system/edac/mc/mc/sdram_scrub_rate
> 
> where x is the scrubbing bandwidth in bytes/sec and y is the memory
> controller on the machine, i.e. node.
> 
> -- 
> Regards/Gruss,
> Boris.
> 

Unfortunately that also isn't an option on my platform(s). There surely must be a way for a module to be able to get a mapping for each physical page of memory in the system and to be able to use that mapping to do atomic read/writes to scrub the memory.
