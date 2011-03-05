Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab1CEMlk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 07:41:40 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:32933 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab1CEMlj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 07:41:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bkNO9dHSVuXw9B14z983K9sWyhKK26VATUZEJz4yhVVIYAjXEixp9Oi23fvoY2fWDg
         XoGAAcMDCnk1p05pURB8QVhd51g6z3ZMGoVmQSRC5dH3WC/scdG6At6glRU0Z2RXceN4
         c1r+aBxQuTFFYeu490pK26RVrBRkvxUnZ5lTQ=
MIME-Version: 1.0
In-Reply-To: <20110305112936.GA30187@opensource.wolfsonmicro.com>
References: <20110304180027.20deb6c4.sfr@canb.auug.org.au>
	<20110304173357.23d36116.randy.dunlap@oracle.com>
	<20110305112936.GA30187@opensource.wolfsonmicro.com>
Date: Sat, 5 Mar 2011 20:41:38 +0800
Message-ID: <AANLkTikivW3+V4QYh9Nt9FGXTefZiN9WbpAvGVeBJHNN@mail.gmail.com>
Subject: Re: [PATCH -next] soc: sgtl5000 uses regulator interfaces
From: Zeng Zhaoming <zengzm.kernel@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Zeng Zhaoming <zhaoming.zeng@freescale.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 5, 2011 at 7:29 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Fri, Mar 04, 2011 at 05:33:57PM -0800, Randy Dunlap wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> sgtl5000 uses regulator interfaces, so make selecting it depend
>> on REGULATOR.
>>
>> sgtl5000.c:(.text+0x4ae33): undefined reference to `regulator_unregister'
>> sgtl5000.c:(.text+0x4af41): undefined reference to `rdev_get_drvdata'
>> sgtl5000.c:(.text+0x4b191): undefined reference to `regulator_register'
>

hi， Thanks for the report.

> Since the regulator on the device is optional this isn't the best fix,
> the code should be updated to support building without regulator.

I will fix the code. If regulator not enabled, and the optional
regulator not provided externally,
a warning message will print out, and internal regulator will set
directly by write register.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Best Regards
    Zeng Zhaoming
