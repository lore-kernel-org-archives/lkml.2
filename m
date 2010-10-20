Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282Ab0JTIhP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 04:37:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:48807 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045Ab0JTIhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 04:37:12 -0400
Message-ID: <4CBEAA2F.6000009@kernel.org>
Date: Wed, 20 Oct 2010 10:37:03 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Ralph Campbell <ralph.campbell@qlogic.com>
CC: Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2.6.36-rc7] infiniband: update workqueue usage
References: <4CBDB834.2050905@kernel.org> <1287508926.27343.299.camel@chromite.mv.qlogic.com>
In-Reply-To: <1287508926.27343.299.camel@chromite.mv.qlogic.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 20 Oct 2010 08:37:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 10/19/2010 07:22 PM, Ralph Campbell wrote:
> On Tue, 2010-10-19 at 08:24 -0700, Tejun Heo wrote:
> 
>> * qib_cq_wq is a separate singlethread workqueue.  Does the queue
>>   require strict single thread execution ordering?  IOW, does each
>>   work have to be executed in the exact queued order and no two works
>>   should execute in parallel?  Or was the singlethreadedness chosen
>>   just to reduce the number of workers?
> 
> The work functions need to be called in-order and single threaded
> or memory will be freed multiple times and other "bad things".

I see, so they'll need to be converted to alloc_ordered_workqueue()
once -rc1 merge window opens up.  I'll follow up with the conversion.

Thanks.

-- 
tejun
