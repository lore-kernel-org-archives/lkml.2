Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab1FNPmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 11:42:35 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:55583 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751671Ab1FNPmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 11:42:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=tao.ma;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=cz6FnRadFh2Xy5jXwl+bEG0ayeUJUOATK8LjtS6e8PVgOY/GvXLazaQxcQJVwwGeVHQWG51y+Nwt1owHZEWZYU6AIWtFxOE1fPn11m+UvaxhDGWqZBMzy29xV0gJxIky;
Message-ID: <4DF78157.6020907@tao.ma>
Date: Tue, 14 Jun 2011 23:42:15 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: CFQ: async queue blocks the whole system
References: <20110609153738.GF29913@redhat.com> <4DF0EA55.10209@tao.ma> <20110609182706.GG29913@redhat.com> <4DF1B035.7080009@tao.ma> <20110610091427.GB4183@redhat.com> <4DF1EB45.1070706@tao.ma> <20110610154414.GA31853@redhat.com> <4DF5E1A8.7080100@tao.ma> <20110613214154.GL633@redhat.com> <4DF707BC.20007@tao.ma> <20110614133047.GA2525@redhat.com>
In-Reply-To: <20110614133047.GA2525@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 114.245.229.25 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2011 09:30 PM, Vivek Goyal wrote:
> On Tue, Jun 14, 2011 at 03:03:24PM +0800, Tao Ma wrote:
>> Hi Vivek,
>> On 06/14/2011 05:41 AM, Vivek Goyal wrote:
>>> On Mon, Jun 13, 2011 at 06:08:40PM +0800, Tao Ma wrote:
>>>
>>> [..]
>>>>> You can also run iostat on disk and should be able to see that with
>>>>> the patch you are dispatching writes more often than before.
>>>> Sorry, the patch doesn't work.
>>>>
>>>> I used trace event to capture all the blktraces since it doesn't
>>>> interfere with the tests, hope it helps.
>>>
>>> Actually I was looking for CFQ traces. This seems to be generic block
>>> layer trace points. May be you can use "blktrace -d /dev/<device>"
>>> and then blkparse. It also gives the aggregate view which is helpful.
>>>
>>>>
>>>> Please downloaded it from http://blog.coly.li/tmp/blktrace.tar.bz2
>>>
>>> What concerns me is following.
>>>
>>> 5255.521353: block_rq_issue: 8,0 W 0 () 571137153 + 8 [attr_set]
>>> 5578.863871: block_rq_issue: 8,0 W 0 () 512950473 + 48 [kworker/0:1]
>>>
>>> IIUC, we dispatched second write more than 300 seconds after dispatching
>>> 1 write. What happened in between. We should have dispatched more writes.
>>>
>>> CFQ traces might give better idea in terms of whether wl_type for async
>>> queues was scheduled or not at all.
>> I tried several times today, but it looks like that if I enable
>> blktrace, the hung_task will not show up in the message. So do you think
>> the blktrace at that time is still useful? If yes, I can capture 1
>> minute for you. Thanks.
> 
> Capturing 1 min output will also be good. 
OK, I captured 2 mins blkparse log before the hung. You can downloaded
it from http://blog.coly.li/tmp/blkparse.tar.bz2

> 
> You can do one more thing. Mount block IO controller. It has the stats for
> sync and async dispatch (blkio.io_serviced or blkio.io_service_bytes). You
> can write a simple script to read and print these files every few seconds.
> That will also tell whether CFQ is dispatching async requests for the 
> said device regularly or not.
OK, I will try block IO controller tomorrow to see whether we can find
some useful info. Anyway, thanks for the diagnose.

Thanks
Tao
