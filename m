Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758845Ab2EVOoW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 10:44:22 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:37095 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757763Ab2EVOoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 10:44:20 -0400
Message-ID: <4FBBA63B.1090401@tao.ma>
Date: Tue, 22 May 2012 22:44:11 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC] block/throttle: Add IO throttled information in blkcg.
References: <1337674236-2896-1-git-send-email-tm@tao.ma> <20120522111111.GE3045@redhat.com>
In-Reply-To: <20120522111111.GE3045@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 111.193.1.250 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,
	Thanks for the quick response.
On 05/22/2012 07:11 PM, Vivek Goyal wrote:
> On Tue, May 22, 2012 at 04:10:36PM +0800, Tao Ma wrote:
>> From: Tao Ma <boyu.mt@taobao.com>
>>
>> Currently, if the IO is throttled by io-throttle, the SA has no idea of
>> the situation and can't report it to the real application user about
>> that he/she has to do something. So this patch adds a new interface
>> named blkio.throttle.io_throttled which indicates how many IOs are
>> currently throttled.
> 
> If the only purpose is to know whether IOs are being throttled, why
> not just scan for the rules and see if respective device has any
> throttling rules or not.
Sorry, but setting a throttling rules doesn't mean the IOs are
throttled, right? So scanning doesn't work here IMHO.
> 
> Even if you introduce this interface, you will end up scanning for
> throttled ios against that particular device. And if IO is not happening
> at that moment or if IO rate is not exceeding the rate limit, there
> might not be any throttled ios and one might get misled.
Oh, no actually in a *clound computing* environment, it is really
useful, not misled. So let me describe it in more detail. Our product
system will limit every instance to an approximate number at first, and
then watch out the IOs being throttled. If these numbers is high, it can:
1) Shout loudly to the application programmer about the abuse if he
sends out too much IO requests.
2) If it is not too much and some other instances are not active, adjust
the throttled ratio so that this instance can work much faster.

All these 2 needs to know the throttled status for the cgroup and a
negative feedback is really useful for the elastic control of IO cgroups.
> 
> So for your purpose a better interface sounds like scanning for throttling
> rules instead of this new interface.
Sorry, as I have said above, I don't know how to get the current status
of the throttled IOs.
> 
>>
>> I am not sure whether it is OK to add this information to the generic
>> blkcg since it is only io-throttle related, but I don't find a way to
>> only store it into the blkcg io-throttle. And that's the reason this
>> is only a RFC. Any suggestions? Thanks.
> 
> Tejun has changed the code in this area and new code will allow you to
> introduce this file in blk-throttle.c. All that code is sitting in Jens's
> block tree.
Oh, cool, I will check that. Thanks.

Thanks
Tao
