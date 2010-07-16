Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935141Ab0GPAsk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 20:48:40 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42546 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935075Ab0GPAsh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 20:48:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JRyv1LQVbWDhLCNUHVYLHC6ZmcwgFHT/PaKoXofzW4CHDeyCKEfDjDq72xC8l53/HA
         TLuvX8p/jrlB84o5kzE1E8H/syKm4EBBJUziMNmw6AA6JUUm2E2z+o+4EMzV5e59BMWh
         FnL+it9erYYva/bad/19eOrcPSghHeEOD+11s=
MIME-Version: 1.0
In-Reply-To: <20100715085535.GC26212@n2100.arm.linux.org.uk>
References: <4C3C0032.5020702@codeaurora.org>
	<20100713150311B.fujita.tomonori@lab.ntt.co.jp>
	<20100713121420.GB4263@codeaurora.org>
	<20100714104353B.fujita.tomonori@lab.ntt.co.jp>
	<20100714201149.GA14008@codeaurora.org>
	<20100714220536.GE18138@n2100.arm.linux.org.uk>
	<20100715012958.GB2239@codeaurora.org>
	<20100715085535.GC26212@n2100.arm.linux.org.uk>
Date: Thu, 15 Jul 2010 20:48:36 -0400
Message-ID: <AANLkTinVZeaZxt_lWKhjKa0dqhu3_j3BRNySO-2LvMdw@mail.gmail.com>
Subject: Re: [RFC 1/3 v3] mm: iommu: An API to unify IOMMU, CPU and device 
	memory management
From: Tim HRM <zt.tmzt@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Zach Pfeffer <zpfeffer@codeaurora.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, ebiederm@xmission.com,
        linux-arch@vger.kernel.org, dwalker@codeaurora.org, mel@csn.ul.ie,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, andi@firstfloor.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 4:55 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Wed, Jul 14, 2010 at 06:29:58PM -0700, Zach Pfeffer wrote:
>> The VCM ensures that all mappings that map a given physical buffer:
>> IOMMU mappings, CPU mappings and one-to-one device mappings all map
>> that buffer using the same (or compatible) attributes. At this point
>> the only attribute that users can pass is CACHED. In the absence of
>> CACHED all accesses go straight through to the physical memory.
>
> So what you're saying is that if I have a buffer in kernel space
> which I already have its virtual address, I can pass this to VCM and
> tell it !CACHED, and it'll setup another mapping which is not cached
> for me?
>
> You are aware that multiple V:P mappings for the same physical page
> with different attributes are being outlawed with ARMv6 and ARMv7
> due to speculative prefetching.  The cache can be searched even for
> a mapping specified as 'normal, uncached' and you can get cache hits
> because the data has been speculatively loaded through a separate
> cached mapping of the same physical page.
>
> FYI, during the next merge window, I will be pushing a patch which makes
> ioremap() of system RAM fail, which should be the last core code creator
> of mappings with different memory types.  This behaviour has been outlawed
> (as unpredictable) in the architecture specification and does cause
> problems on some CPUs.
>
> We've also the issue of multiple mappings with differing cache attributes
> which needs addressing too...
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Interesting, since I seem to remember the MSM devices mostly conduct
IO through regions of normal RAM, largely accomplished through
ioremap() calls.

Without more public domain documentation of the MSM chips and AMSS
interfaces I wouldn't know how to avoid this, but I can imagine it
creates a bit of urgency for Qualcomm developers as they attempt to
upstream support for this most interesting SoC.

--
Timothy Meade
tmzt #htc-linux
