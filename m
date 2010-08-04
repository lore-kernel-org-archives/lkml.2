Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195Ab0HDOgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 10:36:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757588Ab0HDOgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 10:36:11 -0400
Message-ID: <4C5979E8.2080302@ds.jp.nec.com>
Date: Wed, 04 Aug 2010 10:32:08 -0400
From: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Nauman Rafique <nauman@google.com>
CC: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
        Ryo Tsuruta <ryov@valinux.co.jp>, taka@valinux.co.jp,
        kamezawa.hiroyu@jp.fujitsu.com, Andrea Righi <righi.andrea@gmail.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>, akpm@linux-foundation.org,
        balbir@linux.vnet.ibm.com
Subject: Re: [RFC][PATCH 00/11] blkiocg async support
References: <4C369009.80503@ds.jp.nec.com> <20100802205834.GD24697@redhat.com> 	<4C582845.6070408@ds.jp.nec.com> <AANLkTikrvWLxrbLavPqk4NkY4YieRW1q6QBv2_n7ASeS@mail.gmail.com>
In-Reply-To: <AANLkTikrvWLxrbLavPqk4NkY4YieRW1q6QBv2_n7ASeS@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nauman Rafique wrote, on 08/03/2010 03:24 PM:
> On Tue, Aug 3, 2010 at 7:31 AM, Munehiro Ikeda<m-ikeda@ds.jp.nec.com>  wrote:
>> Vivek Goyal wrote, on 08/02/2010 04:58 PM:
>>> You will require one more piece and that is support for per cgroup request
>>> descriptors on request queue. With writes, it is so easy to consume those
>>> 128 request descriptors.
>>
>> Hi Vivek,
>>
>> Yes.  Thank you for the comment.
>> I have two concerns to do that.
>>
>> (1) technical concern
>> If there is fixed device-wide limitation and there are so many groups,
>> the number of request descriptors distributed to each group can be too
>> few.  My only idea for this is to make device-wide limitation flexible,
>> but I'm not sure if it is the best or even can be allowed.
>>
>> (2) implementation concern
>> Now the limitation is done by generic block layer which doesn't know
>> about grouping.  The idea in my head to solve this is to add a new
>> interface on elevator_ops to ask IO scheduler if a new request can
>> be allocated.
>
> Muuhh,
> We have already done the work of forward porting the request
> descriptor patch that Vivek had in his earlier patch sets. We also
> taken care of the two concerns you have mentioned above. We have been
> testing it, and getting good numbers. So if you want, I can send the
> patch your way so it can be included in this same patch series.
>
> Thanks.

Hi Nauman,

It is the patch that I'm thinking we should be based on.  You have
already done the forward porting, great!
Please post it to LKML, container-list etc. independently if you don't
mind.  I appreciate your suggestion to include it into my patch
series, but I'm worrying about that the patch set becomes larger
beyond my poor antique brain processor.
The issue of request limitation may be significant when async write is
supported, but I don't think it is limited to it.  It should be
beneficial for current blkio controller.
And we can combine them after independent posts if needed.


Thanks a lot,
Muuhh

-- 
IKEDA, Munehiro
   NEC Corporation of America
     m-ikeda@ds.jp.nec.com

