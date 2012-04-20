Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab2DTM2v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 08:28:51 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35470 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114Ab2DTM2u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 08:28:50 -0400
MIME-Version: 1.0
In-Reply-To: <20347.61964.860903.97474@ipc1.ka-ro>
References: <20347.61964.860903.97474@ipc1.ka-ro>
From: Rabin Vincent <rabin@rab.in>
Date: Fri, 20 Apr 2012 17:58:09 +0530
X-Google-Sender-Auth: COv5qO9CA9U5EHgSfa1RvW6VthA
Message-ID: <CAH+eYFA9+MpL4Ls8viiyvkxv56Q0=33pwNR8B_VW_6DY83t1tA@mail.gmail.com>
Subject: Re: BUG: sleeping function called from invalid context at /usr/local/src/linux-3.4-rc1/include/linux/freezer.h:46
To: =?ISO-8859-1?Q?Lothar_Wa=DFmann?= <LW@karo-electronics.de>
Cc: linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 4, 2012 at 12:32, Lothar Waﬂmann <LW@karo-electronics.de> wrote:
> commit a0acae0e added a might_sleep() to try_to_freeze() in
> include/linux/freezer.h.
> This leads to the following BUG message each time a process is started
> when compiled with CONFIG_DEBUG_ATOMIC_SLEEP=y
>
> |BUG: sleeping function called from invalid context at /usr/local/src/linux-3.4-rc1/include/linux/freezer.h:46
> |in_atomic(): 0, irqs_disabled(): 128, pid: 619, name: rc

This is on ARM, right?  In this old thread, there is a patch from
Russell which fixes it, but it seems to have not been applied:

https://lkml.org/lkml/2011/8/25/231
