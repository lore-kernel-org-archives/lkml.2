Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab1C2GeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 02:34:09 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:53010 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876Ab1C2GeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 02:34:06 -0400
X-ASG-Debug-ID: 1301380445-03d6a5652c11790001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D917D5A.5040502@fusionio.com>
Date: Tue, 29 Mar 2011 08:34:02 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] block drivers for 2.6.39-rc
References: <4D8E36CC.7080707@fusionio.com> <AANLkTinpjfyrN0mCRZi8zPqd2=+=WGRRToFhc+MqBDSB@mail.gmail.com>
X-ASG-Orig-Subj: Re: [GIT PULL] block drivers for 2.6.39-rc
In-Reply-To: <AANLkTinpjfyrN0mCRZi8zPqd2=+=WGRRToFhc+MqBDSB@mail.gmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1301380445
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.59285
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-29 01:06, Linus Torvalds wrote:
> On Sat, Mar 26, 2011 at 11:56 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
>> Hi Linus,
>>
>> This is the pull request for the block driver updates for 2.6.39. Two
>> things here:
>>
>> - Big drbd update, as per usual...
>> - cciss update.
> 
> Btw, that cciss thing causes a very annoying compiler warning:
> 
>   drivers/block/cciss.c: In function ‘dev_show_unique_id’:
>   drivers/block/cciss.c:617:7: warning: ‘sn[0]’ may be used
> uninitialized in this function
>   drivers/block/cciss.c:617:7: warning: ‘sn[1]’ may be used
> uninitialized in this function
>   drivers/block/cciss.c:617:7: warning: ‘sn[2]’ may be used
> uninitialized in this function
>   drivers/block/cciss.c:617:7: warning: ‘sn[3]’ may be used
> uninitialized in this function
>   drivers/block/cciss.c:617:7: warning: ‘sn[4]’ may be used
> uninitialized in this function
>   drivers/block/cciss.c:617:7: warning: ‘sn[5]’ may be used
> uninitialized in this function
>   drivers/block/cciss.c:617:7: warning: ‘sn[6]’ may be used
> uninitialized in this function
>   drivers/block/cciss.c:617:7: warning: ‘sn[7]’ may be used
> uninitialized in this function
>   drivers/block/cciss.c:617:7: warning: ‘sn[8]’ may be used
> uninitialized in this function
>   drivers/block/cciss.c:617:7: warning: ‘sn[9]’ may be used
> uninitialized in this function
>   drivers/block/cciss.c:617:7: warning: ‘sn[10]’ may be used
> uninitialized in this function
>   drivers/block/cciss.c:617:7: warning: ‘sn[11]’ may be used
> uninitialized in this function
>   drivers/block/cciss.c:617:7: warning: ‘sn[12]’ may be used
> uninitialized in this function
>   drivers/block/cciss.c:617:7: warning: ‘sn[13]’ may be used
> uninitialized in this function
>   drivers/block/cciss.c:617:7: warning: ‘sn[14]’ may be used
> uninitialized in this function
>   drivers/block/cciss.c:617:7: warning: ‘sn[15]’ may be used
> uninitialized in this function
> 
> which is because the compiler doesn't really notice that those things
> are only used if the error return isn't being set.
> 
> So it's a compiler mis-feature, but the thing is, the warning could
> easily be avoided by just writing the code more prettily.
> 
> Just do the memcpy() unconditionally: we know that 'drv' is a valid
> pointer (we just loaded 'h' off it), and we're talking about a nice
> constant 16-byte copy.
> 
> IOW, a patch something like the attached.
> 
> Untested, but it looks really obvious. Hmm?

Looks good to me. I'm curious, you get a warning in dev_show_unique_id()
but not in dev_show_vendor() or any of the other following 4-5 functions
written in the same style?

My gcc here does not warn for any of them. But it is very convoluted for
what it does

-- 
Jens Axboe

