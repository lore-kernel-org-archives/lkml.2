Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460Ab2ISQfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 12:35:21 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42450 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093Ab2ISQfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 12:35:18 -0400
Message-ID: <5059F458.3000407@gmail.com>
Date: Wed, 19 Sep 2012 18:35:36 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120902 Thunderbird/15.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: RCU idle CPU detection is broken in linux-next
References: <5050CCE0.4090403@gmail.com> <20120919153934.GB2455@linux.vnet.ibm.com>
In-Reply-To: <20120919153934.GB2455@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2012 05:39 PM, Paul E. McKenney wrote:
> On Wed, Sep 12, 2012 at 07:56:48PM +0200, Sasha Levin wrote:
>> > Hi Paul,
>> > 
>> > While fuzzing using trinity inside a KVM tools guest, I've managed to trigger
>> > "RCU used illegally from idle CPU!" warnings several times.
>> > 
>> > There are a bunch of traces which seem to pop exactly at the same time and from
>> > different places around the kernel. Here are several of them:
> Hello, Sasha,
> 
> OK, interesting.  Could you please try reproducing with the diagnostic
> patch shown below?

Sure - here are the results (btw, it reproduces very easily):

[ 13.525119] ================================================
[ 13.527165] [ BUG: lock held when returning to user space! ]
[ 13.528752] 3.6.0-rc6-next-20120918-sasha-00002-g190c311-dirty #362 Tainted: GW
[ 13.531314] ------------------------------------------------
[ 13.532918] init/1 is leaving the kernel with locks still held!
[ 13.534574] 1 lock held by init/1:
[ 13.535533] #0: (rcu_idle){.+.+..}, at: [<ffffffff811c36d0>]
rcu_eqs_enter_common+0x1a0/0x9a0

I'm basically seeing lots of the above, so I can't even get to the point where I
get the previous lockdep warnings.
