Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803Ab1EXJlQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 05:41:16 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:55019 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755582Ab1EXJlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 05:41:14 -0400
X-ASG-Debug-ID: 1306230073-01de28096b5fd40001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DDB7D36.60905@fusionio.com>
Date: Tue, 24 May 2011 11:41:10 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Mysterious CFQ crash and RCU
References: <20110519222404.GG12600@redhat.com>	 <20110521210013.GJ2271@linux.vnet.ibm.com>	 <20110523152141.GB4019@redhat.com>	 <20110523153848.GC2310@linux.vnet.ibm.com> <1306189249.15900.10.camel@t41.thuisdomein>
X-ASG-Orig-Subj: Re: Mysterious CFQ crash and RCU
In-Reply-To: <1306189249.15900.10.camel@t41.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1306230073
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.64657
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-24 00:20, Paul Bolle wrote:
> On Mon, 2011-05-23 at 08:38 -0700, Paul E. McKenney wrote:
>> Running under CONFIG_PREEMPT=y (along with CONFIG_TREE_PREEMPT_RCU=y)
>> could be very helpful in and of itself.  CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
>> can also be helpful.  In post-2.6.39 mainline, it should be possible
>> to set CONFIG_DEBUG_OBJECTS_RCU_HEAD=y without CONFIG_PREEMPT=y, but
>> again, CONFIG_PREEMPT=y can help find problems.
> 
> 0) The first thing I tried (from your suggestions) was
> CONFIG_DEBUG_OBJECTS_RCU_HEAD=y. Given its dependencies (and, well, the
> build system I used) I ended up with:
> 
>     $ grep -e PREEMPT -e RCU /boot/config-2.6.39-0.local3.fc16.i686 |
>     grep -v "^#"
>     CONFIG_TREE_PREEMPT_RCU=y
>     CONFIG_PREEMPT_RCU=y
>     CONFIG_RCU_FANOUT=32
>     CONFIG_PREEMPT_NOTIFIERS=y
>     CONFIG_PREEMPT=y
>     CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
>     CONFIG_DEBUG_PREEMPT=y
>     CONFIG_PROVE_RCU=y
>     CONFIG_SPARSE_RCU_POINTER=y
> 
> It looks like I am unable to trigger the issue we're talking about here
> when using that config.
> 
> 1) For reference, the config of a kernel that does trigger it had:
> 
>     $ grep -e PREEMPT -e RCU /boot/config-2.6.39-0.local2.fc16.i686 |
>     grep -v "^#"
>     CONFIG_TREE_RCU=y
>     CONFIG_RCU_FANOUT=32
>     CONFIG_RCU_FAST_NO_HZ=y
>     CONFIG_PREEMPT_NOTIFIERS=y
>     CONFIG_PREEMPT_VOLUNTARY=y
>     CONFIG_PROVE_RCU=y
>     CONFIG_SPARSE_RCU_POINTER=y
> 
>>> Again CONFIG_TREE_PREEMPT_RCU is available only if PREEMPT=y. So should
>>> we enable preemtion and CONFIG_TREE_PREEMPT_RCU=y and try to reproduce
>>> the issue?
>>
>> Please!
> 
> 2) It appears I can't reproduce with those options enabled (see above).
> 
>> Polling is fine.  Please see attached for a script to poll at 15-second
>> intervals.  Please also feel free to adjust, just tell me what you
>> adjusted.
> 
> And should I now try to run that script on a config that triggers this
> issue (such as the config under 1) above)?

Paul, can we see a dmesg from your running system? Perhaps there's some
dependency on a particular driver or device that makes this easier to
reproduce.

-- 
Jens Axboe

