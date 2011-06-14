Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab1FNHKL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 03:10:11 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:47392 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752869Ab1FNHKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 03:10:09 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Jun 2011 03:10:08 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=tao.ma;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=AKq6qHGtWEKcfrgF6QVCbmKriOOfXhA99M26E/YzvsMs/JS5pq++9opvoWDXG/HK9RDTYhfRKi04RZ/AlMytwKP3eis1UJqTwDls5XT1JUtSc2oRqyctZ3Axu8egWVzx;
Message-ID: <4DF707BC.20007@tao.ma>
Date: Tue, 14 Jun 2011 15:03:24 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: CFQ: async queue blocks the whole system
References: <20110609141451.GD29913@redhat.com> <4DF0DD0F.8090407@tao.ma> <20110609153738.GF29913@redhat.com> <4DF0EA55.10209@tao.ma> <20110609182706.GG29913@redhat.com> <4DF1B035.7080009@tao.ma> <20110610091427.GB4183@redhat.com> <4DF1EB45.1070706@tao.ma> <20110610154414.GA31853@redhat.com> <4DF5E1A8.7080100@tao.ma> <20110613214154.GL633@redhat.com>
In-Reply-To: <20110613214154.GL633@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 114.251.86.0 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,
On 06/14/2011 05:41 AM, Vivek Goyal wrote:
> On Mon, Jun 13, 2011 at 06:08:40PM +0800, Tao Ma wrote:
> 
> [..]
>>> You can also run iostat on disk and should be able to see that with
>>> the patch you are dispatching writes more often than before.
>> Sorry, the patch doesn't work.
>>
>> I used trace event to capture all the blktraces since it doesn't
>> interfere with the tests, hope it helps.
> 
> Actually I was looking for CFQ traces. This seems to be generic block
> layer trace points. May be you can use "blktrace -d /dev/<device>"
> and then blkparse. It also gives the aggregate view which is helpful.
> 
>>
>> Please downloaded it from http://blog.coly.li/tmp/blktrace.tar.bz2
> 
> What concerns me is following.
> 
> 5255.521353: block_rq_issue: 8,0 W 0 () 571137153 + 8 [attr_set]
> 5578.863871: block_rq_issue: 8,0 W 0 () 512950473 + 48 [kworker/0:1]
> 
> IIUC, we dispatched second write more than 300 seconds after dispatching
> 1 write. What happened in between. We should have dispatched more writes.
> 
> CFQ traces might give better idea in terms of whether wl_type for async
> queues was scheduled or not at all.
I tried several times today, but it looks like that if I enable
blktrace, the hung_task will not show up in the message. So do you think
the blktrace at that time is still useful? If yes, I can capture 1
minute for you. Thanks.

Regards,
Tao
