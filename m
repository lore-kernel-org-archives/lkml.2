Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab0KIUfW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 15:35:22 -0500
Received: from mx1.fusionio.com ([64.244.102.30]:40502 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754617Ab0KIUfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 15:35:15 -0500
X-ASG-Debug-ID: 1289334913-6b657cd00001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4CD9B07E.70502@fusionio.com>
Date: Tue, 9 Nov 2010 21:35:10 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
CC: Daniel J Blueman <daniel.blueman@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.37-rc1] sys_ioprio_set and RCU locking...
References: <AANLkTi=xj6xW5SnrdQos4P-MtJP8+fwfaa3r7LPfdLh4@mail.gmail.com> <20101107185433.GD15561@linux.vnet.ibm.com> <4CD7FAFD.1060802@fusionio.com> <20101108135204.GE2580@linux.vnet.ibm.com> <4CD80162.9000607@fusionio.com>
X-ASG-Orig-Subj: Re: [2.6.37-rc1] sys_ioprio_set and RCU locking...
In-Reply-To: <4CD80162.9000607@fusionio.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1289334913
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.4973 1.0000 0.0000
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.46163
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-11-08 14:55, Jens Axboe wrote:
>>>>> Take the RCU lock for read across acquiring the pointer to the task
>>>>> credentials and dereferencing it.
>>>>
>>>> Jens, does this look sane?
>>>
>>> Yes, looks clean enough to me.
>>
>> Very good!  Are you willing to take the patch in your tree?
> 
> Certainly, I'm in the middle of patch monkeying now anyway. Will queue
> it up.

The patch was buggy, I discovered that it does not do the proper
RCU unlock if we fail the uid match. Merged version here:

http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=1a882abdbf9579ad0e5655f928e4ede30db301e6

-- 
Jens Axboe

