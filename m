Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab1KLTDJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 14:03:09 -0500
Received: from smtp.newsguy.com ([74.209.136.69]:56309 "EHLO smtp.newsguy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791Ab1KLTDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 14:03:07 -0500
Message-ID: <4EBED0B8.1030307@newsguy.com>
Date: Sat, 12 Nov 2011 12:02:00 -0800
From: Mike Dunn <mikedunn@newsguy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110917 Lightning/1.0b3pre Thunderbird/3.1.12
MIME-Version: 1.0
To: Robert Jarzmik <robert.jarzmik@free.fr>
CC: dwmw2@infradead.org, dedekind1@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/16] DocG3 fixes and write support
References: <1320912342-30147-1-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1320912342-30147-1-git-send-email-robert.jarzmik@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2011 12:05 AM, Robert Jarzmik wrote:
> nandtest/nanddump/nandwrite testing has been
> done, with and without bitflipped data.


Yay!


> Moreover, 3 new patches have been added:
>  - fix reading oob+data without correction
>    This was triggered by the bitflipped pages tests, and
>    fixes cases where we want to read corrupted data.
>  - add docg3 modes support
>    This actually fixes the read part, as we now read in
>    "normal" mode by default rather than in "reliable"
>    mode. This is mandatory for nandtest to work, because of
>    the "even/odd pages logical AND".
>  - add protection support
>    This is an evolution to be able to access the whole chip
>    in protected chips, as they are in smartphones.


How did you figure out these operating modes and the protected part stuff?  From
reverse-engineering a disassembled binary?  I'm impressed.  You don't get that
level of detail from just monitoring cpu accesses to the device during normal
operation.

BTW, I'm coming around to your thinking that the nand interface is not
appropriate for these chips.  Even though they are nand, the lack of any
standard nand interface means the nand base does not do much for you except
obfuscate.  Memory based bbt maintenance is handled in nand base, maybe a couple
other minor things.  I hope I change my mind; otherwise I'll have to rework the
G4 driver :-(

This would also eliminate my main argument for combining G3/G4 drivers: to keep
the nand interface code consistent.  That and more device differences seen in
your latest patches argue against combining.  I still strongly suspect that the
G3 is very similiar to the P3 in my Treo 650.  At some point down the road I'll
test it out on the P3.  Device capacity might be the only difference between the
two devices.  If so, the G3 driver might even work on the P3 right out of the box.

Thanks,
Mike


