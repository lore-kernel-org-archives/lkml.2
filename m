Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553Ab2DBWll (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 18:41:41 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:43131 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752243Ab2DBWlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 18:41:40 -0400
Message-ID: <4F7A2B21.5000907@tao.ma>
Date: Tue, 03 Apr 2012 06:41:37 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Tejun Heo <tj@kernel.org>, axboe@kernel.dk, ctalbott@google.com,
        rni@google.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: [PATCH 18/21] blkcg: move blkio_group_conf->weight to cfq
References: <1332975091-10950-1-git-send-email-tj@kernel.org> <1332975091-10950-19-git-send-email-tj@kernel.org> <4F7A1C8B.3010402@tao.ma> <20120402214938.GA19634@dhcp-172-17-108-109.mtv.corp.google.com> <4F7A2217.2030201@tao.ma> <20120402221702.GA21017@dhcp-172-17-108-109.mtv.corp.google.com> <4F7A261A.9000200@tao.ma> <20120402222504.GA2672@redhat.com>
In-Reply-To: <20120402222504.GA2672@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 50.1.53.34 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2012 06:25 AM, Vivek Goyal wrote:
> On Tue, Apr 03, 2012 at 06:20:10AM +0800, Tao Ma wrote:
> 
> [..]
>>> Yeah, just add config and stat files prefixed with the name of the new
>>> blkcg policy.
>> OK, I will add a new config file for it.
> 
> Only if CFQ could be modified to add one iops mode, flippable through a
> sysfs tunable, things will be much simpler. You will not have to add a
> new IO scheduler, no new configuration/stat files in blkcg (which is
> already crowded now).
> 
> I don't think anybody has shown the code that why CFQ can't be modified
> to support iops mode.
Yes, I have thought of it, but it seems to me that time slice is deeply
involved within the cfq(even current cfq's iops mode has used time slice
to calculate). So I don't think it is feasible for me to change it. And
cfq works perfectly well for sas/sata environment and the code is quite
stable, more codes and more complicate algorithm does mean more bugs. So
I guess a new iops based scheduler is easy and not intrusive for the
user(since he can choose whether to use it or not).

Thanks
Tao
