Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161906Ab1FAJQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 05:16:10 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:34348 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161770Ab1FAJQC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 05:16:02 -0400
X-ASG-Debug-ID: 1306919759-01de280c1e12bf0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DE6034C.4020808@fusionio.com>
Date: Wed, 1 Jun 2011 11:15:56 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>,
        "stable-review@kernel.org" <stable-review@kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [026/146] block: dont block events on excl write for non-optical
References: <20110601080606.GA522@kroah.com> <20110601080253.331790414@blue.kroah.org> <20110601081514.GG23067@mtj.dyndns.org> <20110601085816.GA12801@suse.de>
X-ASG-Orig-Subj: Re: [026/146] block: dont block events on excl write for non-optical
In-Reply-To: <20110601085816.GA12801@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1306919759
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 1.00
X-Barracuda-Spam-Status: No, SCORE=1.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=BSF_RULE7568M, BSF_RULE_7582B
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.65280
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.50 BSF_RULE7568M          Custom Rule 7568M
	0.50 BSF_RULE_7582B         Custom Rule 7582B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-06-01 10:58, Greg KH wrote:
> On Wed, Jun 01, 2011 at 05:15:14PM +0900, Tejun Heo wrote:
>> Hello, Greg.
>>
>> On Wed, Jun 01, 2011 at 04:59:22PM +0900, Greg KH wrote:
>>> 2.6.38-stable review patch.  If anyone has any objections, please let us know.
>>>
>>> ------------------
>>>  devices
>>>
>>> From: Tejun Heo <tj@kernel.org>
>>>
>>> commit d4dc210f69bcb0b4bef5a83b1c323817be89bad1 upstream.
>>>
>>> Disk event code automatically blocks events on excl write.  This is
>>> primarily to avoid issuing polling commands while burning is in
>>> progress.  This behavior doesn't fit other types of devices with
>>> removeable media where polling commands don't have adverse side
>>> effects and door locking usually doesn't exist.
>>>
>>> This patch introduces new genhd flag which controls the auto-blocking
>>> behavior and uses it to enable auto-blocking only on optical devices.
>>>
>>> Note for stable: 2.6.38 and later only
>>
>> This one should be accompanied by the following commit which is
>> currently in Jens' tree and will soon be pulled into Linus' tree.
>> Sorry about the fuss.  ->check_events() update turned out to be much
>> more fragile than I originally expected.  :(
>>
>> commit 4c49ff3fe128ca68dabd07537415c419ad7f82f9
>> Author: Tejun Heo <tj@kernel.org>
>> Date:   Wed Jun 1 08:27:41 2011 +0200
>>
>>     block: blkdev_get() should access ->bd_disk only after success
> 
> As I can't take it into -stable until it hits Linus's tree, I'll have to
> wait until then.  Hopefully it hits there soon, I'll watch out for it.
> 
> thanks for letting me know.

It'll go out in the next few days. The above commit also references this
patch, so you should have proper notification when it goes in.

-- 
Jens Axboe

