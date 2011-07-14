Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab1GNLve (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 07:51:34 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35133 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117Ab1GNLvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 07:51:33 -0400
MIME-Version: 1.0
In-Reply-To: <4E1ECE3B.10308@broadcom.com>
References: <4E1ECE3B.10308@broadcom.com>
From: Jonas Gorski <jonas.gorski@gmail.com>
Date: Thu, 14 Jul 2011 13:51:11 +0200
Message-ID: <CAOiHx=kznEFL1BELeg2psg9yw+=-A5reunG0VYTu89DGKwrSzA@mail.gmail.com>
Subject: Re: Status of MIPS on 3.0.0-rc6 kernel
To: Roland Vossen <rvossen@broadcom.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mips@linux-mips.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 July 2011 13:08, Roland Vossen <rvossen@broadcom.com> wrote:
> Hi Jonas,
>
> The (defconfig) mips kernel fails to build, with the error message:
>
> arch/mips/kernel/i8259.c:240: error: unknown field 'resume' specified in
> initializer
>
> I read on https://lkml.org/lkml/2011/6/1/37 that Geert Uytterhoeven
> encountered the same issue on June 1st.
>
> Do you know if there are still known problems building a 3.0.0-rc6 MIPS
> kernel ?

You probably could have found that out yourself quite easily [1] ;-)

This is actually still a problem in rc7. Commit
2e711c04dbbf7a7732a3f7073b1fc285d12b369d ("PM: Remove sysdev suspend,
resume and shutdown operations") broke it.
It's probably easily fixable by just removing the offending
.resume/.shutdown lines (and their referenced functions), but I don't
know the code (or PM) enough to know if some replacement is missing
there.


Regards,
Jonas

[1] <https://lkml.org/lkml/2011/7/7/267>
