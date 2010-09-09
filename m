Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab0IITlK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 15:41:10 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49547 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199Ab0IITlJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 15:41:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=l98Cnf3NbmzU9vik3Ry1XHPwQmBrhnpYJoPKXmEmLO2iqXH0xiNFG8GQXN1yLutMQM
         5LBUxP9oLhaWmyHJeWis0dqebloW4luFwEnbC88xF6P4CxY2v1r8nqUb93BLJ5K7p9uZ
         7yPQ2zZlzQURYJC2BW5SZXhInVzyqnAqTVK3Q=
MIME-Version: 1.0
In-Reply-To: <1284060808.24986.231.camel@Joe-Laptop>
References: <1284056536.24986.182.camel@Joe-Laptop> <AANLkTimAuA1oYyoaKsFTPEifdDsz9h=EzTB8gKudyAJk@mail.gmail.com>
 <1284058127.24986.199.camel@Joe-Laptop> <AANLkTimzAOvP62VnhpSmKoazKkPc30-YTy09g2eYPGBg@mail.gmail.com>
 <1284060808.24986.231.camel@Joe-Laptop>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 9 Sep 2010 15:40:48 -0400
Message-ID: <AANLkTikm_ROCEZco0UMX47aD28O0EALh=WYfNwSX=fVa@mail.gmail.com>
Subject: Re: [rfc patch] treewide: Convert "static const char <*> foo[] =" to
 "static const char <*> const foo[] ="
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 9, 2010 at 15:33, Joe Perches wrote:
> On Thu, 2010-09-09 at 15:16 -0400, Mike Frysinger wrote:
>> On Thu, Sep 9, 2010 at 14:48, Joe Perches wrote:
>> > could be warned by checkpatch
>> i dont think you even need to check the contents.  just match the base:
>> char foo[]
>> const char *foo[]
>> we want to catch these even if it isnt static, and catching the
>> forward decl would be useful too.
>
> I think that's not so good.
> There are times when a default is used but then modified.
>
> For instance:
> drivers/staging/comedi/drivers/comedi_bond.c:           char file[] = "/dev/comediXXXXXX";

how many hits of non-static (i.e. ones that are extern) that should be
const but arent ?

>> your perl hack isnt quite right.
>
> The script I posted doesn't eat that whitespace.
> The diff I sent you did.  I wouldn't post that.
>
>> how about making a coccinelle patch ?
>
> Not necessary I think.
> If Julia or anyone else wants to, no objection.

but people splitting the decl wouldnt be caught by your checks ...
coccinelle should catch it.

static char *
some_really_long_name[] = {
   ...
};

but if there arent any hits in the tree like this, guess it doesnt matter
-mike
