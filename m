Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab0KIKXb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 05:23:31 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47368 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527Ab0KIKXa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 05:23:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sShJAw57y2aQlmZc7cnkUfK87QcqNQxd9Syt7NzIwKjPIMviPUNDBKATObrWyhb0gW
         fEirE+s1qWpkzGbYBoa9hD9kF72ja1duN2iwBxZw3VG+fVeoo4kDz4BJXkvfxynLf8wt
         ujcG4dnV14EwrlNlxQ/ZC0fvK9zHBHCwQNmko=
MIME-Version: 1.0
In-Reply-To: <201011080947.37522.arnd@arndb.de>
References: <1289147348-31969-1-git-send-email-alchark@gmail.com>
	<1289147348-31969-6-git-send-email-alchark@gmail.com>
	<201011080947.37522.arnd@arndb.de>
Date: Tue, 9 Nov 2010 13:23:29 +0300
Message-ID: <AANLkTikC9j2U3VUbEmfgH555Zq1sSO-hVtpg_k7hLFPS@mail.gmail.com>
Subject: Re: [PATCH 6/6 v2] ARM: Add support for the display controllers in
 VT8500 and WM8505
From: Alexey Charkov <alchark@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-arm-kernel@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Paul Mundt <lethal@linux-sh.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/8 Arnd Bergmann <arnd@arndb.de>:
> On Sunday 07 November 2010, Alexey Charkov wrote:
>>  drivers/video/Kconfig         |   26 +++
>>  drivers/video/Makefile        |    3 +
>>  drivers/video/vt8500lcdfb.c   |  452 +++++++++++++++++++++++++++++++++++++++++
>>  drivers/video/vt8500lcdfb.h   |   34 +++
>>  drivers/video/wm8505fb.c      |  438 +++++++++++++++++++++++++++++++++++++++
>>  drivers/video/wm8505fb_regs.h |   76 +++++++
>>  drivers/video/wmt_ge_rops.c   |  186 +++++++++++++++++
>>  drivers/video/wmt_ge_rops.h   |    5 +
>
> From a very brief look, the two drivers look rather similar. What is the
> reason to have separate drivers instead of just one?
>
> Could you perhaps take the common parts and move them into a third module
> that exports symbols to be used by the two drivers?
>

Quite frankly, I would say that all SoC framebuffer drivers are quite
similar ;-) Register offsets, timing formats, accepted pixel formats,
buffer alignment requirements are all different, so I do not really
believe that there'd be much benefit from introducing another
abstraction level. This is open to debate, of course.

Alexey
