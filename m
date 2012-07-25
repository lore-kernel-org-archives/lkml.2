Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933082Ab2GYNli (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 09:41:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15459 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932917Ab2GYNlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 09:41:37 -0400
Message-ID: <500FF656.6000203@redhat.com>
Date: Wed, 25 Jul 2012 15:36:22 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: Wang Sen <senwang@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org,
        JBottomley@parallels.com, stefanha@linux.vnet.ibm.com,
        mc@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: virtio-scsi: Fix address translation failure of
 HighMem pages used by sg list
References: <1343204966-23560-1-git-send-email-senwang@linux.vnet.ibm.com> <500FB1DE.1000100@redhat.com> <500FBAE8.2050107@panasas.com> <500FBF37.50603@redhat.com> <500FE7D2.7070101@panasas.com> <500FEB63.3000709@redhat.com> <500FF412.3090600@panasas.com>
In-Reply-To: <500FF412.3090600@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 25/07/2012 15:26, Boaz Harrosh ha scritto:
> On 07/25/2012 03:49 PM, Paolo Bonzini wrote:
> 
>>
>> Except here the destination array has to be given to virtio, which
>> doesn't (yet) understand chaining.  I'm using for_each_sg rather than a
>> simple memcpy exactly because I want to flatten the input scatterlist
>> onto consecutive scatterlist entries, which is what virtio expects (and
>> what I'll change when I get to it).
>>
>> for_each_sg guarantees that I get non-chain scatterlists only, so it is
>> okay to value-assign them to sg[].
> 
> So if the virtio does not understand chaining at all then surly it will
> not understand the 2-bit end marker and will get a wrong page pointer
> with the 1st bit set.

It doesn't understand chaining, but it does use sg_phys(x) so it will
not get a wrong page pointer for the end marker.

> Fine then your code is now a crash because the terminating bit was just
> copied over, which it was not before.

I did test the patch with value-assignment.

> Lets separate the two topics from now on. Send me one mail concerning
> the proper above patch, And a different mail for how to support chaining.

Ok, and I'll change the topic.

Paolo
