Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129Ab1CZN7A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 09:59:00 -0400
Received: from mail.bisel.ru ([80.93.56.210]:39499 "EHLO mail.bisel.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926Ab1CZN67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 09:58:59 -0400
X-Envelope-Recipient: alan@lxorguk.ukuu.org.uk
X-Envelope-Recipient: jgarzik@pobox.com
X-Envelope-Recipient: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Sat, 26 Mar 2011 16:58:55 +0300
From: igor@novg.net
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: <jgarzik@pobox.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2.6.38.1] =?UTF-8?Q?pata=5Fit=38=32=31x=3A=20Add=20mod?=
 =?UTF-8?Q?ule=20param=20to=20force=20UDMA=20on=20Vortex=38=36SX?=
In-Reply-To: <20110326125441.3e628850@lxorguk.ukuu.org.uk>
References: <89bf4e2c74a16f130208a485c6eafd77@novg.net>
 <20110326125441.3e628850@lxorguk.ukuu.org.uk>
Message-ID: <90c1a5f93e6d67aec9f67a1d4c0deb86@novg.net>
User-Agent: Roundcube Webmail/0.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On Sat, 26 Mar 2011 12:54:41 +0000, Alan Cox wrote:
>>  May be there are errors with pure IDE devices or with older 
>> revisions
>>  of Vortex86SX
>>  boards, i do no know. But for my device i have 2x improvement in 
>> I/O
>>  speed when
>>  enabling UDMA/33 instead of MWDMA, so i think this parameter would 
>> be
>>  useful.
>
> "I do not know" is not a good basis for hacking storage code,
> particularly if it was to turn out that the reason was something like
> silent data corruption (eg as with UDMA on the old OSB4 controllers 
> in
> some cases)
>

 Well, by "i do not know" i meant that i do not have other (older) DMP
 hardware, nor do i have means to connect pure IDE device to my device
 (DMP-2300).
 I just can state that i was having a root FS on a CompactFlash for 
 quite
 a long time with UDMA enabled, and i have not observed any problems, 
 and
 have seen no signs of data corruption either.

 I am just proposing to give users an option to enable UDMA at their own 
 risk,
 maybe add comment stating that enabling this option may or may not
 cause silent data corruption. Or maybe to add this as a sub-option to 
 the
 driver in Kconfig to switch on/off at compile time with detailed 
 description
 under ---help---

> The change came via DMP signoff (the manufacturer) so any adjustment 
> of
> this sort of checking really ought to go via DMP as well.
>
>>  Also fix to initialize default value for parameter 'noraid'.
>
> This does not need initialising - C guarantees static variables start 
> at
> zero. If that makes a difference you have other problems.

 Sorry, my bad.

> So NAK this.
>
> Although if you want to take it up with DMP and find out if they have
> updated rules or checks that want pushing that might be useful.

 No, i do not intend to contact them, i just wanted people to have an 
 on/off
 switch in kernel, not to push this patch by all means necessary.

 If this option is considered by community unneeded, i'll just have to 
 patch my
 own kernel with every upgrade :)

> Alan

