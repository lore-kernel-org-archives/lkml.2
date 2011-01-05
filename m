Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314Ab1AEBaE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 20:30:04 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60365 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751141Ab1AEBaC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 20:30:02 -0500
Message-ID: <4D23C9B0.9060803@cn.fujitsu.com>
Date: Wed, 05 Jan 2011 09:30:24 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu: remove SPARSE_RCU_POINTER
References: <4D22DD95.7050308@cn.fujitsu.com> <201101041136.02514.arnd@arndb.de> <20110104211938.GT2026@linux.vnet.ibm.com>
In-Reply-To: <20110104211938.GT2026@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-05 09:29:41,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-05 09:29:42,
	Serialize complete at 2011-01-05 09:29:42
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2011 05:19 AM, Paul E. McKenney wrote:
> On Tue, Jan 04, 2011 at 11:36:02AM +0100, Arnd Bergmann wrote:
>> On Tuesday 04 January 2011 09:43:01 Lai Jiangshan wrote:
>>> As I known, __rcu annotations do not effect the result compiled kernel.
>>>
>>> They work only when we use spare("make C=1" or "make C=2"),
>>> So we don't need another new switch for it since we have one
>>> for debugging(use spare or not).
>>>
>>> signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
>>
>> The intention of this option was to avoid introducing an excessive
>> number of false positives when using sparse.
>>
>> We should only make that unconditional if we are reasonably convinced
>> that all the majority of warnings caused by it should actually
>> lead to changes in the code.
> 
> I agree with Arnd here -- the changes required are extensive in many
> cases, and a number of subsystems are making decent progress.
> 
> 							Thanx, Paul

I also agree. Most guys like to use direct read to the rcu pointer
on update side or direct read/write when initializing the rcu pointer.
This causes a lot of false positives.

Thanks,
Lai

