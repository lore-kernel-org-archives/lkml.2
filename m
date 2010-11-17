Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933780Ab0KQK6X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 05:58:23 -0500
Received: from mx2.fusionio.com ([64.244.102.31]:44049 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932541Ab0KQK6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 05:58:21 -0500
X-ASG-Debug-ID: 1289991500-08b7aaac0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4CE3B547.7050907@fusionio.com>
Date: Wed, 17 Nov 2010 11:58:15 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cciss: fix build for PROC_FS disabled
References: <AANLkTimYevUOSxDm+nGq_ctPEFp_E2zJR7rNGvUi2fWY@mail.gmail.com> <20101116170005.2646f4fb.randy.dunlap@oracle.com> <AANLkTimE_y=GFP+Sg-MYvEfQyg7GtzGRs+gdqjzOZm-_@mail.gmail.com>
X-ASG-Orig-Subj: Re: [PATCH] cciss: fix build for PROC_FS disabled
In-Reply-To: <AANLkTimE_y=GFP+Sg-MYvEfQyg7GtzGRs+gdqjzOZm-_@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1289991500
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.46877
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-11-17 03:56, Linus Torvalds wrote:
> On Tue, Nov 16, 2010 at 5:00 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>
>> Fix cciss driver for CONFIG_PROC_FS not enabled:
>>
>> drivers/block/cciss.c:4929: error: 'proc_cciss' undeclared (first use in this function)
> 
> Hmm. I would almost prefer to not have this #ifdef inside code, and
> solve it by simply moving the definition of "proc_cciss" to outside
> the other #ifdef CONFIG_PROC_FS.
> 
> That way it allways stays NULL, and without CONFIG_PROC_FS the code in
> question will all be empty inline function calls anyway, so the
> compiler will compile it all away (at the cost of just keeping that
> one unnecessary variable around).
> 
> I'd rather waste one useless pointer than have ugly source code.
> 
> Comments?

Agree, I merged this:

http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=bbe425cd9ae83eacd0c9f09df2bf56dc911a54cd

-- 
Jens Axboe

