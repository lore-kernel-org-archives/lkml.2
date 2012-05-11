Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039Ab2EKIfj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 04:35:39 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:54686 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab2EKIfa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 04:35:30 -0400
MIME-Version: 1.0
In-Reply-To: <4FACCC79.5000805@ti.com>
References: <201205092340.26561.rjw@sisk.pl>
	<201205092343.11050.rjw@sisk.pl>
	<4FAB9412.5030102@ti.com>
	<201205102041.42473.rjw@sisk.pl>
	<4FACCC79.5000805@ti.com>
Date: Fri, 11 May 2012 17:35:29 +0900
Message-ID: <CANqRtoR04Xs9tk_bmkJwjOwUb3PiZuHUDyZEAnM4r4FXBU61vA@mail.gmail.com>
Subject: Re: [RFC][PATCH 2/2] PM / Domains: Add preliminary cpuidle support
From: Magnus Damm <magnus.damm@gmail.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Colin Cross <ccross@android.com>, Kevin Hilman <khilman@ti.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Santosh,

On Fri, May 11, 2012 at 5:23 PM, Santosh Shilimkar
<santosh.shilimkar@ti.com> wrote:
> On Friday 11 May 2012 12:11 AM, Rafael J. Wysocki wrote:
>> On Thursday, May 10, 2012, Santosh Shilimkar wrote:
>>> Rafael,
>>>
>>> On Thursday 10 May 2012 03:13 AM, Rafael J. Wysocki wrote:
>>>> From: Rafael J. Wysocki <rjw@sisk.pl>
>>>>
>>>> On some systems there are CPU cores located in the same power
>>>> domains as I/O devices.  Then, power can only be removed from the
>>>> domain if all I/O devices in it are not in use and the CPU core
>>>> is idle.  Add preliminary support for that to the generic PM domains
>>>> framework.
>>>>
>>> I am just curious to know, what kind of IO devices, you are
>>> talking here?
>>
>> Nothing specific, really.  It can be any kind of I/O devices that happen
>> to be in the same power domain.  This includes USB, SDHI, MMCIF controllers
>> on the SoC I have in mind in particular.
>>
> OK.
> These are more of generic devices and actually not related to CPU/CPU
> clusters as such.
>
>>> And also how those devices linked with CPU low power
>>> states apart from being part of same power domain. And is it
>>> the power domain or more of voltage domain, we are talking here.
>>
>> Depending on the definitions I guess.  How do you define a power domain and
>> a voltage domain?
>>
>
> A voltage domain can be a section of the device supplied by a dedicated
> voltage rail. A voltage domain can have many power-domains like
> CPU cluster domain, Interconnect domain, peripheral domains.
> And each power domain then can have many sub-modules like UART, SPI,
> USB etc

There are no software controllable voltage domains on the
sh7372/Mackerel SoC/board that Rafael is using. The SoC does however
have multiple hierarchical power domains, and in the case when we want
to have transparent runtime power management of the root power domain
then we will have to take both I/O devices and CPU cores into
consideration. I suppose exactly how to do that is up for discussion,
but CPUIdle is certainly a natural step in some direction - this since
the CPU-only power domains are already managed by CPUIdle.

Thanks,

/ magnus
