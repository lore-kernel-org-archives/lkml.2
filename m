Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab1C2G70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 02:59:26 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:54486 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393Ab1C2G7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 02:59:25 -0400
X-ASG-Debug-ID: 1301381962-01de284cf8d06c0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D918347.7050500@fusionio.com>
Date: Tue, 29 Mar 2011 08:59:19 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@suse.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Please revert a91a2785b20
References: <alpine.LFD.2.00.1103290006070.2774@localhost6.localdomain6> <alpine.LFD.2.00.1103290040300.2774@localhost6.localdomain6> <20110328230319.GA12790@redhat.com>
X-ASG-Orig-Subj: Re: Please revert a91a2785b20
In-Reply-To: <20110328230319.GA12790@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1301381962
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.59286
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-29 01:03, Mike Snitzer wrote:
> On Mon, Mar 28 2011 at  6:43pm -0400,
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
>> Forgot to cc Jens and fixed up the borked mail address of Mike which
>> I took from the changelog :(
>>
>> On Tue, 29 Mar 2011, Thomas Gleixner wrote:
>>
>>> Out of the blue all my perfectly fine working test machines which use
>>> RAID stopped working with the very helpful error message:
>>>
>>> 	md/raid1:md1: active with 2 out of 2 mirrors
>>> 	md: pers->run() failed ...
>>>
>>> Reverting a91a2785b20 fixes the problem.
>>>
>>> Neither the subject line:
>>>
>>>  block: Require subsystems to explicitly allocate bio_set integrity mempool
>>>
>>> nor the changelog have any hint why that wreckage is in any way
>>> sensible.
>>>
>>> The wreckage happens due to:
>>>
>>> -       md_integrity_register(mddev);
>>> -       return 0;
>>> +       return md_integrity_register(mddev);
> 
> Right, a kernel.org BZ was filed on this here:
> https://bugzilla.kernel.org/show_bug.cgi?id=32062
> 
> Martin is working to "conjure up a patch" to fix the common case where
> no devices in the MD have DIF/DIX capabilities.

And I see that has been merged now. So all is good?

-- 
Jens Axboe

