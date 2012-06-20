Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468Ab2FTX7W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 19:59:22 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:45517 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754530Ab2FTX7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 19:59:20 -0400
X-Sasl-enc: cLMDLC6f4b/JFcXRxl9xl6vQ0FsfQu4cppmQmqrmr1Od 1340236760
Date: Wed, 20 Jun 2012 20:59:18 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@amd64.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
        "Yu, Fenghua" <fenghua.yu@intel.com>, X86-ML <x86@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 2/2] x86, microcode: Make reload interface per system
Message-ID: <20120620235918.GF4223@khazad-dum.debian.net>
References: <CANDHA0jf2fLOtg1E6CbyNM=omn=kj=YoRJ3VTkNA0AhkS-MLtg@mail.gmail.com>
 <3E5A0FA7E9CA944F9D5414FEC6C7122007737623@ORSMSX105.amr.corp.intel.com>
 <20120619232857.GH5996@aftab.osrc.amd.com>
 <1340182778.21745.75.camel@twins>
 <20120620230856.GA4223@khazad-dum.debian.net>
 <4FE2585A.3000505@zytor.com>
 <20120620232359.GD2016@aftab.osrc.amd.com>
 <4FE25C7E.9030109@zytor.com>
 <4FE25DF9.2020305@zytor.com>
 <20120620234611.GA3440@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120620234611.GA3440@aftab.osrc.amd.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2012, Borislav Petkov wrote:
> * we don't need the userspace tool to split the blob - we have one
> single file we load and the driver picks out what it needs.

Yes.  A smarter userspace tool is useful to reduce the size of the
microcode blob that ends up linked to the kernel or added to the
initramfs in distros that generate the initramfs at the target system
when you install a kernel (like Debian does), but it is in no way
*required*.

Typically you go from ~512KiB uncompressed (all binary microcodes) to
8-32KiB uncompressed when you target only the [online] processors of the
current system.  Nice for embedded, I suppose.

> In the end, we have one unified ucode loading procedure:
> 
> 1. put the blob in /lib/firmware/...
> 2. echo 1 > /sys/devices/system/cpu/microcode/reload
> 
> That's it - it can't be simpler than that.

Indeed.  And with an invariant microcode name for the Intel driver, one
can use the standard userspace tooling that detects which firmware needs
to go into the initramfs when no special tooling is installed.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
