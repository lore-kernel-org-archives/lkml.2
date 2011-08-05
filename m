Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327Ab1HEJWM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 05:22:12 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:53962 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094Ab1HEJWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 05:22:08 -0400
X-ASG-Debug-ID: 1312536126-03d6a510a9258930001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E3BB63D.8030801@fusionio.com>
Date: Fri, 5 Aug 2011 11:22:05 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: list corruption in the last few days. (block ? crypto ?)
References: <20110805010038.GA18148@redhat.com> <20110805084614.GA1588@x4.trippels.de> <CAOJsxLEMf8SbSmJv5u6GZtq_OYH3fpmomT-ioWXQGp83veK7wQ@mail.gmail.com>
X-ASG-Orig-Subj: Re: list corruption in the last few days. (block ? crypto ?)
In-Reply-To: <CAOJsxLEMf8SbSmJv5u6GZtq_OYH3fpmomT-ioWXQGp83veK7wQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1312536126
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.12
X-Barracuda-Spam-Status: No, SCORE=0.12 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=CN_BODY_332
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.70961
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.12 CN_BODY_332            BODY: CN_BODY_332
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-05 11:13, Pekka Enberg wrote:
> On Fri, Aug 5, 2011 at 11:46 AM, Markus Trippelsdorf
> <markus@trippelsdorf.de> wrote:
>> On 2011.08.04 at 21:00 -0400, Dave Jones wrote:
>>> Sometime in the last week, something was merged which causes my laptop
>>> to lock up occasionally.  I can trigger it most of the time just by
>>> doing a kernel build. When it gets to the final linking stage, it locks up hard.
>>>
>>> I finally managed to coax something out of usb console to get the traces below,
>>> which seem to implicate something in the block layer ?
>>>
>>> my root device is an lvm volume on an dmcrypt'd block dev, which might be relevant,
>>> as I don't see this happening on other machines with simpler setups.
>>>
>>> I'm going to try bisecting, but it might take me a few days, because it's
>>> such a pain in the ass to reproduce this reliably.
>>>
>>> [ 5913.233035] ------------[ cut here ]------------
>>> [ 5913.233097] WARNING: at lib/list_debug.c:53 __list_del_entry+0x8d/0x98()
>>> [ 5913.233101] Hardware name: Adamo 13
>>> [ 5913.233105] list_del corruption. prev->next should be ffffea000434fd20, but was ffffea0004199520
>>
>> See also: http://lkml.org/lkml/2011/8/3/37
> 
> That's in networking so SLUB lockless patches are almost certainly the
> issue here. Is this with SLUB debugging enabled or not? Christoph, it
> like the partial lists are getting corrupted somehow.

I knew it was you, Perks!

:-)

-- 
Jens Axboe

