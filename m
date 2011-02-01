Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858Ab1BANV4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 08:21:56 -0500
Received: from www.tglx.de ([62.245.132.106]:39754 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753088Ab1BANVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 08:21:55 -0500
Message-ID: <4D4808D2.3080701@linutronix.de>
Date: Tue, 01 Feb 2011 14:21:22 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Daniel Drake <dsd@laptop.org>
CC: Andres Salomon <dilinger@queued.net>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        sodaville@linutronix.de, x86@kernel.org, dirk.brandewie@gmail.com
Subject: Re: [PATCH v2 01/15] x86/e820: remove conditional early mapping in
 parse_e820_ext
References: <1292600033-12271-1-git-send-email-bigeasy@linutronix.de>	<1292600033-12271-2-git-send-email-bigeasy@linutronix.de>	<20101230083745.GC11721@angua.secretlab.ca>	<20110104130839.GA21359@www.tglx.de>	<20110114081446.GC21832@angua.secretlab.ca>	<20110114105709.GA7562@www.tglx.de>	<20110114134345.712e2e29@queued.net> <AANLkTimyrGkqtjo99+aV+N4KcrC2_3PprpRD2tRo_NtC@mail.gmail.com>
In-Reply-To: <AANLkTimyrGkqtjo99+aV+N4KcrC2_3PprpRD2tRo_NtC@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Drake wrote:
> Hi,
Hi,

> Context: https://patchwork.kernel.org/patch/450681/
> 
> This patch will indeed cause problems for OLPC. Thanks for bringing it
> to our attention.
> 
> On OLPC, the device tree is not used as a source of devices like on
> other platforms, it is simply used to present information to the
> kernel and userspace (in read-only fashion).
> 
> If I understand it correctly, the above patch is saying: if we have a
> device tree, don't add the standard x86 RTC device.
Yes.

> However, what we need it to say is: if we have a device tree *and* the
> device tree is being used as a source of devices, don't add the
> standard x86 RTC device.
> 
> Therefore in the OLPC case, this particular bail-out condition will
> never be met, because the device tree is not being used as a source of
> devices.
So it is not case now. Will it ever be?

> 
> Does that make sense?

I don't quite get how or what for do you use the device tree. Could you 
please answer me the following questions:
- is the variable allnodes NULL in your case?
- variable initial_boot_params should be NULL in your case, right?
- how should I checked for "device tree is being used as a source of
   devices"? The nodes on in the device tree are not probed unless one
   calls of_platform_bus_probe() with a few ids. However I do this now
   unconditionally which is not a problem unless you have a device tree ...

> Thanks,
> Daniel

Sebastian
