Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab0FYJXg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 05:23:36 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:55045 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab0FYJXf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 05:23:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MfNZju1oIItYNduFHdKlM59zNk3zakEv9ZcxEq8Ku40d3JAI758WBUH+IibUTJF1Ej
         hfv89bl7x2yeby4hCNVvwgkg5bVzk2Y1upQOuPmlj/eSQra7/X1PmZ1g+4eDtmSeT4lS
         0kHEc7S+PSWbXtxih0It6dNFCZpbmkUJjz608=
MIME-Version: 1.0
In-Reply-To: <1277457439.3947.184.camel@yhuang-dev.sh.intel.com>
References: <1277348698-17311-1-git-send-email-ying.huang@intel.com>
	<1277361352.1875.838.camel@laptop>
	<1277431963.3947.140.camel@yhuang-dev.sh.intel.com>
	<1277452110.22715.2116.camel@twins>
	<1277457439.3947.184.camel@yhuang-dev.sh.intel.com>
Date: Fri, 25 Jun 2010 11:23:33 +0200
Message-ID: <AANLkTikEpj6EkJJ2dWs12JiODF8pl4foYq_AZtzxP2ef@mail.gmail.com>
Subject: Re: [RFC][PATCH] irq_work
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "H.PeterA" <"nvin hpa"@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/25 Huang Ying <ying.huang@intel.com>:
> On Fri, 2010-06-25 at 15:48 +0800, Peter Zijlstra wrote:
>> On Fri, 2010-06-25 at 10:12 +0800, Huang Ying wrote:
>> >
>> > It is better to add "void *data" field in this struct to allow same
>> > function can be used for multiple struct irq_work.
>>
>> No, simply do:
>>
>> struct my_foo {
>>   struct irq_work work;
>>   /* my extra data */
>> }
>>
>> void my_func(struct irq_work *work)
>> {
>>   struct my_foo *foo = container_of(work, struct my_foo, work);
>>
>>   /* tada! */
>> }
>
> Yes. This works too. But Adding "void *data" field is helpful if you do
> not embed struct irq_work into another struct.



That's what makes most sense. If you use work->data to put foo, then
you can also do the opposite. Now the best is to pick the choice that
gives you a real type and a typechecking, and not an error-prone and
obfuscated void *

This is the way things are made in the kernel. struct work_struct, struct list,
struct rcu_head, etc... are all embedded into a container, so that we can
use container_of.
