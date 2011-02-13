Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab1BMUxo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 15:53:44 -0500
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:40081 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754751Ab1BMUxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 15:53:38 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-14.arcor-online.net 2BFF99C0A3
Message-Id: <E1Poiwb-0002rc-Lm@be1.7eggert.dyndns.org>
From: Bodo Eggert 
	<arcoristkaputtundbrauchtdiesentext.7eggert@nurfuerspam.de>
Subject: Re: [PATCH] md: Remove risk of overflow via sprintf) by using snprintf()  in md_check_recovery()
To: Michael Tokarev <mjt@tls.msk.ru>, "Daniel K." <dk@uw.no>,
        Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>,
        Neil Brown <neilb@cse.unsw.edu.au>
Reply-To: 7eggert@nurfuerspam.de
Date: Sun, 13 Feb 2011 21:53:21 +0100
References: <gl8SB-1hb-11@gated-at.bofh.it> <glk7o-3l2-17@gated-at.bofh.it> <glo1k-1AX-17@gated-at.bofh.it>
User-Agent: KNode/0.10.9
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev <mjt@tls.msk.ru> wrote:
> 12.02.2011 12:34, Daniel K. wrote:
>> Jesper Juhl wrote:

>>> sprintf() is dangerous - given the wrong source string it will
>>> overflow the destination. snprintf() is safer in that at least we'll
>>> never overflow the destination. Even if overflow will never happen
>>> today, code changes over time and snprintf() is just safer in the long
>>> run.
>>
>>> -                        sprintf(nm,"rd%d", rdev->raid_disk);
>>> +                        snprintf(nm, sizeof(nm), "rd%d",
>>> rdev->raid_disk);
>>>                          sysfs_remove_link(&mddev->kobj, nm);

> C'mon guys, this is pointless.  20 bytes allocated for the device
> name, and this is for raid disk number.  It is impossible to have
> more than 10^17 (20 bytes total, 2 for "rd" and on for the zero
> terminator) drives in a single array.

If you argue that you might get a buffer overflow, you'll have to check
for snprintf errors, too.
-- 
Logic: The art of being wrong with confidence... 

Friß, Spammer: tR@c.7eggert.dyndns.org S5xk@h.7eggert.dyndns.org
 loqnjg@GFhzy.7eggert.dyndns.org 6hs4Axaqf@ndlJ.7eggert.dyndns.org

