Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab1CGUeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 15:34:20 -0500
Received: from mx1.fusionio.com ([64.244.102.30]:40548 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072Ab1CGUeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 15:34:19 -0500
X-ASG-Debug-ID: 1299530056-03d6a54f621d720002-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D754146.1070206@fusionio.com>
Date: Mon, 7 Mar 2011 21:34:14 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: "oleg@redhat.com" <oleg@redhat.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] blk-throttle: Couple of cleanup and fixes for limit
  update code
References: <1298331770-20079-1-git-send-email-vgoyal@redhat.com> <20110307155006.GF9540@redhat.com> <4D753C79.4020800@fusionio.com> <20110307202917.GI9540@redhat.com>
X-ASG-Orig-Subj: Re: [PATCH 0/2] blk-throttle: Couple of cleanup and fixes for limit
  update code
In-Reply-To: <20110307202917.GI9540@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1299530056
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.57343
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-07 21:29, Vivek Goyal wrote:
> On Mon, Mar 07, 2011 at 09:13:45PM +0100, Jens Axboe wrote:
>> On 2011-03-07 16:50, Vivek Goyal wrote:
>>> On Mon, Feb 21, 2011 at 06:42:48PM -0500, Vivek Goyal wrote:
>>>> Hi Jens,
>>>>
>>>> Couple of throttle fixes seem to have fallen through cracks.
>>>>
>>>> https://lkml.org/lkml/2010/12/15/331
>>>>
>>>> I am reposting it for inclusion. Please let me know if you have any concerns.
>>>> Oleg and Paul acked the patch in the past so I am retaining their Reviewed-by:
>>>> lines.
>>>>
>>>
>>> Hi Jens,
>>>
>>> Can you please apply following patches for 2.6.39. These are good for fixing
>>> couple of race conditions in block throttle code w.r.t limit updates.
>>> Please let me know if you have concernes with these patches.
>>
>> I have applied them now. 2/2 is a nice cleanup. But it does not apply
>> cleanly after the workqueue change we merged last week. I fixed it up
>> for you, manually applied hunk #5 and added the below diff. Please
>> inspect the end result. You should have rebased that patch.
> 
> Sorry, this patch was posted before workqueue change last week. I should
> have rebased and reposted it before pinging you again. Will take care of
> it next time onwards.
> 
>>
>> Also note that you seem to have a double xchg() in there, also added
>> from 2/2.
> 
> Actually one xchg is tracking per group limit changes (tg) and one xchg()
> it tracking overall limit change per queue (td), meaning if any of
> the group on this queue has changed the limit or not. That avoids
> traversal of list of all the groups if none of the group has changed
> the limit.

Irk, it's the tg and td looking too similar. It's indeed not a double
xhcg(), sorry for the noise.

-- 
Jens Axboe

