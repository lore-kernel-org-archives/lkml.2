Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762603Ab2FVPde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:33:34 -0400
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:35207 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762327Ab2FVPdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:33:31 -0400
MIME-Version: 1.0
In-Reply-To: <4FE45C4E.8060808@gmail.com>
References: <CACVXFVO-Wm1Qwporby1M=+yPz81AWHpZRBZSbr5tgT32b6sSEA@mail.gmail.com>
	<CANrkHUYd8Ww6De4MiZ8_oPfcnhvtsZXOySLRiWSBU4QUQ6beHw@mail.gmail.com>
	<CACVXFVP16UmHe-GGydrSMgGHwnkSvYhnY339=zr=BfCehvS8Kw@mail.gmail.com>
	<CANrkHUaxJGcv2bdUWTCB_oKct-iFCKCdb7OQPTUjS4MuKeCS2w@mail.gmail.com>
	<4FE0AE7B.4040502@gmail.com>
	<CANrkHUawrQfb+o+W7FrYACv6NocZn_MAym5A209peP8tW1nZRQ@mail.gmail.com>
	<4FE45C4E.8060808@gmail.com>
Date: Fri, 22 Jun 2012 21:03:28 +0530
Message-ID: <CANrkHUYFZ3y1hyDD54nD-wqmhPcvkrjBQAzf23OknABJsUS0AA@mail.gmail.com>
Subject: Re: MMC: commit dba3c29 ruins mmc card data on beagle-xm revB
From: "T Krishnamoorthy, Balaji" <balajitk@ti.com>
To: Paolo Pisati <p.pisati@gmail.com>
Cc: Ming Lei <ming.lei@canonical.com>, linux-mmc@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Ball <cjb@laptop.org>, Venkatraman S <svenkatr@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 5:21 PM, Paolo Pisati <p.pisati@gmail.com> wrote:
> On 06/20/2012 09:23 AM, T Krishnamoorthy, Balaji wrote:
>>>
>>> i just want to say that i'm affected by this too, and i can reproduce it
>>> 100%.
>>>
>>
>> Is it with SD or MMC card
>> Can you provide Beagle board rev info?
>
> kingston 4g class 4 sdhc c04g taiwan
>
> tested on a beagle xm rev a and rev c, both boards exhibit the same
> problem with this card, while with a brand new sandisk 16gb sdhc class 4
> card, everything is ok.
>
> i tried reverting dba3c29 "Enable Auto CMD12", and both cards are
> behaving fine.
>
>>> do you want me to run that patch or you already have enough data?
>>
>> Can you enable MMC debug and apply the debug patch I provided.
>> The debug patch did not print any AUTOCMD errors with Ming Lei setup.
>
> http://people.canonical.com/~ppisati/mmc-testing/
>
> test-mmc.sh: script used for testing
>
> test-mmc.log: md5sum of file copied around (as you can see after the
> umount the md5 changes)
>
> test-mmc.syslog: mmc-debug output (plus your patch)

Thanks for testing and sharing the log.
md5sum is giving 2 different values for 8 tries which indicates writes are not
entirely random.

>
> after the test, my sd card was so badly wounded that it wouldn't even boot.

I guess boot partition was not updated, so I think it should boot until kernel
and fail at mounting filesystem as filesystem would have got corrupted by
previous test.

> --
> bye,
> p.
