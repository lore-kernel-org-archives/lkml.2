Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab1C1GoB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 02:44:01 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:46086 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140Ab1C1GoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 02:44:00 -0400
X-ASG-Debug-ID: 1301294639-01de284cf8c6ca0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D902E2C.2010701@fusionio.com>
Date: Mon, 28 Mar 2011 08:43:56 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] block drivers for 2.6.39-rc
References: <4D8E36CC.7080707@fusionio.com>	<20110328042311.GA15481@elte.hu>	<AANLkTik3GZ0b5S7p4ONQu4Hb8LoKewmMJ7_J5zvumYD-@mail.gmail.com> <20110328160812.b4d19eb5.sfr@canb.auug.org.au>
X-ASG-Orig-Subj: Re: [GIT PULL] block drivers for 2.6.39-rc
In-Reply-To: <20110328160812.b4d19eb5.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1301294639
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.50
X-Barracuda-Spam-Status: No, SCORE=0.50 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=BSF_RULE7568M
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.59190
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.50 BSF_RULE7568M          Custom Rule 7568M
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-28 07:08, Stephen Rothwell wrote:
> Hi Linus, Ingo,
> 
> On Sun, 27 Mar 2011 21:37:50 -0700 Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>
>> On Sun, Mar 27, 2011 at 9:23 PM, Ingo Molnar <mingo@elte.hu> wrote:
>>>
>>> This driver does not build at all:
>>>
>>>  drivers/block/drbd/drbd_bitmap.c:1187:5: error: implicit declaration of function ‘generic_find_next_zero_le_bit’ [-Werror=implicit-function-declaration]
>>>  drivers/block/drbd/drbd_bitmap.c:1190:5: error: implicit declaration of function ‘generic_find_next_le_bit’ [-Werror=implicit-function-declaration]
>>>  drivers/block/drbd/drbd_bitmap.c:1290:4: error: implicit declaration of function ‘generic___test_and_set_le_bit’ [-Werror=implicit-function-declaration]
>>>  drivers/block/drbd/drbd_bitmap.c:1292:4: error: implicit declaration of function ‘generic___test_and_clear_le_bit’ [-Werror=implicit-function-declaration]
>>>  drivers/block/drbd/drbd_bitmap.c:1441:3: error: implicit declaration of function ‘generic_test_le_bit’ [-Werror=implicit-function-declaration]
>>>
>>> Has this been build-tested? These APIs do not exist upstream.
>>
>> Actually, I think that's just a merge error - those horrible nasty
>> crazy names did use to exist.
>>
>> Does this fix it? (Untested!)
> 
> You also need to remove the include of asm-generic/bitops/le.h from that
> file now (the easiest way is to revert commit f0ff1357ce39 ("drbd: need
> include for bitops functions declarations").
> 
> Jens was informed about these problems when they appeared in linux-next.

Yes, and I merged your patch to fixup the build (on PPC, as I recall).

-- 
Jens Axboe

