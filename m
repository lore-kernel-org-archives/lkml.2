Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab0IITQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 15:16:53 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47122 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421Ab0IITQv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 15:16:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=D3+d8R0krYMlFMjenNNeE63n+AOrsjqxUvr31oBO/UeCEttI8MGHeJY9YL2najS5Fd
         Kf1Rrjtw5V4a4HFsYrMiu0s14knhE4t5/zrmnoNg7dG7FU1i2a6KOQrKptYC5Qot4Gdb
         t+EPaGbsKB/QvtvpZM3WIgl0o1CluEBJ/iMIM=
MIME-Version: 1.0
In-Reply-To: <1284058127.24986.199.camel@Joe-Laptop>
References: <1284056536.24986.182.camel@Joe-Laptop> <AANLkTimAuA1oYyoaKsFTPEifdDsz9h=EzTB8gKudyAJk@mail.gmail.com>
 <1284058127.24986.199.camel@Joe-Laptop>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 9 Sep 2010 15:16:29 -0400
Message-ID: <AANLkTimzAOvP62VnhpSmKoazKkPc30-YTy09g2eYPGBg@mail.gmail.com>
Subject: Re: [rfc patch] treewide: Convert "static const char <*> foo[] =" to
 "static const char <*> const foo[] ="
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 9, 2010 at 14:48, Joe Perches wrote:
> On Thu, 2010-09-09 at 14:29 -0400, Mike Frysinger wrote:
>> this is going to keep
>> creeping back in with new drivers unless we have something like
>> checkpatch.pl catching it ...
>
> These are added pretty slowly, but both of
>
>        static char foo[] = "bar"
> and
>        static const char *foo[] = {"bar"}
>
> could be warned by checkpatch

i dont think you even need to check the contents.  just match the base:
char foo[]
const char *foo[]

we want to catch these even if it isnt static, and catching the
forward decl would be useful too.

>> where is the actual patch ?
>
> On my computer.  300KB is pretty big to post.
> I'll sent it to you separately.

thanks.  for reviewing/merging, probably be best to split up by
subsystem.  the MTD parts look straight forward (part probe types), so
that'd be one big change.  i'd even include the board changes in that
one commit.

same goes for the ASoC changes (most everything under sound/).  looks
sane, so make one chunk for that and send to the ASoC guys.

your perl hack isnt quite right.  the change to
drivers/mtd/maps/ixp2000.c and intel_vr_nor.c incorrectly ate leading
whitespace.  how about making a coccinelle patch ?  then you could add
it to scripts/coccinelle/ for other people to use in the future, and
hopefully these style changes wouldnt be broken in the process.
-mike
