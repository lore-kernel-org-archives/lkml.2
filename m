Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949Ab2GRQ11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 12:27:27 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36621 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754401Ab2GRQ1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 12:27:24 -0400
MIME-Version: 1.0
In-Reply-To: <20120718161023.GE4495@opensource.wolfsonmicro.com>
References: <20120717185749.GJ4477@opensource.wolfsonmicro.com> <20120718161023.GE4495@opensource.wolfsonmicro.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 18 Jul 2012 10:27:03 -0600
X-Google-Sender-Auth: zVKj8HUmawjVpco1qP9mS0QNY2Q
Message-ID: <CACxGe6tSWGOFs=FgUc8UADmnMM-kGCdwXj9hM2cAep_LKp4M-Q@mail.gmail.com>
Subject: Re: Boot breaks in -next from LEGACY to LINEAR conversion
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Paul Mundt <lethal@linux-sh.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 10:10 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, Jul 17, 2012 at 07:57:49PM +0100, Mark Brown wrote:
>> -next fails to boot for me today on my s3c64xx based systems.  Walking
>> back to the last time I tried and bisecting likely branches I find that
>> commit 910139 (irqdomain: Replace LEGACY mapping with LINEAR) is the one
>> that introduces the build break.  Unfortunately the boot fails before I
>> get a console which makes diagnosis somewhat more tricky than would be
>> ideal.  Any ideas?
>
> Further data: the irq_domain_associate_many() calls that we're now doing
> are also causing WARN_ON()s to go off during boot after commit 98aa46
> (irqdomain: Support for static IRQ mapping and association) causing
> breakage for my interrupt using MFDs.
>
> I don't really have time to investigate now but backing out that commit
> seems to make things much happier, I suspect there's some collision with
> IRQs allocated statically by the platform but I don't immediately see
> what's new here.

I had seen that on my end too, but I thought I had fixed it...  I
guess not (or this is a similar type of failure).  I'll investigate.

g.



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
