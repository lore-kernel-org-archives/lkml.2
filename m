Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881Ab0KSQnO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 11:43:14 -0500
Received: from novprvoes0310.provo.novell.com ([137.65.248.74]:58756 "EHLO
	novprvoes0310.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754621Ab0KSQnN convert rfc822-to-8bit
	(ORCPT <rfc822;groupwise-ghaskins@novell.com:3:2>);
	Fri, 19 Nov 2010 11:43:13 -0500
X-Greylist: delayed 1202 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Nov 2010 11:43:12 EST
Message-Id: <4CE65E1B0200005A00076E72@novprvoes0310.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Fri, 19 Nov 2010 09:23:07 -0700
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Michael S. Tsirkin" <mst@redhat.com>,
        "Marcelo Tosatti" <mtosatti@redhat.com>
Cc: "Xiao Guangrong" <xiaoguangrong@cn.fujitsu.com>,
        "Avi Kivity" <avi@redhat.com>,
        "Chris Lalancette" <clalance@redhat.com>,
        "Gleb Natapov" <gleb@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kvm: fast-path msi injection with irqfd
References: <20101118170907.GA14039@redhat.com>
 <20101119155427.GA20279@amt.cnet>
In-Reply-To: <20101119155427.GA20279@amt.cnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 11/19/2010 at 10:54 AM, in message <20101119155427.GA20279@amt.cnet>,
Marcelo Tosatti <mtosatti@redhat.com> wrote: 
> On Thu, Nov 18, 2010 at 07:09:08PM +0200, Michael S. Tsirkin wrote:
>> Store irq routing table pointer in the irqfd object,
>> and use that to inject MSI directly without bouncing out to
>> a kernel thread.
>> 
>> While we touch this structure, rearrange irqfd fields to make fastpath
>> better packed for better cache utilization.
>> 
>> This also adds some comments about locking rules and rcu usage in code.
>> 
>> Some notes on the design:
>> - Use pointer into the rt instead of copying an entry,
>>   to make it possible to use rcu, thus side-stepping
>>   locking complexities.  We also save some memory this way.
>> - Old workqueue code is still used for level irqs.
>>   I don't think we DTRT with level anyway, however,
>>   it seems easier to keep the code around as
>>   it has been thought through and debugged, and fix level later than
>>   rip out and re-instate it later.
>> 
>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>> ---
>> 
>> OK, this seems to work fine for me. Tested with virtio-net in guest
>> with and without vhost-net.  Pls review/apply if appropriate.
> 
> Acked-by: Marcelo Tosatti <mtosatti@redhat.com>

Acked-by: Gregory Haskins <ghaskins@novell.com>



