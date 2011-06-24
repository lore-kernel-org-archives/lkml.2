Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906Ab1FXN3X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 09:29:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:54523 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab1FXN3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 09:29:22 -0400
Message-ID: <4E04912A.4090305@infradead.org>
Date: Fri, 24 Jun 2011 10:29:14 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>, Jesper Juhl <jj@chaosbits.net>,
        LKML <linux-kernel@vger.kernel.org>, trivial@kernel.org,
        linux-media@vger.kernel.org, ceph-devel@vger.kernel.org,
        Sage Weil <sage@newdream.net>
Subject: Re: [RFC] Don't use linux/version.h anymore to indicate a per-driver
 version - Was: Re: [PATCH 03/37] Remove unneeded version.h includes from
 include/
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>	<alpine.LNX.2.00.1106232356530.17688@swampdragon.chaosbits.net>	<4E04732A.3060305@infradead.org>	<201106241326.27593.hverkuil@xs4all.nl> <BANLkTinXymR_2A2Mr+UbhK63s2xjtK=B=g@mail.gmail.com>
In-Reply-To: <BANLkTinXymR_2A2Mr+UbhK63s2xjtK=B=g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 24-06-2011 09:20, Devin Heitmueller escreveu:
>> Applications are certainly using it. I know this for a fact for the ivtv driver where
>> feature improvements are marked that way.
>>
>> Without more research on how this is used I am not comfortable with this.
>>
>> Regards,
>>
>>        Hans
> 
> MythTV has a bunch of these too (mainly so the code can adapt to
> driver bugs that are fixed in later revisions).  Putting Mauro's patch
> upstream will definitely cause breakage.

It shouldn't, as ivtv driver version is lower than 3.0.0. All the old bug fixes
aren't needed if version is >= 3.0.0.

Besides that, trusting on a driver revision number to detect that a bug is
there is not the right thing to do, as version numbers are never increased at
the stable kernels (nor distro modified kernels take care of increasing revision
number as patches are backported there).

In other words, relying on it doesn't work fine.

> Also, it screws up the ability for users to get fixes through the
> media_build tree (unless you are increasing the revision constantly
> with every merge you do).

Why? Developers don't increase version numbers on every applied patch
(with is great, as it avoids merge conflicts).

Mauro

