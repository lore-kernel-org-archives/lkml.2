Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267Ab1DTPfg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 11:35:36 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:41753 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449Ab1DTPff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 11:35:35 -0400
Date: Wed, 20 Apr 2011 17:35:30 +0200
From: Borislav Petkov <bp@amd64.org>
To: rwhitton@iee.org
Cc: Clemens Ladisch <clemens@ladisch.de>, linux-kernel@vger.kernel.org
Subject: Re: Background memory scrubbing
Message-ID: <20110420153529.GA2312@gere.osrc.amd.com>
References: <16117.1303310442@jupiter.eclipse.co.uk>
 <4DAEF98D.2090802@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DAEF98D.2090802@ladisch.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 05:19:41PM +0200, Clemens Ladisch wrote:
> > Unfortunately in common with a large number of hardware platforms
> > background scrubbing isn't supported in the hardware (even though ECC
> > error correction is supported) and thus there is no BIOS option to
> > enable it.
> 
> Which hardware platform is this?  AFAICT all architectures with ECC
> (old AMD64, Family 0Fh, Family 10h) also have scrubbing support.
> If your BIOS is too dumb, just try enabling it directly (bits 0-4 of
> PCI configuration register 0x58 in function 3 of the CPU's northbridge
> device, see the BIOS and Kernel's Developer's Guide for details).

Or even better, if on AMD, you can build the amd64_edac module
(CONFIG_EDAC_AMD64) and do

echo <x> > /sys/devices/system/edac/mc/mc<y>/sdram_scrub_rate

where x is the scrubbing bandwidth in bytes/sec and y is the memory
controller on the machine, i.e. node.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
