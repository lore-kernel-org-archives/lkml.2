Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122Ab1FJKAp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 06:00:45 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:46704 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754330Ab1FJKAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 06:00:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=tao.ma;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=HaDixFH2+jq1x6GhzXfb6NlvBmcxRB+M4Tp3deaCWvSSDgxcdowfFSU9n1tTk6DBrWgSiGL1g5qvaGi9tml8i3bo1YT0jUZxJoLvZVl9mWIc8DtlNMmXf+v9ItjivXku;
Message-ID: <4DF1EB45.1070706@tao.ma>
Date: Fri, 10 Jun 2011 18:00:37 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: CFQ: async queue blocks the whole system
References: <1307616577-6101-1-git-send-email-tm@tao.ma> <20110609141451.GD29913@redhat.com> <4DF0DD0F.8090407@tao.ma> <20110609153738.GF29913@redhat.com> <4DF0EA55.10209@tao.ma> <20110609182706.GG29913@redhat.com> <4DF1B035.7080009@tao.ma> <20110610091427.GB4183@redhat.com>
In-Reply-To: <20110610091427.GB4183@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 114.251.86.0 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2011 05:14 PM, Vivek Goyal wrote:
> On Fri, Jun 10, 2011 at 01:48:37PM +0800, Tao Ma wrote:
> 
> [..]
>>>> btw, reverting the patch doesn't work. I can still get the livelock.
> 
> What test exactly you are running. I am primarily interested in whether
> you still get the hung task timeout warning where a writer is waiting on
> get_request_wait() for more than 120 secods or not.
> 
> Livelock might be a different problem and for which Christoph provided
> a patch for XFS.
> 
>>>
>>> Can you give following patch a try and see if it helps. On my system this
>>> does allow CFQ to dispatch some writes once in a while.
>> Sorry, this patch doesn't work in my test.
> 
> Can you give me backtrace of say 15 seconds each with and without patch.
> I think now we must be dispatching some writes, that's a different thing
> that writer still sleeps more than 120 seconds because there are  way
> too many readers.
> 
> May be we need to look into show workload tree scheduling takes place and
> tweak that logic a bit.
OK, our test cases can be downloaded for free. ;)
svn co http://code.taobao.org/svn/dirbench/trunk/meta_test/press/set_vs_get
Modify run.sh to be fit for your need. Normally within 10 mins, you will
get the livelock. We have a SAS disk with 15000 RPMs.

btw, you have to mount the volume on /test since the test program are
not that clever. :)

Regards,
Tao
