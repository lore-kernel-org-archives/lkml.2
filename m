Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478Ab2AAXsr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 18:48:47 -0500
Received: from static-87-79-237-121.netcologne.de ([87.79.237.121]:11896 "EHLO
	herc.mirbsd.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117Ab2AAXsp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 18:48:45 -0500
Date: Sun, 1 Jan 2012 23:45:51 +0000 (UTC)
From: Thorsten Glaser <tg@mirbsd.de>
X-X-Sender: tg@herc.mirbsd.org
To: Jonathan Nieder <jrnieder@gmail.com>
cc: Nicholas Bellinger <nab@linux-iscsi.org>, Greg Ungerer <gerg@uclinux.org>,
        linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: Re: [m68k] in modpost: "strlen" [iscsi_target_mod.ko] undefined!
 (and others)
In-Reply-To: <20120101233931.GA25837@elie.hsd1.il.comcast.net>
Message-ID: <Pine.BSM.4.64L.1201012342490.20109@herc.mirbsd.org>
References: <20111116181424.14920.7730.reportbug@ara5.mirbsd.org>
 <Pine.BSM.4.64L.1111301751500.12725@herc.mirbsd.org>
 <CAMuHMdW8t8Q7OqxJM602iLG4aSv1KMTY-fhiGS7hyy8xBReh1A@mail.gmail.com>
 <Pine.BSM.4.64L.1112181741430.856@herc.mirbsd.org>
 <Pine.BSM.4.64L.1112181929380.856@herc.mirbsd.org>
 <Pine.BSM.4.64L.1201012310590.20109@herc.mirbsd.org>
 <20120101233931.GA25837@elie.hsd1.il.comcast.net>
X-Message-Flag: Your mailer is broken. Get an update at http://www.washington.edu/pine/getpine/pcpine.html for free.
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Nieder dixit:

>Could you suggest a patch to arch/m68k/Makefile to do that?

No, I patched it in debian/config/m68k/defines instead.

I’d rather know why upstream doesn’t use -ffreestanding on
_all_ architectures. A kernel is _not_ a hosted environment,
and GCC is right to bring in problems like this.

>    Then drop -ffreestanding from the main Makefile because it isn't
>    needed anymore and implies -fno-builtin, which is wrong now.

This is wrong, GCC builtins are only valid on hosted platforms,
not on freestanding platforms. (Nobody prevents GCC from using
a memcpy builtin that uses, say, SSE instructions, which must
not be used inside kernel code, for an example on a better-known
architecture.) A kernel must always be compiled freestanding,
as do bootloaders. At least since the advent of gcc 3.[34].

bye,
//mirabilos
-- 
“It is inappropriate to require that a time represented as
 seconds since the Epoch precisely represent the number of
 seconds between the referenced time and the Epoch.”
	-- IEEE Std 1003.1b-1993 (POSIX) Section B.2.2.2
