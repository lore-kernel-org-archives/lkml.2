Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab1KVSJx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 13:09:53 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59638 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371Ab1KVSJv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 13:09:51 -0500
MIME-Version: 1.0
In-Reply-To: <20111122174544.GA19739@n2100.arm.linux.org.uk>
References: <1321926047-14211-1-git-send-email-mturquette@linaro.org>
 <20111122154259.GA18954@kroah.com> <20111122174544.GA19739@n2100.arm.linux.org.uk>
From: Mike Turquette <mturquette@linaro.org>
Date: Tue, 22 Nov 2011 10:09:29 -0800
Message-ID: <CAPtuhTgFPZA9U-8heNw1eNUnHLFv2w+LzXg5rdjSx3J53Xy+2g@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] common clk framework
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Greg KH <greg@kroah.com>, Mike Turquette <mturquette@ti.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jeremy.kerr@canonical.com,
        broonie@opensource.wolfsonmicro.com, tglx@linutronix.de,
        linus.walleij@stericsson.com, amit.kucheria@linaro.org,
        dsaxena@linaro.org, patches@linaro.org, linaro-dev@lists.linaro.org,
        paul@pwsan.com, grant.likely@secretlab.ca, sboyd@quicinc.com,
        shawn.guo@freescale.com, skannan@quicinc.com, magnus.damm@gmail.com,
        arnd.bergmann@linaro.org, eric.miao@linaro.org,
        richard.zhao@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 9:45 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Tue, Nov 22, 2011 at 07:42:59AM -0800, Greg KH wrote:
>> On Mon, Nov 21, 2011 at 05:40:42PM -0800, Mike Turquette wrote:
>> >   .sysfs support.  Visualize your clk tree at /sys/clk!  Where would be
>> > a better place to put the clk tree besides the root of /sys/?
>>
>> Um, in the "proper" place for it under /sys/devices like the rest of the
>> device tree is?
>
> I'd suggest that making the clock tree visible in sysfs (and therefore
> part of the kernel ABI) is not a good idea.  Some of the nodes in there
> will be specific to the implementation.  Exposing the clock nodes means
> that if you have to change the clock tree structure, you change the
> visible userspace ABI.

It is true that the ABI will change dynamically.

>
> So, I'd suggest that we need to see a justification for this, rather
> than exposing this stuff via debugfs as has been done with existing
> implementations.

Userspace tools like powerdebug (and maybe someday powertop) hope to
use a reliable-looking interface to view clk data.  There are obvious
uses for this data in a debug tool, the most obvious of which is
"which clk isn't turning off when it should?".

I can migrate this stuff to debugfs, but it adds the burden of having
debugfs enabled for folks that want to view this data.  I would also
argue that sysfs is there to model various aspects of system topology
and a clk tree certainly fits the bill.

If others also agree that it should reside only in debugfs then I'll
move it there for V4.

Thanks,
Mike
