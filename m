Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab2E3Oj6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 10:39:58 -0400
Received: from mail.datadirectnet.com ([74.62.46.229]:7999 "EHLO
	mail.datadirectnet.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755272Ab2E3Oju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 10:39:50 -0400
Message-ID: <4FC63132.60609@ddn.com>
Date: Wed, 30 May 2012 10:39:46 -0400
From: Karandeep Chahal <kchahal@ddn.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: David Dillow <dillowda@ornl.gov>
CC: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "roland@kernel.org" <roland@kernel.org>,
        "sean.hefty@intel.com" <sean.hefty@intel.com>
Subject: Re: [PATCH 1/1] ib_srp: Infiniband srp fast failover patch.
References: <4FC53AAA.3060203@ddn.com> <1338354377.2361.13.camel@obelisk.thedillows.org>
In-Reply-To: <1338354377.2361.13.camel@obelisk.thedillows.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

As long as we get faster failover I am happy with Bart's patch.

Currently when I run IO to several luns over multipath and the preferred 
path goes down, the system hangs until the IO fails over. Even ssh'ing 
into the systems take 20-30 seconds. I *suspect* that is because IO is 
being queued up somewhere which brings the whole system to its knees.

Thank you for looking at the patch.

Thanks
Karan

On 05/30/2012 01:06 AM, David Dillow wrote:
> On Tue, 2012-05-29 at 17:07 -0400, Karandeep Chahal wrote:
>> Subject: [PATCH] Infiniband srp fast failover patch.
> This conflicts with Bart's patches to improve failover; it will be much
> better to use his approach to block the target rather than remove it
> wholesale -- we could have lost connectivity as a transient and may get
> it back quickly if someone grabbed the wrong cable, etc.
>
> Also, we should only kill the one target on DREQ, and we already have a
> pointer to it from the CM context -- no need to search.
>
> It is a good idea to hook into the event mechanism; this is something
> I've long wanted to incorporate (as Vu did in OFED). I'm looking at
> getting Bart's series to a point I can merge it, and I'll pull in your
> ideas -- with credit -- there.
>
> Thanks,
