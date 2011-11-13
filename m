Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab1KMKl7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 05:41:59 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:41976 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164Ab1KMKl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 05:41:58 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Mike Dunn <mikedunn@newsguy.com>
Cc: dwmw2@infradead.org, dedekind1@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/16] DocG3 fixes and write support
References: <1320912342-30147-1-git-send-email-robert.jarzmik@free.fr>
	<4EBED0B8.1030307@newsguy.com>
X-URL: http://belgarath.falguerolles.org/
Date: Sun, 13 Nov 2011 11:41:49 +0100
In-Reply-To: <4EBED0B8.1030307@newsguy.com> (Mike Dunn's message of "Sat, 12
	Nov 2011 12:02:00 -0800")
Message-ID: <87ipmoi9si.fsf@free.fr>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Dunn <mikedunn@newsguy.com> writes:

> How did you figure out these operating modes and the protected part stuff?  From
> reverse-engineering a disassembled binary?  I'm impressed.  You don't get that
> level of detail from just monitoring cpu accesses to the device during normal
> operation.
Retro-engineering and the nandwrite tests.
You see nandtest did not work. I could see why, and made some additionnal
tests. The result was that writting to page 0 and page 1 gave back the AND of
these both pages.

And from there, I checked what was the difference between DOCG3 IPL and SPL, and
landed on the "mode" register.

> BTW, I'm coming around to your thinking that the nand interface is not
> appropriate for these chips.  Even though they are nand, the lack of any
> standard nand interface means the nand base does not do much for you except
> obfuscate.  Memory based bbt maintenance is handled in nand base, maybe a couple
> other minor things.  I hope I change my mind; otherwise I'll have to rework the
> G4 driver :-(
I don't know for G4, but I'm more convinced for G3 as well, as NAND interface
provides some state machine in the chip (where the last seek occured, ...).

> I still strongly suspect that the G3 is very similiar to the P3 in my Treo
> 650.  At some point down the road I'll test it out on the P3.  Device capacity
> might be the only difference between the two devices.  If so, the G3 driver
> might even work on the P3 right out of the box.
And if not right out of the box, I'll bet on :
 - adding a DOC_CHIPID_P3 ...
 - and if the chip is bigger, amend doc_setup_addr_sector(0 and
 doc_setup_writeaddr_sector() to input another byte of address (ie. add a line
 with doc_flash_address(docg3, (sector >> 24) & 0xff).

Cheers.

--
Robert
