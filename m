Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366Ab2INM7e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 08:59:34 -0400
Received: from ares07.inai.de ([5.9.24.206]:51104 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736Ab2INM7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 08:59:32 -0400
Date: Fri, 14 Sep 2012 14:59:28 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-kernel@vger.kernel.org,
        Jim Rees <rees@umich.edu>
Subject: Re: [PATCH] strings: helper for maximum decimal encoding of an
 unsigned integer
In-Reply-To: <1347614276.26071.15.camel@thorin>
Message-ID: <alpine.LNX.2.01.1209141456290.18169@frira.zrqbmnf.qr>
References: <20120821212910.GD18637@fieldses.org>  <alpine.LNX.2.01.1209100803060.22738@frira.zrqbmnf.qr> <1347614276.26071.15.camel@thorin>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2012-09-14 11:17, Bernd Petrovitsch wrote:
>Shouldn't that have been
>----  snip ----
>#define base10len(i) ((const int[]){1,3,5,8,10,13,15,17,20}[sizeof(i)])
>----  snip ----
Yeah.

>A pure K&R-C version would use a string:
>#define base10len(i) "\0x1\0x3\0x5\0x8\0x0A\0x0D\0x0F\0x11\0x14"[sizeof(i)]
>(if I converted them properly into hexadecimal)
The syntax is \x01\x03\x05...

>and that gives a "char"
>which is happily promoted to whatever one needs in that place.

So just convert it; there are no less than two ways to do so
 ((const unsigned char *)"\x01\x03...")[sizeof(i)]
 (boatfloating_t)("\x01\x03..."[sizeof(i)])
