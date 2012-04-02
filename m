Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab2DBWDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 18:03:09 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:33950 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751291Ab2DBWDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 18:03:07 -0400
Message-ID: <4F7A2217.2030201@tao.ma>
Date: Tue, 03 Apr 2012 06:03:03 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: axboe@kernel.dk, vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: [PATCH 18/21] blkcg: move blkio_group_conf->weight to cfq
References: <1332975091-10950-1-git-send-email-tj@kernel.org> <1332975091-10950-19-git-send-email-tj@kernel.org> <4F7A1C8B.3010402@tao.ma> <20120402214938.GA19634@dhcp-172-17-108-109.mtv.corp.google.com>
In-Reply-To: <20120402214938.GA19634@dhcp-172-17-108-109.mtv.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 50.1.53.2 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2012 05:49 AM, Tejun Heo wrote:
> Hello,
> 
> On Tue, Apr 03, 2012 at 05:39:23AM +0800, Tao Ma wrote:
>> I guess blkio->weight is a generic way of abstracting the weight between
>> different block cgroups.
> 
> It isn't and can't be.  There's nothing generic about it across
> different policies and it's not even clear what that means.  If the
> user chooses combine, iops limit with cfq weights, what the hell is
> "generic" about that weight?
> 
>> Yes, currently, only cfq uses it, but I am
>> trying to improve Shaohua's original fiops scheduler and add cgroup
>> support to it. So please leave it there so that future scheduler(if
>> other than the fiops scheduler) can use the framework.
> 
> So, if you want to implement a new blkcg policy, add the config
> parameters and export the stats the policy wants *yourself*.  Not
> having clear separation between policies and generic stuff was what
> led us to this yucky mess and there's no way we're going back there.
> So, NO.
Currently weight is just used to calculate the time slice of different
cfq group, right? So why can't it be used to indicate other weight? So
say, if we are just want to use iops to indicate the difference between
different cgroups(100 weight vs 200 weight), so one process will send
100 ios while the other will send 200 ios just for example. We will need
a new iops_weight in your option to be exported?

Thanks
Tao
