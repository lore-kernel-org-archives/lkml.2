Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932778Ab2CGU17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 15:27:59 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:60555 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757021Ab2CGU14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 15:27:56 -0500
Message-ID: <4F57C4C6.2070602@wwwdotorg.org>
Date: Wed, 07 Mar 2012 13:27:50 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: Michal Marek <mmarek@suse.cz>, linux-arch@vger.kernel.org,
        Michal Simek <monstr@monstr.eu>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Mike Frysinger <vapier@gentoo.org>, nico@fluxnic.net,
        linux-sh@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>,
        uclinux-dist-devel@blackfin.uclinux.org, sparclinux@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Subject: Re: [PATCH 2/3] Kbuild: Implement CONFIG_UIMAGE_KERNEL_NOLOAD
References: <1331080238-1524-1-git-send-email-swarren@wwwdotorg.org> <1331080238-1524-2-git-send-email-swarren@wwwdotorg.org> <20120307180815.GA27213@game.jcrosoft.org> <4F57AB92.6060907@wwwdotorg.org> <20120307183633.GB27213@game.jcrosoft.org>
In-Reply-To: <20120307183633.GB27213@game.jcrosoft.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2012 11:36 AM, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 11:40 Wed 07 Mar     , Stephen Warren wrote:
>> On 03/07/2012 11:08 AM, Jean-Christophe PLAGNIOL-VILLARD wrote:
>>> On 17:30 Tue 06 Mar     , Stephen Warren wrote:
>>>> This allows the user to use U-Boot's mkimage's -T kernel_noload option
>>>> if their arch Kconfig allows it, and they desire.
>>>>
>>>> Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
>>>> ---
>>>> The next patch enables this new CONFIG_ALLOW_ option for ARM. I assume
>>>> that some other architectures will also be able to enable it, but I'm
>>>> not familiar enough with any to know which.
>>> I'm going to repeat. I don't think any impromevent here.
>>>
>>> with no specific kernel load address the uImage for is useless/
>>
>> No, the whole point of this type of kernel image is that it doesn't need
>> a specific load address; the kernel zImage can run from anywhere in RAM
>> (provided AUTO_ZRELADDR is enabled, subject to some slight
>> restrictions), and hence the uImage doesn't need to be loaded to or
>> moved to any particular location.
>>
>> The scripts that U-Boot runs determine where the image gets loaded into
>> memory.
>
> so instead of spending time on the uImage add simply the support the zImage to
> U-Boot as this AUTO_ZRELADDR have 0 advantage compare to the zImage

Thinking more about this, I guess the reliance on AUTO_ZRELADDR is wrong
here; Russell, Nico, is the ARM decompressor fully position-independent
irrespective of the AUTO_ZRELADDR setting. That setting just determines
where the decompressor writes its output, not what address the
decompressor can run at, right? So, this KERNEL_NOLOAD feature could be
enabled in all cases on ARM, not only when AUTO_ZRELADDR is enabled.

As such to address Jean-Christophe's most recent comment above, this
patch isn't about adding support for AUTO_ZRELADDR, but for U-Boot's
kernel_noload feature, so comparisons should be drawn between
kernel_noload uImages and zImage, not between AUTO_ZRELADDR and zImage.

In other words:

We already have and need ZRELADDR no matter what, for reasons unrelated
to U-Boot/uImage.

Patch 1 in this series is just consolidating duplicate definitions, and
doesn't introduce any new features, so I think hope you think it's a
good thing no matter what anyone thinks about U-Boot/uImage.

I assume you're only arguing about patches 2 and 3?
