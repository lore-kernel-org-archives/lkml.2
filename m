Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571Ab1EYLW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 07:22:26 -0400
Received: from service87.mimecast.com ([94.185.240.25]:35058 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751392Ab1EYLWZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 07:22:25 -0400
Subject: Re: [PATCH v6 00/18] ARM: Add support for the Large Physical
 Address Extensions
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Nicolas Pitre <nico@fluxnic.net>,
        David Brown <davidb@codeaurora.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
In-Reply-To: <201105251310.39609.arnd@arndb.de>
References: <1306273164-18217-1-git-send-email-catalin.marinas@arm.com>
	 <8yapqn7fyab.fsf@huya.qualcomm.com>
	 <alpine.LFD.2.00.1105242042340.3207@xanadu.home>
	 <201105251310.39609.arnd@arndb.de>
Organization: ARM Limited
Date: Wed, 25 May 2011 12:22:15 +0100
Message-ID: <1306322535.31249.14.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 25 May 2011 11:22:31.0560 (UTC) FILETIME=[09B8E880:01CC1ACE]
X-MC-Unique: 111052512222108301
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-25 at 12:10 +0100, Arnd Bergmann wrote:
> On Wednesday 25 May 2011, Nicolas Pitre wrote:
> > > Do you expect non LPAE targets to be able to boot with these changes
> > > applied (and LPAE enabled)?  I am able to build this tree for the
> > > MSM8660 (with a minor patch below), but it fails to boot with LPAE
> > > enabled.  It seems to work fine with LPAE not enabled.
> >
> > I wouldn't expect a LPAE kernel to boot on non LPAE capable hardware.
> >
> > And I don't think we'll ever try to support both LPAE and non-LPAE modes
> > in the same kernel binary either since this has implications all over
> > the place in core kernel mm code.
> 
> Just for information and to complete the picture, what other of these
> combinations are possible?
> 
> * Non-LPAE kernel on LPAE-capable hardware

Works fine. The LPAE-capable processors like A15 support the classic
page table format as well, it's only a configuration bit to switch to
LPAE.

> * LPAE kernel as KVM guest of LPAE kernel

Should work when KVM for A15 becomes available

> * non-LPAE kernel as KVM guest of LPAE kernel

Same as above. KVM shouldn't care much about the underlying OS, it just
sets up the IPA (Intermediate Physical Address) translations and you can
have classic page tables on top.

> * LPAE kernel as KVM guest of non-LPAE kernel

No. KMV without LPAE uses a shadow page tables mechanism and I'm not
aware of any plans to make it (guest) LPAE-aware.

> * non-LPAE kernel as KVM guest of non-LPAE kernel on LPAE-enabled
> hardware

Would work as the current KVM implementation for ARMv7 with classic page
tables (but I don't know what the status it).

-- 
Catalin


