Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab1LVP3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 10:29:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58699 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246Ab1LVP3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 10:29:21 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 7/8] cpufreq: Add support for x86 cpuinfo auto loading v3
Date: Thu, 22 Dec 2011 16:29:16 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop; KDE/4.6.0; x86_64; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        kay.sievers@vrfy.org, gregkh@suse.de
References: <1324338394-4670-1-git-send-email-andi@firstfloor.org> <4EF27517.6010609@zytor.com> <20111222001441.GB10955@alboin.amr.corp.intel.com>
In-Reply-To: <20111222001441.GB10955@alboin.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112221629.16656.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 22, 2011 01:14:41 AM Andi Kleen wrote:
> > So this should be:
> > 
> > 1. added to the scattered CPUID features list;
> > 2. artificially set in the AMD-specific initialization code for the
> > older CPUs.
> 
> Not sure (2) is correct. As far as I understand it's actually different
> mechanisms, just implemented by the same driver.
> 
> Keeping the list for old CPUs is not a big issue anyways.
> 
> Agreed with (1)
> 
> Anyways someone with the hardware should do it. Thomas?
I have something.

Andi: If you don't mind, I'll pick up your patches,
use drivers/base/cpu.c instead of cpuid driver. Then there
will never show up a cpuid version mainline.
I'll call it v4 and this patchset then depends on Kay's work.

I'll also adjust:
  - the microcode typo (in patch fix)
  - add a cpuid hw_pstate (new patch)
  - adjust powernow-k8 to make use of it via x86cpu autoloading
    (in patch adjustings)

Tell me (best in the next hour) if something else should
still be added.

I'll then resend with your From: tag on top.

No idea in which tree this should end (x86-tip, because it's a
x86 feature or Greg's because no further serialization care has
to be taken. I'll vote for Greg's, I already work on his
driver-core tree on the driver-core-next branch where Kay's
stuff already is in).

I'll add everybody to CC.

   Thomas
