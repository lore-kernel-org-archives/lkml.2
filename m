Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab0IITvW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 15:51:22 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54468 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab0IITvU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 15:51:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=xKekRDlg6y7TnzMIeR5zCyLF0BKa+9DHyGDKfipFFJi2FtmhWQr16Sq7ScSlsE4mcf
         FOQ1yuvcUEBj2sB35YxZWn27hxcEIusClSDOGt+qzgSdEL/My7yx2/jyxUghfR2+zNuv
         xygfwoe3KkapPIrGiA0aFE05ihetDolWip0H4=
MIME-Version: 1.0
In-Reply-To: <1284061730.24986.238.camel@Joe-Laptop>
References: <1284056536.24986.182.camel@Joe-Laptop> <AANLkTimAuA1oYyoaKsFTPEifdDsz9h=EzTB8gKudyAJk@mail.gmail.com>
 <1284058127.24986.199.camel@Joe-Laptop> <AANLkTimzAOvP62VnhpSmKoazKkPc30-YTy09g2eYPGBg@mail.gmail.com>
 <1284060808.24986.231.camel@Joe-Laptop> <AANLkTikm_ROCEZco0UMX47aD28O0EALh=WYfNwSX=fVa@mail.gmail.com>
 <1284061730.24986.238.camel@Joe-Laptop>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 9 Sep 2010 15:50:59 -0400
Message-ID: <AANLkTinDTkW9oAG_i30YHc_Ox8ZmWU6YcNouKWYrU=Zr@mail.gmail.com>
Subject: Re: [rfc patch] treewide: Convert "static const char <*> foo[] =" to
 "static const char <*> const foo[] ="
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 9, 2010 at 15:48, Joe Perches wrote:
> On Thu, 2010-09-09 at 15:40 -0400, Mike Frysinger wrote:
>> On Thu, Sep 9, 2010 at 15:33, Joe Perches wrote:
>> > On Thu, 2010-09-09 at 15:16 -0400, Mike Frysinger wrote:
>> >> i dont think you even need to check the contents.  just match the base:
>> >> char foo[]
>> >> const char *foo[]
>> >> we want to catch these even if it isnt static, and catching the
>> >> forward decl would be useful too.
>> >
>> > I think that's not so good.
>> > There are times when a default is used but then modified.
>> > For instance:
>> > drivers/staging/comedi/drivers/comedi_bond.c:           char file[] = "/dev/comediXXXXXX";
>>
>> how many hits of non-static (i.e. ones that are extern) that should be
>> const but arent ?
>
> Count them and see.

you already have the #, so it's easier for you to just give it up.
even a simple "a lot" is sufficient.  if the answer is "3", then
that's a different story.
-mike
