Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab2LJOTu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 09:19:50 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:58288 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735Ab2LJOTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 09:19:49 -0500
Message-ID: <50C5EF96.2040006@ti.com>
Date: Mon, 10 Dec 2012 19:50:06 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: "'Catalin Marinas'" <Catalin.Marinas@arm.com>,
        Boojin Kim <boojin.kim@samsung.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        "'Will Deacon'" <will.deacon@arm.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>
Subject: Re: [PATCH 1/3] ARM: MM: Add the workaround of Errata 774769
References: <001701cdd669$19e8cdd0$4dba6970$%kim@samsung.com> <50C5ED3E.2050308@ti.com> <20121210141604.GN14363@n2100.arm.linux.org.uk>
In-Reply-To: <20121210141604.GN14363@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 December 2012 07:46 PM, Russell King - ARM Linux wrote:
> On Mon, Dec 10, 2012 at 07:40:06PM +0530, Santosh Shilimkar wrote:
>> Whats the stand on such erratas ? I saw on one of thread one of
>> you suggesting to stop patching kernel where secure/non-secure
>> kernel will need different errata WA.
>
> Well, yes, there's that too.  I think were we got to was deciding that
> it is impossible to tell whether an errata is required for any particular
> SoC: even when you know the rXpX number of the core, you don't know if,
> as part of the design, the manufacturer incorporated some fix.
>
> So, the conclusion we came to was that the _only_ place that work-arounds
> like these can be enabled is before we get anywhere near the kernel - in
> whatever pre-kernel code the platform has, and doing whatever platform
> specific magic is required to get those work-arounds enabled.
>
> What that means is that having the work-arounds in the kernel is pretty
> pointless when it's a matter of enabling a bit or two in some secure-only
> register.
>
> I don't think I heard any objections to removing those work-arounds which
> fall into this category from the kernel; I think that's something we need
> to schedule for a few kernel versions time, after we've put them into the
> feature-removal file, and marked them in the config as going away.
>
Thanks for confirming it. All the patches in the $subject series falls
into secure/non-secure category and hence subject to the same issues.

Regards
Santosh


