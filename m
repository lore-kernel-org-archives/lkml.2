Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933256Ab2GYOhw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 10:37:52 -0400
Received: from natasha.panasas.com ([67.152.220.90]:43496 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933148Ab2GYOhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 10:37:51 -0400
Message-ID: <5010047D.6070807@panasas.com>
Date: Wed, 25 Jul 2012 17:36:45 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111113 Thunderbird/8.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Wang Sen <senwang@linux.vnet.ibm.com>, <linux-scsi@vger.kernel.org>,
        <JBottomley@parallels.com>, <stefanha@linux.vnet.ibm.com>,
        <mc@linux.vnet.ibm.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: virtio-scsi: Fix address translation failure of
 HighMem pages used by sg list
References: <1343204966-23560-1-git-send-email-senwang@linux.vnet.ibm.com> <500FB1DE.1000100@redhat.com> <500FBAE8.2050107@panasas.com> <500FBF37.50603@redhat.com> <500FE7D2.7070101@panasas.com> <500FEB63.3000709@redhat.com> <500FF412.3090600@panasas.com> <500FF656.6000203@redhat.com>
In-Reply-To: <500FF656.6000203@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2012 04:36 PM, Paolo Bonzini wrote:

> Il 25/07/2012 15:26, Boaz Harrosh ha scritto:
>> On 07/25/2012 03:49 PM, Paolo Bonzini wrote:
>>
>>>
>>> Except here the destination array has to be given to virtio, which
>>> doesn't (yet) understand chaining.  I'm using for_each_sg rather than a
>>> simple memcpy exactly because I want to flatten the input scatterlist
>>> onto consecutive scatterlist entries, which is what virtio expects (and
>>> what I'll change when I get to it).
>>>
>>> for_each_sg guarantees that I get non-chain scatterlists only, so it is
>>> okay to value-assign them to sg[].
>>
>> So if the virtio does not understand chaining at all then surly it will
>> not understand the 2-bit end marker and will get a wrong page pointer
>> with the 1st bit set.
> 
> It doesn't understand chaining, but it does use sg_phys(x) so it will
> not get a wrong page pointer for the end marker.
> 
>> Fine then your code is now a crash because the terminating bit was just
>> copied over, which it was not before.
> 
> I did test the patch with value-assignment.
> 


Still you should use the sg_set_page()!!
1. It is not allowed to directly manipulate sg entries. One should always
   use the proper accessor. Even if open coding does work and is not a bug
   it should not be used anyway!
2. Future code that will support chaining will need to do as I say so why
   change it then, again?

Please don't change two things in one patch. The fix is for high-pages
please fix only that here. You can blasphemy open-code the sg manipulation
in a separate patch.

Please
Boaz

>> Lets separate the two topics from now on. Send me one mail concerning
>> the proper above patch, And a different mail for how to support chaining.
> 
> Ok, and I'll change the topic.
> 
> Paolo


