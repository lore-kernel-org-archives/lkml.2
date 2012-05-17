Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761037Ab2EQDlE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 23:41:04 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:55764 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760596Ab2EQDlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 23:41:02 -0400
Date: Wed, 16 May 2012 23:40:53 -0400 (EDT)
Message-Id: <20120516.234053.248044235713127837.davem@davemloft.net>
To: rusty@rustcorp.com.au
Cc: mst@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio_net: invoke softirqs after __napi_schedule
From: David Miller <davem@davemloft.net>
In-Reply-To: <87vcjvzdlm.fsf@rustcorp.com.au>
References: <20120516075712.GA2921@redhat.com>
	<87vcjvzdlm.fsf@rustcorp.com.au>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 16 May 2012 20:40:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 17 May 2012 13:02:53 +0930

> On Wed, 16 May 2012 10:57:13 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
>> __napi_schedule might raise softirq but nothing
>> causes do_softirq to trigger, so it does not in fact
>> run. As a result,
>> the error message "NOHZ: local_softirq_pending 08"
>> sometimes occurs during boot of a KVM guest when the network service is
>> started and we are oom:
>> 
>>   ...
>>   Bringing up loopback interface:  [  OK  ]
>>   Bringing up interface eth0:
>>   Determining IP information for eth0...NOHZ: local_softirq_pending 08
>>    done.
>>   [  OK  ]
>>   ...
>> 
>> Further, receive queue processing might get delayed
>> indefinitely until some interrupt triggers:
>> virtio_net expected napi to be run immediately.
>> 
>> One way to cause do_softirq to be executed is by
>> invoking local_bh_enable(). As __napi_schedule is
>> normally called from bh or irq context, this
>> seems to make sense: disable bh before __napi_schedule
>> and enable afterwards.
>> 
>> Reported-by: Ulrich Obergfell <uobergfe@redhat.com>
>> Tested-by: Ulrich Obergfell <uobergfe@redhat.com>
>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
 ...
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Michael, you're best to submit this directly to Linus as I just
made what I hope is my last push to him for 3.4 today.
