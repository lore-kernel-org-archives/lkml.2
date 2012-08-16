Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab2HPMx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 08:53:58 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48870 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752556Ab2HPMx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 08:53:57 -0400
Date: Thu, 16 Aug 2012 13:53:24 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH v2 02/31] arm64: Kernel booting and initialisation
Message-ID: <20120816125324.GB30876@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <1344966752-16102-3-git-send-email-catalin.marinas@arm.com>
 <201208151320.02313.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208151320.02313.arnd@arndb.de>
Thread-Topic: [PATCH v2 02/31] arm64: Kernel booting and initialisation
Accept-Language: en-GB, en-US
Content-Language: en-US
acceptlanguage: en-GB, en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 02:20:02PM +0100, Arnd Bergmann wrote:
> On Tuesday 14 August 2012, Catalin Marinas wrote:
> 
> > +The AArch64 exception model is made up of a number of exception levels
> > +(EL0 - EL3), with EL0 and EL1 having a secure and a non-secure
> > +counterpart.  EL2 is the hypervisor level and exists only in non-secure
> > +mode. EL3 is the highest priority level and exists only in secure mode.
> 
> I'm always confused by a description like this. It sounds like you cannot
> have a hypervisor if you have code running in secure mode in EL3. What
> I instead understand is that you enter non-secure mode by going from
> EL3 into EL2.

>From EL3 you can drop to either EL2 (non-secure) or EL1 (secure or
non-secure), it's the highest privilege level. But we don't support the
kernel entering at EL3, the SoC firmware runs in this mode. I'll try to
make it clearer.

> > +2. Setup the device tree
> > +-------------------------
> > +
> > +Requirement: MANDATORY
> > +
> > +The device tree blob (dtb) must be no bigger than 2 megabytes in size
> > +and placed at a 2-megabyte boundary within the first 512 megabytes from
> > +the start of the kernel image. This is to allow the kernel to map the
> > +blob using a single section mapping in the initial page tables.
> 
> I've seen people put firmware for some peripherals into the device tree,
> so that a device driver can grab a blob from there and load it into the
> device, rather than calling request_firmware() which would fail if the
> OS running on the system does not contain the blob. If such firmware is
> too large, you end up violating the 2 MB limit you impose here.
> 
> Should we keep that limit and declare those use cases as invalid, or
> should we try to make the boot protocol more flexible?

I would be ok to allowing larger range here but we currently don't get
the information about the size of the dtb early enough to know how much
to map. We could make some other arbitrary choice if needed like being
in the first 16MB of RAM and we map this range.

-- 
Catalin
