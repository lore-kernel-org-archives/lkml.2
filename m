Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131Ab2EaLSn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 07:18:43 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:40344 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751924Ab2EaLSm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 07:18:42 -0400
MIME-Version: 1.0
In-Reply-To: <201205310922.18550.arnd@arndb.de>
References: <1338375394-16268-1-git-send-email-kishon@ti.com>
	<201205301843.51568.arnd@arndb.de>
	<CAAe_U6LFFstds=iQ7cy7gM9vWbfRgf5z0gaRp_-bu0Qjx6eA1Q@mail.gmail.com>
	<201205310922.18550.arnd@arndb.de>
Date: Thu, 31 May 2012 16:48:40 +0530
Message-ID: <CAAe_U6J3p9Lh9g82tSSLxOJ7nqrozdRe11zV_v2rqTuMYPjbyA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] omap: add ocp2scp as a misc driver
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: paul@pwsan.com, tony@atomide.com, linux@arm.linux.org.uk, b-cousson@ti.com,
        gregkh@linuxfoundation.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        balbi@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Thu, May 31, 2012 at 2:52 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 31 May 2012, ABRAHAM, KISHON VIJAY wrote:
>> >
>> > Just put the devices you actually want into the device tree instead and
>> > have them automatically created.
>>
>> But shouldn't device tree support and non-device tree support co-exist
>> till the non-device tree is completely knocked out of the kernel? Even
>
> Well, it's a new driver, so there is no regression in supporting it only
> on DT-enabled boards. OMAP5 is DT-only anyway and OMAP4 only supports two
> boards that should both be working with the generic DT code already.
>
>> then shouldn't there be a separate driver to extract the child nodes
>> of ocp2scp and create a device (using of_platform_populate)?
>> As far as I've seen, the devices are automatically created (by virtue
>> of of_platform_populate() in  mach-omap2/board-generic.c in omap case)
>> only for the devices that is connected to the system bus. For other
>> cases, the parent should be responsible for creating the child
>> devices.
>
> I would mark the multiplexed device compatible with "simple-bus", which
> results in the child devices automatically getting added.

hmm.. ocp2scp has a sysconfig register and it also has a module mode
by which it can be enabled/disabled. I was making use of pm_runtime
API's to control these registers (Apart from creating child devices,
the driver also has a call to pm_runtime_enable). I'm not sure if with
"simple-bus" we'll be able to do those. I have to check on that.

Thanks
Kishon
