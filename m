Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab1DTPrD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 11:47:03 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:42037 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629Ab1DTPrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 11:47:01 -0400
Date: Wed, 20 Apr 2011 17:46:58 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Borislav Petkov <bp@amd64.org>
Cc: rwhitton@iee.org, Clemens Ladisch <clemens@ladisch.de>,
        linux-kernel@vger.kernel.org
Subject: Re: Background memory scrubbing
Message-ID: <20110420154658.GD1624@x4.trippels.de>
References: <16117.1303310442@jupiter.eclipse.co.uk>
 <4DAEF98D.2090802@ladisch.de>
 <20110420153529.GA2312@gere.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110420153529.GA2312@gere.osrc.amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.04.20 at 17:35 +0200, Borislav Petkov wrote:
> On Wed, Apr 20, 2011 at 05:19:41PM +0200, Clemens Ladisch wrote:
> > > Unfortunately in common with a large number of hardware platforms
> > > background scrubbing isn't supported in the hardware (even though ECC
> > > error correction is supported) and thus there is no BIOS option to
> > > enable it.
> > 
> > Which hardware platform is this?  AFAICT all architectures with ECC
> > (old AMD64, Family 0Fh, Family 10h) also have scrubbing support.
> > If your BIOS is too dumb, just try enabling it directly (bits 0-4 of
> > PCI configuration register 0x58 in function 3 of the CPU's northbridge
> > device, see the BIOS and Kernel's Developer's Guide for details).
> 
> Or even better, if on AMD, you can build the amd64_edac module
> (CONFIG_EDAC_AMD64) and do
> 
> echo <x> > /sys/devices/system/edac/mc/mc<y>/sdram_scrub_rate
> 
> where x is the scrubbing bandwidth in bytes/sec and y is the memory
> controller on the machine, i.e. node.

BTW is it really necessary to print the following to syslog:

EDAC amd64: pci-read, sdram scrub control value: 15
EDAC MC: Read scrub rate: 97650

everytime one runs:
 # cat /sys/devices/system/edac/mc/mc0/sdram_scrub_rate
97650

?
-- 
Markus
