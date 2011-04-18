Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575Ab1DRLov (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 07:44:51 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:37775 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033Ab1DRLop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 07:44:45 -0400
X-ASG-Debug-ID: 1303127081-01de284cf815c730001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DAC2429.5000105@fusionio.com>
Date: Mon, 18 Apr 2011 13:44:41 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Bart Van Assche <bvanassche@acm.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, Neil Brown <neilb@suse.de>
Subject: Re: [Bug #32982] Kernel locks up a few minutes after boot
References: <OlQwC5HnRsN.A.ULB.OGuqNB@chimera> <_H4l51C1wXN.A.yDC.yGuqNB@chimera> <BANLkTimeaHwBiZoz=isCM=qtBxoxaBqDUw@mail.gmail.com> <BANLkTi=1jO73DXDTD50bVpU82qphVKmRCw@mail.gmail.com>
X-ASG-Orig-Subj: Re: [Bug #32982] Kernel locks up a few minutes after boot
In-Reply-To: <BANLkTi=1jO73DXDTD50bVpU82qphVKmRCw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1303127081
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.61209
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-17 20:37, Bart Van Assche wrote:
> On Sun, Apr 17, 2011 at 7:03 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> On Sun, Apr 17, 2011 at 5:57 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>> This message has been generated automatically as a part of a summary report
>>> of recent regressions.
>>>
>>> The following bug entry is on the current list of known regressions
>>> from 2.6.38.  Please verify if it still should be listed and let the tracking team
>>> know (either way).
>>>
>>>
>>> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=32982
>>> Subject         : Kernel locks up a few minutes after boot
>>> Submitter       : Bart Van Assche <bart.vanassche@gmail.com>
>>> Date            : 2011-04-10 19:55 (8 days old)
>>
>> Is this machine running a RAID5 setup or something like that?
>>
>> There is a known interaction with the new block layer plugging code
>> and MD. The "hung task" report in that bugzilla looks very much like
>> that issue. And you do have "root=/dev/md0", so clearly there's some
>> md thing going on.
>>
>> And bisecting might not work all that well for it, because I suspect
>> it ends up being very much a matter of IO patterns how it triggers.
>>
>> Neil supposedly has a patch for it, but I haven't seen it yet. Neil, Jens?
> 
> (converted top-posting into bottom-posting)
> 
> Hello Linus,
> 
> On the system on which bug #32982 has been triggered md0, md1 and md2
> have been configured as two-disk RAID1 (mirroring).
> 
> I've done my best to trigger enough I/O in order to obtain reliable
> bisect results. A difficulty I encountered during bisecting though was
> that I encountered unbootable kernels (all skipped revisions).

Bart, can you try and pull:

git://git.kernel.dk/linux-2.6-block.git for-linus

into Linus' tree and see if that works? This has, among other things,
Neils fixes for MD.

-- 
Jens Axboe

