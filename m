Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329Ab1CATww (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 14:52:52 -0500
Received: from mx2.fusionio.com ([64.244.102.31]:41550 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757195Ab1CATwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 14:52:47 -0500
X-ASG-Debug-ID: 1299009165-01de280c5311b860001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D6D4E89.5080406@fusionio.com>
Date: Tue, 1 Mar 2011 14:52:41 -0500
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Justin TerAvest <teravest@google.com>,
        "ctalbott@google.com" <ctalbott@google.com>,
        "mrubin@google.com" <mrubin@google.com>,
        "nauman@google.com" <nauman@google.com>,
        "guijianfeng@cn.fujitsu.com" <guijianfeng@cn.fujitsu.com>,
        "czoccolo@gmail.com" <czoccolo@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cfq-iosched: Always provide group isolation.
References: <1299006798-11769-1-git-send-email-teravest@google.com> <20110301192937.GC2539@redhat.com>
X-ASG-Orig-Subj: Re: [PATCH] cfq-iosched: Always provide group isolation.
In-Reply-To: <20110301192937.GC2539@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1299009165
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.56767
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-01 14:29, Vivek Goyal wrote:
> On Tue, Mar 01, 2011 at 11:13:18AM -0800, Justin TerAvest wrote:
>> Effectively, make group_isolation=1 the default and remove the tunable.
>> The setting group_isolation=0 was because by default we idle on
>> sync-noidle tree and on fast devices, this can be very harmful for
>> throughput.
>>
>> However, this problem can also be addressed by tuning slice_idle and
>> possibly group_idle on faster storage devices.
>>
>> This change simplifies the CFQ code by removing the feature entirely.
> 
> I have not come across anybody so far who wants to get isolation only
> for sequential queues and not for random cfq queues, hence I think
> it makes sense to remove this tunable to reduce the complexity.
> 
> Secondly, on faster devices if idling hurts, I think disabling idling
> is the only solution and that will either reduce or wipe out any
> service differentiation one was getting.
> 
> So I am fine with removing this tunable. Anyobdy else has got a use
> case for this?

It arguably should never have been added. We need to be more careful in
the future about adding tunables like this. Basically nobody ever
touches them, even if how to use them are described in detail. I'd argue
that this group_isolation was probably only ever used when it was added
and testing was done.

> Jens, do we have to worry about ABI regarding this sysfs tunable?

No, tunables like this have come and gone before. So we can kill this
for .39, I'll queue it up.


-- 
Jens Axboe

