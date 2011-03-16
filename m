Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab1CPC4d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 22:56:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60749 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751391Ab1CPC4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 22:56:32 -0400
Message-ID: <4D802746.3020509@cn.fujitsu.com>
Date: Wed, 16 Mar 2011 10:58:14 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [PATCH V4 1/1] rcu: introduce kfree_rcu()
References: <4D7F356C.8020903@cn.fujitsu.com> <201103151302.09381.arnd@arndb.de> <20110315121941.GD2167@linux.vnet.ibm.com> <201103151407.24800.arnd@arndb.de>
In-Reply-To: <201103151407.24800.arnd@arndb.de>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-16 10:55:10,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-16 10:55:11,
	Serialize complete at 2011-03-16 10:55:11
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2011 09:07 PM, Arnd Bergmann wrote:
> On Tuesday 15 March 2011, Paul E. McKenney wrote:
>> And it makes use of statically allocated structures a bit clunky.
> 
> How do statically allocated structures relate to this? I would
> expect that you never call kfree_rcu on them, so it shouldn't
> matter.
> 
>> Yet another approach is to use the low-order bit of the rcu_head pointer,
>> given that the rcu_head structure does have to be aligned.  If this bit
>> is set, then the function pointer could be interpreted as an offset.
>> This approach might also allow a slab_free_rcu() to be constructed, given
>> that the full 32 bits of the function pointer would be available.
>> For example, if the upper 16 bits are zero, the low-order 16 bits are
>> the offset.  If the upper 16 bits are 0x1, then the low-order 16 bits
>> might be an index that selects the desired slab cache.
> 
> This solution sounds like a clear improvement over the patch that Lai
> Jiangshan posted, without any downsides.
> 

This solution is good, but it changes too much code, I think we will switch to
this solution until my posted solution can't work under some real bad situation
happened.
