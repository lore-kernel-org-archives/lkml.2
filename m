Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab1GaU5O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 16:57:14 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:45698 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490Ab1GaU5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 16:57:11 -0400
X-ASG-Debug-ID: 1312145826-01de280c1e109360001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E35C19F.6090202@fusionio.com>
Date: Sun, 31 Jul 2011 22:57:03 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Milan Broz <mbroz@redhat.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: loop: fix deadlock when sysfs and LOOP_CLR_FD race against each
  other
References: <1312053553.1187.17.camel@mop> <4E35B908.6090507@fusionio.com> <CAPXgP11W7dKSAQaemaeN=7desPtK-VonTLvLoW9_i1rUbYjvJg@mail.gmail.com>
X-ASG-Orig-Subj: Re: loop: fix deadlock when sysfs and LOOP_CLR_FD race against each
  other
In-Reply-To: <CAPXgP11W7dKSAQaemaeN=7desPtK-VonTLvLoW9_i1rUbYjvJg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1312145826
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.70531
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-07-31 22:42, Kay Sievers wrote:
> On Sun, Jul 31, 2011 at 22:20, Jens Axboe <jaxboe@fusionio.com> wrote:
>> On 2011-07-30 21:19, Kay Sievers wrote:
>>> Instead of taking the lo_ctl_mutex from sysfs code, take the inner
>>> lo->lo_lock, to protect the access to the backing_file data.
>>>
>>> Thanks to Tejun for help debugging and finding a solution.
>>
>> Looks good, looks like something that should have a stable tag as well?
> 
> Right, I think it makes sense to have that in -stable.
> 
> It's pretty hard to trigger, I had multiple threads running, crawling
> /sys and adding/binding/unbinding/removing 1000s of loop devices, and
> it takes several minutes sometimes until its hit. So I only tested it
> on top of the 3 loop-control patches, but the issue should exist in
> the current code as well.

I applied those for 3.1 as well, but I'm thinking they probably should
have been queued up for 3.2 instead.

-- 
Jens Axboe

