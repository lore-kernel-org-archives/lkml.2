Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab2BPRo4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 12:44:56 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:49675 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab2BPRoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 12:44:55 -0500
Date: Thu, 16 Feb 2012 12:44:52 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, tony@atomide.com,
        s.hauer@pengutronix.de, magnus.damm@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: remove memmove from boot/compressed/string.c
In-Reply-To: <1329404057-26346-2-git-send-email-michael.opdenacker@free-electrons.com>
Message-ID: <alpine.LFD.2.02.1202161226580.24536@xanadu.home>
References: <1329404057-26346-1-git-send-email-michael.opdenacker@free-electrons.com> <1329404057-26346-2-git-send-email-michael.opdenacker@free-electrons.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Feb 2012, Michael Opdenacker wrote:

> This patch removes the memmove function from boot/compressed/string.c

... breaking CONFIG_ARM_ATAG_DTB_COMPAT.

> - This definition conflicts with the one in lib/decompress_unxz.c
>   This change is required to support xz compression on ARM.

No, it's the decompress_unxz.c code which is wrong.

To work around it, just do:

#define memmove memmove

before including lib/decompress_unxz.c.

> - memmove is not used in any of the other decompressors
>   in lib/decompress_*.c

Doesn't mean it isn't used at all.

Here's a trick.  Next time you can do:

	git blame arch/arm/boot/compressed/string.c

That will list all the file content, annotated with references to the 
commits that brought them there.

Looking for memmove() you'll see that commit df4879fa260 is responsible 
for it. Its commit log says:

    ARM: zImage: gather some string functions into string.c

    This is a small subset of string functions needed by commits to 
    come.

OK, doing a full 'git log' and searching for that commit, just to back 
up to the next one you'll see:

    ARM: zImage: allow supplementing appended DTB with traditional ATAG  data

That explains why memmove() is required, and by which code.


Nicolas
