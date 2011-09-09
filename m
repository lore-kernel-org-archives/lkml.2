Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028Ab1IIBWL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 21:22:11 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:56250 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757512Ab1IIBWI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 21:22:08 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1109081617440.20358@xanadu.home>
References: <1313800642-32418-1-git-send-email-lacombar@gmail.com>
	<alpine.LFD.2.00.1109071437400.20358@xanadu.home>
	<CACqU3MVF8XSdKi0PeZF5SFaH9i2HPqCjkMqccyb83x4V_1Vs1g@mail.gmail.com>
	<alpine.LFD.2.00.1109071554480.20358@xanadu.home>
	<CACqU3MXcksYxdV_=OR40fPeZzu1ygr-Qs79TV6kfn0DpbXhjuA@mail.gmail.com>
	<alpine.LFD.2.00.1109081617440.20358@xanadu.home>
Date: Thu, 8 Sep 2011 21:22:05 -0400
Message-ID: <CACqU3MV0PW=Cp3Px2Jjs3SSOBbQSSA7P=a1RNy4x9jKEB-VEiA@mail.gmail.com>
Subject: Re: [RFC] Kbuild: allow code re-use across different directories
From: Arnaud Lacombe <lacombar@gmail.com>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Sep 8, 2011 at 4:33 PM, Nicolas Pitre <nico@fluxnic.net> wrote:
> On Thu, 8 Sep 2011, Arnaud Lacombe wrote:
>
>> you missed:
>>
>>  # Make sure files are removed during clean
>> -extra-y       += piggy.gzip piggy.lzo piggy.lzma lib1funcs.S
>> +extra-y       += piggy.gzip piggy.lzo piggy.lzma
>>
>> This confused make.
>
> Well... that was suttle.
>
he, welcome to make(1) world :)

> So yes, your patch may certainly be useful to a couple cases, and it
> works fine for this lib1func.S.
>
> It doesn't help me much in the following situation though.  What I
> actually want to achieve is to compile arch/arm/boot/compressed/fdt_rw.o
> from scripts/dtc/libfdt/fdt_rw.c, however I want it to include my local
> version of libfdt_env.h rather than scripts/dtc/libfdt/libfdt_env.h.  I
> still haven't found a way to convince gcc to do that.
>
The only choice you have in gcc, is to use -I-, to construct:

 $(CROSS_COMPILE)gcc -I$(srctree)/arch/arm/boot/compressed -I- [...]

however, it's been marked as deprecated, but still usable as of today
snapshot of 4.7.0. Its replacement, -iquote, do not provide this
functionnality, that is to override the source file origin directory
as search directory for #include "...".

 - Arnaud


> Nicolas
>
