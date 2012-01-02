Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590Ab2ABAYu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 19:24:50 -0500
Received: from static-87-79-237-121.netcologne.de ([87.79.237.121]:27785 "EHLO
	herc.mirbsd.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab2ABAYr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 19:24:47 -0500
Date: Mon, 2 Jan 2012 00:19:44 +0000 (UTC)
From: Thorsten Glaser <tg@mirbsd.de>
X-X-Sender: tg@herc.mirbsd.org
To: Jonathan Nieder <jrnieder@gmail.com>
cc: Nicholas Bellinger <nab@linux-iscsi.org>, Greg Ungerer <gerg@uclinux.org>,
        linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: Re: [m68k] in modpost: "strlen" [iscsi_target_mod.ko] undefined!
 (and others)
In-Reply-To: <20120102001014.GD25837@elie.hsd1.il.comcast.net>
Message-ID: <Pine.BSM.4.64L.1201020016440.20109@herc.mirbsd.org>
References: <20111116181424.14920.7730.reportbug@ara5.mirbsd.org>
 <Pine.BSM.4.64L.1111301751500.12725@herc.mirbsd.org>
 <CAMuHMdW8t8Q7OqxJM602iLG4aSv1KMTY-fhiGS7hyy8xBReh1A@mail.gmail.com>
 <Pine.BSM.4.64L.1112181741430.856@herc.mirbsd.org>
 <Pine.BSM.4.64L.1112181929380.856@herc.mirbsd.org>
 <Pine.BSM.4.64L.1201012310590.20109@herc.mirbsd.org>
 <20120101233931.GA25837@elie.hsd1.il.comcast.net>
 <Pine.BSM.4.64L.1201012342490.20109@herc.mirbsd.org>
 <20120102001014.GD25837@elie.hsd1.il.comcast.net>
X-Message-Flag: Your mailer is broken. Get an update at http://www.washington.edu/pine/getpine/pcpine.html for free.
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Nieder dixit:

>Makefile instead of arch/m68k/Makefile.  If others agree, some patches
>for the x86 string functions to get the optimizations back could
>follow, leaving everyone happy.
[…]
>    Even with -ffreestanding, it's still possilble to explicitely use a gcc
>    builtin if desired.

Just call them, like this:

tg@zigo:~/Xl/linux-2.6-3.2~rc7 $ fgrep -A 3 "define strcpy" arch/m68k/include/asm/string.h
#define strcpy(d, s)    (__builtin_constant_p(s) &&     \
                         __builtin_strlen(s) <= 32 ?    \
                         __builtin_strcpy(d, s) :       \
                         __kernel_strcpy(d, s))

Of course, the parameters when to call which may differ.
(The choice about being a hosted environment is not just
about having libc-like functions available.)

bye,
//mirabilos
-- 
Solange man keine schmutzigen Tricks macht, und ich meine *wirklich*
schmutzige Tricks, wie bei einer doppelt verketteten Liste beide
Pointer XORen und in nur einem Word speichern, funktioniert Boehm ganz
hervorragend.		-- Andreas Bogk über boehm-gc in d.a.s.r
