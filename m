Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab1HRQhy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 12:37:54 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:52010 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455Ab1HRQhx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 12:37:53 -0400
MIME-Version: 1.0
In-Reply-To: <1313654457.2905.10.camel@epip-laptop>
References: <1313384834-24433-1-git-send-email-lacombar@gmail.com>
	<1313384834-24433-4-git-send-email-lacombar@gmail.com>
	<CACqU3MWTEFy+XV7WH=FEP2hTvBu8VCgcYj-HCcVnSjKxZBQeeA@mail.gmail.com>
	<1313654457.2905.10.camel@epip-laptop>
Date: Thu, 18 Aug 2011 12:37:52 -0400
Message-ID: <CACqU3MUVBQ67vKP-41jAy7JGrW1-m+HR8mrt18Yke6ZrjYLx-w@mail.gmail.com>
Subject: Re: [PATCH 03/11] arch/unicore32: do not use EXTRA_AFLAGS or EXTRA_CFLAGS
From: Arnaud Lacombe <lacombar@gmail.com>
To: gxt@mprc.pku.edu.cn
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Aug 18, 2011 at 4:00 AM, Guan Xuetao <gxt@mprc.pku.edu.cn> wrote:
> It looks good for me.
>
> Acked-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
>
> Do I need to push the patch into unicore32 repo?
>
All patches in the series are fully independent from one another, so
yes, you can just pick it in the unicore32 tree.

Thanks,
 - Arnaud

> Thanks & Regards
>
> Guan Xuetao
>
>
> On Mon, 2011-08-15 at 01:13 -0400, Arnaud Lacombe wrote:
>> Hi,
>>
>> On Mon, Aug 15, 2011 at 1:07 AM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>> > Usage of these flags has been deprecated for nearly 4 years by:
>> >
>> >    commit f77bf01425b11947eeb3b5b54685212c302741b8
>> >    Author: Sam Ravnborg <sam@neptun.(none)>
>> >    Date:   Mon Oct 15 22:25:06 2007 +0200
>> >
>> >        kbuild: introduce ccflags-y, asflags-y and ldflags-y
>> >
>> > Moreover, these flags (at least EXTRA_CFLAGS) have been documented for command
>> > line use. By default, gmake(1) do not override command line setting, so this is
>> > likely to result in build failure or unexpected behavior.
>> >
>> > Replace their usage by Kbuild's `{as,cc,ld}flags-y'.
>> >
>> > Cc: Sam Ravnborg <sam@ravnborg.org>
>> > Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
>> Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
>>
>>  - Arnaud
>> > ---
>> >  arch/unicore32/boot/compressed/Makefile |    4 ++--
>> >  1 files changed, 2 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/arch/unicore32/boot/compressed/Makefile b/arch/unicore32/boot/compressed/Makefile
>> > index b0954a2..950a9af 100644
>> > --- a/arch/unicore32/boot/compressed/Makefile
>> > +++ b/arch/unicore32/boot/compressed/Makefile
>> > @@ -10,8 +10,8 @@
>> >  # Copyright (C) 2001~2010 GUAN Xue-tao
>> >  #
>> >
>> > -EXTRA_CFLAGS   := -fpic -fno-builtin
>> > -EXTRA_AFLAGS   := -Wa,-march=all
>> > +ccflags-y      := -fpic -fno-builtin
>> > +asflags-y      := -Wa,-march=all
>> >
>> >  OBJS           := misc.o
>> >
>> > --
>> > 1.7.6.153.g78432
>> >
>> >
>
>
>
