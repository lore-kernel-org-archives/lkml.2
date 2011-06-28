Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646Ab1F1FbS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 01:31:18 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:37566 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754953Ab1F1F3f convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 01:29:35 -0400
MIME-Version: 1.0
In-Reply-To: <87ei2f9bja.fsf@ti.com>
References: <1308862894-13802-1-git-send-email-jaswinder.singh@linaro.org>
	<BANLkTikFFUREhKyPaZrhHZje0KeaA3ef8Q@mail.gmail.com>
	<87ei2f9bja.fsf@ti.com>
Date: Tue, 28 Jun 2011 10:59:30 +0530
Message-ID: <BANLkTimeOq=UUkHZ0rZgAW8dz0zggHcp0A@mail.gmail.com>
Subject: Re: [PATCH] mfd: omap: Restore TLL initialization
From: "Munegowda, Keshava" <keshava_mgowda@ti.com>
To: Kevin Hilman <khilman@ti.com>
Cc: Jassi Brar <jassisinghbrar@gmail.com>, linux-kernel@vger.kernel.org,
        ti@lists.linaro.org, parthab@india.ti.com, sameo@linux.intel.com,
        gadiyar@ti.com, balbi@ti.com, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, Jassi Brar <jaswinder.singh@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 3:34 AM, Kevin Hilman <khilman@ti.com> wrote:
> "Munegowda, Keshava" <keshava_mgowda@ti.com> writes:
>
>> On Fri, Jun 24, 2011 at 2:31 AM, Jassi Brar <jassisinghbrar@gmail.com> wrote:
>>> The commit
>>>  7e6502d577106fb5b202bbaac64c5f1b065 'mfd: Add omap-usbhs runtime PM support'
>>> besides moving to RPM, removes necessary TLL initialization as well.
>>>
>>> Restore the TLL initialization, without which device detection fails.
>>>
>>> Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
>
> [...]
>
>> if you move to RPM, you should'tn access these configuration/reset
>> registers in your driver.
>
> Yes, but Jaswinder's changelog clearly shows that the runtime PM (and
> thus hwmod) init is not doing the equivalent of what was removed from
> the driver.
>
> A hunch after a quick glance is that the driver changes are only doing
> runtime PM calls on the UHH device and not the TTL device.  In fact,
> the patch that builds the USB host omap_device[1] doesn't even build one.
>
>> moreover, the patch 'mfd: Add omap-usbhs runtime PM support' is
>> already reverted.
>
> It is reverted for this merge window, but will be added back for the
> next window, so Jaswinder's problem still needs to be fixed the right way.
>
> Please rework the USB host runtime PM conversion so that *all* the IP
> blocks are managed by runtime PM and the driver is doing runtime PM
> calls for all the devices used.
>
> Kevin
> [1] http://marc.info/?l=linux-omap&m=130693494126396&w=2
>

Ya, the changes are going on ; I will post the patches soon.
keshava
