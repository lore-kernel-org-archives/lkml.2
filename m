Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759411Ab1IIQQJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 12:16:09 -0400
Received: from mail-gw0-f42.google.com ([74.125.83.42]:40642 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759386Ab1IIQQG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 12:16:06 -0400
MIME-Version: 1.0
In-Reply-To: <4E6A075C.1050102@suse.cz>
References: <1313800642-32418-1-git-send-email-lacombar@gmail.com>
	<alpine.LFD.2.00.1109071437400.20358@xanadu.home>
	<CACqU3MVF8XSdKi0PeZF5SFaH9i2HPqCjkMqccyb83x4V_1Vs1g@mail.gmail.com>
	<alpine.LFD.2.00.1109071554480.20358@xanadu.home>
	<CACqU3MXcksYxdV_=OR40fPeZzu1ygr-Qs79TV6kfn0DpbXhjuA@mail.gmail.com>
	<alpine.LFD.2.00.1109081617440.20358@xanadu.home>
	<CACqU3MV0PW=Cp3Px2Jjs3SSOBbQSSA7P=a1RNy4x9jKEB-VEiA@mail.gmail.com>
	<4E6A075C.1050102@suse.cz>
Date: Fri, 9 Sep 2011 12:16:03 -0400
Message-ID: <CACqU3MVoQ_hkvEoOkyAd2Ceg9xt4M-=up-avzE2yDqp6ND5suw@mail.gmail.com>
Subject: Re: [RFC] Kbuild: allow code re-use across different directories
From: Arnaud Lacombe <lacombar@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Nicolas Pitre <nico@fluxnic.net>, linux-kbuild@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Sep 9, 2011 at 8:32 AM, Michal Marek <mmarek@suse.cz> wrote:
> On 9.9.2011 03:22, Arnaud Lacombe wrote:
>> Hi,
>>
>> On Thu, Sep 8, 2011 at 4:33 PM, Nicolas Pitre <nico@fluxnic.net> wrote:
>>> On Thu, 8 Sep 2011, Arnaud Lacombe wrote:
>>>
>>>> you missed:
>>>>
>>>>  # Make sure files are removed during clean
>>>> -extra-y       += piggy.gzip piggy.lzo piggy.lzma lib1funcs.S
>>>> +extra-y       += piggy.gzip piggy.lzo piggy.lzma
>>>>
>>>> This confused make.
>>>
>>> Well... that was suttle.
>>>
>> he, welcome to make(1) world :)
>>
>>> So yes, your patch may certainly be useful to a couple cases, and it
>>> works fine for this lib1func.S.
>>>
>>> It doesn't help me much in the following situation though.  What I
>>> actually want to achieve is to compile arch/arm/boot/compressed/fdt_rw.o
>>> from scripts/dtc/libfdt/fdt_rw.c, however I want it to include my local
>>> version of libfdt_env.h rather than scripts/dtc/libfdt/libfdt_env.h.  I
>>> still haven't found a way to convince gcc to do that.
>>>
>> The only choice you have in gcc, is to use -I-, to construct:
>>
>>  $(CROSS_COMPILE)gcc -I$(srctree)/arch/arm/boot/compressed -I- [...]
>>
>> however, it's been marked as deprecated, but still usable as of today
>> snapshot of 4.7.0. Its replacement, -iquote, do not provide this
>> functionnality, that is to override the source file origin directory
>> as search directory for #include "...".
>
> Or you modify libfdt to support -DLIBFDT_ENV=libfdt_arm.h or similar.
>
If dtc has to be modified, let's just get rid of that #include "..."
in favor of #include <...>. We will gain full control of search path,
and it will be cleaner than this awful LIBFTD_ENV construct.

 - Arnaud

> Michal
>
