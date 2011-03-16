Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422Ab1CPCWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 22:22:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59194 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751006Ab1CPCWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 22:22:12 -0400
Message-ID: <4D801F3A.4000303@cn.fujitsu.com>
Date: Wed, 16 Mar 2011 10:23:54 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [PATCH V4 1/1] rcu: introduce kfree_rcu()
References: <4D7F356C.8020903@cn.fujitsu.com> <201103151115.54426.arnd@arndb.de>
In-Reply-To: <201103151115.54426.arnd@arndb.de>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-16 10:20:50,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-16 10:20:50,
	Serialize complete at 2011-03-16 10:20:50
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2011 06:15 PM, Arnd Bergmann wrote:
> On Tuesday 15 March 2011 10:46:20 Lai Jiangshan wrote:
>> +static __always_inline bool __is_kfree_rcu_offset(unsigned long offset)
>> +{
>> +       return offset < 4096;
>> +}
> 
> So this relies on the assumptions that 
> 
> a) the rcu_head is within the first 4 KB of the data structure to be freed
> b) no callback ever gets called in the first 4 KB of virtual address space
> 
> It's probably a reasonable assumption, but I think it should be documented
> more explicitly, especially the first one. It's entirely possible that
> an RCU managed data structure is larger than 4 KB.

The first one is not a problem nor assumption, if an rcu_head offset is larger
than 4096, the BUILD_BUG_ON() will be triggered, and the user can use the original
call_rcu() instead.

b) is not a problem, the TEXT section is no at the first 4 KB of virtual address space.

> Another alternative might be to encode the difference between a
> function pointer and an offset in one of the lower bits of the address.
> 
> 	Arnd
> 

