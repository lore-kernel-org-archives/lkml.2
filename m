Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab2E2WxI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 18:53:08 -0400
Received: from relay3.sgi.com ([192.48.152.1]:58134 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752176Ab2E2WxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 18:53:06 -0400
Message-ID: <4FC55351.6020503@sgi.com>
Date: Tue, 29 May 2012 15:53:05 -0700
From: Michael Reed <mdr@sgi.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Karandeep Chahal <kchahal@ddn.com>
CC: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dillowda@ornl.gov" <dillowda@ornl.gov>,
        "roland@kernel.org" <roland@kernel.org>,
        "sean.hefty@intel.com" <sean.hefty@intel.com>
Subject: Re: [PATCH 1/1] ib_srp: Infiniband srp fast failover patch.
References: <4FC53AAA.3060203@ddn.com> <4FC544FE.3000204@sgi.com> <4FC54D62.3080003@ddn.com>
In-Reply-To: <4FC54D62.3080003@ddn.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for clarifying!

On 05/29/2012 03:27 PM, Karandeep Chahal wrote:
> Hi Michael,
>
> Yes, I tried reconnecting the targets and removing reinserting ib-srp.
>
> Thanks
> Karan
>
>
> On 05/29/2012 05:51 PM, Michael Reed wrote:
>> Did you subsequently reconnect the target and confirm appropriate behavior?
>>
>>
>> On 05/29/2012 02:07 PM, Karandeep Chahal wrote:
>>> Subject: [PATCH] Infiniband srp fast failover patch. Currently ib_srp does
>>>      not do anything on receiving a DREQ from the target, it
>>>      only sends a response back. Further it also does not
>>>      monitor port (down) events. I have patched srp to remove
>>>      scsi devices when a port down event is received or if the
>>>      target sends a DREQ. Currently even though the target
>>>      notifies the initiator of its intentions of going away, the
>>>      initiator ignores that information. Later the initiator
>>>      gets upset when the devices "suddenly" disappear resulting
>>>      in srp initiating an error recovery process which takes a
>>>      long time. This caused high failover latencies as compared
>>>      to fibre channel. In my experiments with RHEL 6.0 and 6.2 I
>>>      encountered failover time that exceeded 2 minutes and 20
>>>      seconds (despite tweaking /etc/multipath.conf and
>>>      /sys/block/<>/timeout). With this patch the failover takes
>>>      30 seconds. I have tested this patch with and without a
>>>      switch.
>>>
>>> Yours, etc.
>>> Karan
>>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
