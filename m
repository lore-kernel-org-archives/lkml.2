Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab2DBWUP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 18:20:15 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:43513 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752549Ab2DBWUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 18:20:13 -0400
Message-ID: <4F7A261A.9000200@tao.ma>
Date: Tue, 03 Apr 2012 06:20:10 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: axboe@kernel.dk, vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: [PATCH 18/21] blkcg: move blkio_group_conf->weight to cfq
References: <1332975091-10950-1-git-send-email-tj@kernel.org> <1332975091-10950-19-git-send-email-tj@kernel.org> <4F7A1C8B.3010402@tao.ma> <20120402214938.GA19634@dhcp-172-17-108-109.mtv.corp.google.com> <4F7A2217.2030201@tao.ma> <20120402221702.GA21017@dhcp-172-17-108-109.mtv.corp.google.com>
In-Reply-To: <20120402221702.GA21017@dhcp-172-17-108-109.mtv.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 50.1.53.2 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2012 06:17 AM, Tejun Heo wrote:
> On Tue, Apr 03, 2012 at 06:03:03AM +0800, Tao Ma wrote:
>> Currently weight is just used to calculate the time slice of different
>> cfq group, right? So why can't it be used to indicate other weight? So
>> say, if we are just want to use iops to indicate the difference between
>> different cgroups(100 weight vs 200 weight), so one process will send
>> 100 ios while the other will send 200 ios just for example.
> 
> Because it's configuring stuff which is completely unrelated.  Let's
> say you added a new elevator w/ iops based proportional IO which
> shares blkio.weight configuration with cfq but nothing else and in
> turn your new thing would probably need some other config parameters
> which don't make much sense for cfq, right?
> 
> Now, let's say there's a system which has two hard drives and sda is
> using cfq and sdb is using your new elevator and you're trying to
> configure cgroup blkio limits.  Now, you have blkio.weight which
> applies to both elevators and other configurations which aren't and
> from the looks of it there's no way to tell which configuration
> controls what.
> 
> It also makes the configuration implementation hairier.  We'll need
> callbacks from blkcg core layer to all policies to notify changes to
> per-cgroup configuration and from there policies would have to decide
> whether it has overriding per-cgroup-device configuration.  It's not
> even clear we even want per-cgroup configuration.  blk-throttle only
> has per-cgroup-device configuration after all.
Fair enough.
> 
> So, again, no.  blkcg.weight isn't and won't be generic.
> 
>> We will need a new iops_weight in your option to be exported?
> 
> Yeah, just add config and stat files prefixed with the name of the new
> blkcg policy.
OK, I will add a new config file for it.

Thanks
Tao
