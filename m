Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261Ab1F0Cda (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 22:33:30 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57757 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755999Ab1F0CcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 22:32:18 -0400
MIME-Version: 1.0
In-Reply-To: <20110626144742.2f6ae3ef@infradead.org>
References: <BANLkTimHRRJ0g6VejfR8o-a5i42Puag0XQ@mail.gmail.com> <20110626144742.2f6ae3ef@infradead.org>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Sun, 26 Jun 2011 22:31:56 -0400
Message-ID: <BANLkTi=OYC8A-sZanTgwDZmz1aC16s4aTQ@mail.gmail.com>
Subject: Re: CPU Instantaneous Power Consumption
To: Arjan van de Ven <arjan@infradead.org>
Cc: pradeep hettiarachchi <pradeepmh@wayne.edu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 26, 2011 at 17:47, Arjan van de Ven <arjan@infradead.org> wrote:
> On Mon, 20 Jun 2011 22:15:47 -0400
> pradeep hettiarachchi <pradeepmh@wayne.edu> wrote:
>
>> Hi,
>>
>> I am a PhD student and doing a research which involves
>> control-theoretic real-time process/job scheduling. Here is my
>> question:
>>
>> I need to calculate the power consumption of a single or two CPU cores
>> and equivalent Thermal Dissipation accurately. I did not find any
>> supporting material from Intel to find the instantaneous power
>> consumption (and thermal dissipation) of the CPU. Therefore I am
>> trying some alternative path; I measure the CPU regulator input
>> current (using a very small shunt resister in series with 4 pin CPU
>> ATX connector). Also, assuming that the CPU voltage regulator operates
>> at 12 V rated, I could calculate the input power to the CPU regulator.
>>
>> However without knowing the following I cannot complete my power
>> calculation:
>>
> there isn't one.
> TDP is the power the CPU will use under a "power virus" like workload,
> eg this is the number that a system vendor is expected to be able to
> cool.
>
> What you actually use on a real life workload is less than that... how
> much less "depends"

The Thermal Design Power is very specifically not a chip-specific
parameter but a whole-system or whole-component design metric,
including the CPU and GPU as well as any chipset controllers, add-in
cards, etc.

For example, in a modern Intel laptop, the CPU may well have minimum
and maximum TDP numbers, but the processor boots up in low-power
mode and relies on the BIOS to program various secret model-specific
registers and other tunables to tell the CPU exactly how much power it
can use and how hot it can get, based on the "whole system" TDP.
Those power numbers *also* account for how hot the ethernet chipset
and SATA controller might get under maximum load.

Thermal Design Power also allows for short-term thermal overload;
something like Intel's "TurboBoost" where you can run the CPU very
cool at idle for 20 minutes (IE: writing code in "vim") and then turn the
frequency/power up above the steady-state max for 15-30 seconds of
high CPU usage (IE: compiling code), and then put it back into a lower
frequency state before it gets too hot.

It's even more complex when you consider shared cooling between
the CPU and GPU; if your GPU is at steady-state max frequency and
power then your CPU must be limited to ~60%, or vice versa.

Cheers,
Kyle Moffett
