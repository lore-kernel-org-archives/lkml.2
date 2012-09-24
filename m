Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750990Ab2IXV3K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 17:29:10 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:56229 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab2IXV3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 17:29:08 -0400
MIME-Version: 1.0
In-Reply-To: <505EA09B.6040105@gmail.com>
References: <20120921121346.GD2458@linux.vnet.ibm.com>
	<505C6B03.7020305@gmail.com>
	<20120921151203.GA2454@linux.vnet.ibm.com>
	<505C855F.3060301@gmail.com>
	<505D7621.4040505@gmail.com>
	<20120922150913.GA2934@linux.vnet.ibm.com>
	<505DDBE7.7010706@gmail.com>
	<20120922155613.GB2934@linux.vnet.ibm.com>
	<505DFA65.3080805@gmail.com>
	<20120922212735.GG2934@linux.vnet.ibm.com>
	<20120923002105.GA1112@linux.vnet.ibm.com>
	<505EA09B.6040105@gmail.com>
Date: Mon, 24 Sep 2012 23:29:07 +0200
Message-ID: <CAFTL4hwqzS8iO2zOOGaizzMtT85MJExTxEgGbponJ4_gfv0nwA@mail.gmail.com>
Subject: Re: RCU idle CPU detection is broken in linux-next
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: paulmck@linux.vnet.ibm.com, Michael Wang <wangyun@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/23 Sasha Levin <levinsasha928@gmail.com>:
> On 09/23/2012 02:21 AM, Paul E. McKenney wrote:
>> On Sat, Sep 22, 2012 at 02:27:35PM -0700, Paul E. McKenney wrote:
>>> On Sat, Sep 22, 2012 at 07:50:29PM +0200, Sasha Levin wrote:
>>>> On 09/22/2012 05:56 PM, Paul E. McKenney wrote:
>>>>> And now the prime suspect is the new CONFIG_RCU_USER_QS=y.  Do these
>>>>> warnings ever show up with CONFIG_RCU_USER_QS=n?
>>>>
>>>> It seems that disabling that does make the warnings go away.
>>>>
>>>> I'll keep the tests running in case it just reduces the chances or something
>>>> like that.
>>>
>>> Thank you for testing this!
>>>
>>> And of course the reason that I didn't see these problems is that I
>>> failed to update my tests to enable CONFIG_RCU_USER_QS.  :-/
>>
>> Also the fact that I run 32-bit guests on x86.  Sigh!
>>
>> I take it that you are running 64-bit guests?
>
> Yes, that's correct.

Sasha,

Can you please test the following branch:

git://github.com/fweisbec/linux-dynticks.git  rcu/idle-for-v3.7-take3

with CONFIG_RCU_USER_QS and CONFIG_RCU_USER_QS_FORCE enabled.

I hope this fixes the warning.
The changes are:

* add "x86: Unspaghettize do_general_protection()"
* updated "x86: Exception hooks for userspace RCU extended QS" to
handle some missed trap handlers. Especially do_general_protection()
because I can see the problem triggered there in Sasha's warnings. I
fixed more handlers in the way.

Thanks.
