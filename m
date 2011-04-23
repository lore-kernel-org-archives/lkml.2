Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075Ab1DWBec (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 21:34:32 -0400
Received: from snt0-omc3-s45.snt0.hotmail.com ([65.54.51.82]:46649 "EHLO
	snt0-omc3-s45.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757143Ab1DWBea convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 21:34:30 -0400
X-Greylist: delayed 370 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Apr 2011 21:34:30 EDT
Message-ID: <SNT125-W638277FA9F3B49B316DC9FC3940@phx.gbl>
X-Originating-IP: [50.47.160.44]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: <chris@csamuel.org>, <alan@lxorguk.ukuu.org.uk>
CC: <hpa@zytor.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: RE: 2.6.38.3 and 2.6.39-rc4 hangs after "Booting the kernel" on
 quad Pentium Pro system
Date: Fri, 22 Apr 2011 18:28:20 -0700
Importance: Normal
In-Reply-To: <201104231016.23579.chris@csamuel.org>
References: <201104222333.25546.chris@csamuel.org>
 <20110422173422.46134f20@lxorguk.ukuu.org.uk>,<201104231016.23579.chris@csamuel.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 23 Apr 2011 01:28:20.0443 (UTC) FILETIME=[BAC82AB0:01CC0155]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Sigh, that's just reminded me that a couple of years ago I
> had a private discussion with H. Peter Anvin about 2.6.25
> panic'ing on boot with:
>
> initrd extends beyond end of memory (0x0ffef173 > ox01000000)
>
> He gave me a modified syslinux to dump out memory information
> and it reported:
>
> INT 15h = f000:f859 DOS RAM: 638K (0x9f800) INT 12h: 638K (0x9f800)
> INT 15 88: 0x3c00 (15360K) INT 15 E801: 0x0000 (0K) 0x0000 (0K)
>
> He responded with:
>
> # Right... you have a system dependent on E801, and somehow E801
> # returns crap.
> #
> # I'm going to cook up a modified meminfo.c32 for you and see if
> # we can't track this down.

This is a stupid BIOS, but do you know if it used E820 in  the old kernel?
I wonder if this has something to do with the changes made to support ACPI 3.0 changes to E820?
This would be easy to diagnose with DOS DEBUG with no himem.sys loaded.

Yuhong Bao
 		 	   		  