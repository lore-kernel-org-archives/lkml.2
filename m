Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453Ab2AAXjm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 18:39:42 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45309 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab2AAXjj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 18:39:39 -0500
Date: Sun, 1 Jan 2012 17:39:31 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: Thorsten Glaser <tg@mirbsd.de>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>, Greg Ungerer <gerg@uclinux.org>,
        linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: Re: [m68k] in modpost: "strlen" [iscsi_target_mod.ko] undefined!
 (and others)
Message-ID: <20120101233931.GA25837@elie.hsd1.il.comcast.net>
References: <20111116181424.14920.7730.reportbug@ara5.mirbsd.org>
 <Pine.BSM.4.64L.1111301751500.12725@herc.mirbsd.org>
 <CAMuHMdW8t8Q7OqxJM602iLG4aSv1KMTY-fhiGS7hyy8xBReh1A@mail.gmail.com>
 <Pine.BSM.4.64L.1112181741430.856@herc.mirbsd.org>
 <Pine.BSM.4.64L.1112181929380.856@herc.mirbsd.org>
 <Pine.BSM.4.64L.1201012310590.20109@herc.mirbsd.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <Pine.BSM.4.64L.1201012310590.20109@herc.mirbsd.org>
User-Agent: Mutt/1.5.21+51 (9e756d1adb76) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thorsten Glaser wrote[1]:
> Dixi quod…

>> So, please, compile the Linux kernel with -ffreestanding, too.
>
> Just to keep this bugreport in the loop: that fixes the FTBFS error.

Yep, sounds like a reasonable idea, though these calls to
"strncat(buf, str, strlen(str))" in the iscsi driver are still a
little insane.  Could you suggest a patch to arch/m68k/Makefile to do
that?

Thanks,
Jonathan

[1] http://bugs.debian.org/648996

Background:

commit 6edfba1b33c7
Author: Andi Kleen <ak@suse.de>
Date:   Sat Mar 25 16:29:49 2006 +0100

    [PATCH] x86_64: Don't define string functions to builtin

    gcc should handle this anyways, and it causes problems when
    sprintf is turned into strcpy by gcc behind our backs and
    the C fallback version of strcpy is actually defining __builtin_strcpy

    Then drop -ffreestanding from the main Makefile because it isn't
    needed anymore and implies -fno-builtin, which is wrong now.
    (it was only added for x86-64, so dropping it should be safe)
