Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932958Ab0JFSiX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 14:38:23 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:51054 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759748Ab0JFSiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 14:38:22 -0400
X-ASG-Debug-ID: 1286390300-08b7e9980001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4CACC218.3020407@fusionio.com>
Date: Wed, 6 Oct 2010 20:38:16 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Christoph Hellwig <hch@lst.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] one writeback regression fix for .36
References: <4CACA9AD.9070900@fusionio.com> <AANLkTi=NkzSWR0voR9xLs2f7Rxfc4A_n7qi+t9fbB2iz@mail.gmail.com>
X-ASG-Orig-Subj: Re: [GIT PULL] one writeback regression fix for .36
In-Reply-To: <AANLkTi=NkzSWR0voR9xLs2f7Rxfc4A_n7qi+t9fbB2iz@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1286390300
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.42916
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-10-06 20:17, Linus Torvalds wrote:
> On Wed, Oct 6, 2010 at 9:54 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
>>
>> The recent patch series from Jan introduced a WARN_ON() regression.
>> The real fix for this is adding a super_operations->get_bdi(), which
>> we'll do for 2.6.37.
>>
>> Please pull.
>>
>> are available in the git repository at:
>>  git://git.kernel.dk/linux-2.6-block.git for-linus
>>
>> Christoph Hellwig (1):
>>      writeback: always use sb->s_bdi for writeback purposes
> 
> This is a f*cking disgrace. It's now the second patch I see during
> this release window that works by parsing random strings in the block
> device layer.
> 
> This needs to stop. There's something seriously wrong in the whole
> subsystem. This kind of hackery is a disease, and it seems to be
> endemic.

I'm not enjoying this patch anymore than you are, trust me. As Al
mentioned, it's not as bad as it appears (which is good, because it
appears like a bastard). We could work around this ugliness, but at this
point it'll just be a prettied up turd anyway. So may as well go for the
simple variant of that at least.

> So let's just make sure that 2.6.37 really does clean these things up.
> And dammit, I don't want to see more random crap added. There has been
> too much crazyness going on, with too little taste in the whole
> writeback and IO scheduler area. Jens, you need to put the brakes on.
> No more crap. Really. Make 2.6.37 a stabilization and cleanup release,
> without new crazy features or clever tweaking. Ok? Because writeback
> was a disaster in 2.6.35, and it's been this kind of crazy ugly in
> 2.6.36.
> 
> So I'm not taking any more writeback changes unless I feel that you
> are actively working on cleaning up the crazy tasteless crap without
> adding new code.

Agree, there's no complex stuff queued up for .37. Brakes are on, we do
need a stability release on that side.

-- 
Jens Axboe

