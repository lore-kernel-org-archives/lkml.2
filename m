Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540Ab1FXXDQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 19:03:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:42257 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758145Ab1FXXDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 19:03:13 -0400
Message-ID: <4E051791.9010800@infradead.org>
Date: Fri, 24 Jun 2011 20:02:41 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
        Andy Walls <awalls@md.metrocast.net>,
        Hans Verkuil <hverkuil@xs4all.nl>, Jesper Juhl <jj@chaosbits.net>,
        LKML <linux-kernel@vger.kernel.org>, trivial@kernel.org,
        linux-media@vger.kernel.org, ceph-devel@vger.kernel.org,
        Sage Weil <sage@newdream.net>
Subject: Re: [RFC] Don't use linux/version.h anymore to indicate a per-driver
 version - Was: Re: [PATCH 03/37] Remove unneeded version.h includes from
 include/
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>	<4E04912A.4090305@infradead.org>	<BANLkTim9cBiiK_GsZaspxpPJQDBvAcKCWg@mail.gmail.com>	<201106241554.10751.hverkuil@xs4all.nl>	<4E04A122.2080002@infradead.org>	<20110624203404.7a3f6f6a@stein>	<BANLkTimj-oEDvWxMao6zJ_sudUntEVjO1w@mail.gmail.com>	<1308949448.2093.20.camel@morgan.silverblock.net>	<20110624232048.66f1f98c@stein>	<BANLkTinZoax2fcSxvyQgfsT-bmsF+BofyQ@mail.gmail.com> <20110625003911.5c14a95e@stein>
In-Reply-To: <20110625003911.5c14a95e@stein>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 24-06-2011 19:39, Stefan Richter escreveu:
> On Jun 24 Devin Heitmueller wrote:
>> On Fri, Jun 24, 2011 at 5:20 PM, Stefan Richter
>> <stefanr@s5r6.in-berlin.de> wrote:
>>> Easier:
>>>  "I run Ubuntu 10.4".
>>>  "I run kernel 2.6.32."
>>> One of these is usually already included in the first post or IRC message
>>> from the user.
>>>
>>> Separate driver versions are only needed on platforms where drivers are
>>> not distributed by the operating system distributor, or driver source code
>>> is not released within kernel source code.
>>
>> Unfortunately, this doesn't work as all too often the user has "Ubuntu
>> 10.1 but I installed the latest media_build tree a few months ago".
>> Hence they are not necessarily on a particular binary release from a
>> distro but rather have a mix of a distro's binary release and a
>> v4l-dvb tree compiled from source.
> 
> If you release out-of-kernel-source driver sources for compilation against
> binary kernels, and you have got users who go through this procedure, then
> the user can for sure tell you the SCM version of the driver.

Yes, and this is currently provided. The dmesg will show the last 3 git commits.
A developer can just use git diff or git log to discover what changed since those
commits.

> Besides, isn't this outdated practice in times where Joe Enduser can get
> the very latest -rc kernel prepackaged on many distributions, including
> ones like Ubuntu?

Perhaps, but the cost to maintain the out-of-tree driver git tree is cheap. We provide
just a small building system, with a script that downloads a daily tarball
with just drivers/media and the corresponding includes (and a few drivers/staging).
The building system has a couple patches to allow backport compilation since 2.6.32.

Mauro.
