Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab1LRTsG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 14:48:06 -0500
Received: from static-87-79-237-121.netcologne.de ([87.79.237.121]:8493 "EHLO
	herc.mirbsd.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab1LRTsE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 14:48:04 -0500
X-Greylist: delayed 690 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Dec 2011 14:48:04 EST
Date: Sun, 18 Dec 2011 19:33:02 +0000 (UTC)
From: Thorsten Glaser <tg@debian.org>
X-X-Sender: tg@herc.mirbsd.org
To: linux-kernel@vger.kernel.org
cc: 648996@bugs.debian.org, debian-68k@lists.debian.org,
        Bastian Blank <waldi@debian.org>
Subject: Re: Bug#648996: linux-2.6: FTBFS [m68k] in modpost: "strlen"
 [iscsi_target_mod.ko] undefined! (and others)
In-Reply-To: <Pine.BSM.4.64L.1112181741430.856@herc.mirbsd.org>
Message-ID: <Pine.BSM.4.64L.1112181929380.856@herc.mirbsd.org>
References: <20111116181424.14920.7730.reportbug@ara5.mirbsd.org>
 <Pine.BSM.4.64L.1111301751500.12725@herc.mirbsd.org>
 <CAMuHMdW8t8Q7OqxJM602iLG4aSv1KMTY-fhiGS7hyy8xBReh1A@mail.gmail.com>
 <Pine.BSM.4.64L.1112181741430.856@herc.mirbsd.org>
X-Message-Flag: Your mailer is broken. Get an update at http://www.washington.edu/pine/getpine/pcpine.html for free.
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dixi quod…

>I suspect gcc emitting a call to strFOO for __builtin_strFOO.

And indeed, it does; waldi just pointed me to the fact that the
Linux kernel, despite being a kernel and not a hosted environment,
does not use -ffreestanding in its CFLAGS. No surprise it does
that, then.

When I first upgraded from gcc 2.x to gcc 3.x in MirBSD, the kernel
inherited from OpenBSD had similar issues, and adding -ffreestanding
as should be fixed that.

So, please, compile the Linux kernel with -ffreestanding, too.

bye,
//mirabilos
-- 
In traditional syntax ' is ignored, but in c99 everything between two ' is
handled as character constant.  Therefore you cannot use ' in a preproces-
sing file in c99 mode.	-- Ragge
No faith left in ISO C99, undefined behaviour, etc.
