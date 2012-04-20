Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932485Ab2DTQOh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 12:14:37 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:51790 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077Ab2DTQOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 12:14:36 -0400
Message-ID: <4F918B66.10107@oracle.com>
Date: Fri, 20 Apr 2012 11:14:30 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120406 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zach Brown <zab@zabbo.net>
Subject: Re: [RFC PATCH v2 15/21] loop: use aio to perform io on the underlying
 file
References: <1333122228-13633-1-git-send-email-dave.kleikamp@oracle.com> <1333122228-13633-16-git-send-email-dave.kleikamp@oracle.com> <4F917751.9040600@parallels.com> <4F917C2F.4020805@oracle.com> <x49mx66whty.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49mx66whty.fsf@segfault.boston.devel.redhat.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090208.4F918B69.0094,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/20/2012 10:20 AM, Jeff Moyer wrote:
> Dave Kleikamp <dave.kleikamp@oracle.com> writes:
> 
>> On 04/20/2012 09:48 AM, Maxim V. Patlasov wrote:
>>> On 03/30/2012 07:43 PM, Dave Kleikamp wrote:
>>>> From: Zach Brown<zab@zabbo.net>
>>>>
>>>> This uses the new kernel aio interface to process loopback IO by
>>>> submitting concurrent direct aio.  Previously loop's IO was serialized
>>>> by synchronous processing in a thread.
>>>>
>>>
>>> The patch ignores REQ_FLUSH bit of bi_rw. Is it simply overlook?
>>
>> Good question. Since the loop device is sending only direct IO requests,
>> it shouldn't be necessary to explicitly flush page cache, but REQ_FLUSH
> 
> REQ_FLUSH isn't about the page cache, it's about flushing the volatile
> disk write cache.  You need to handle that.

Yeah, and looking again at this code, I need to handle REQ_DISCARD as well.

> 
> Cheers,
> Jeff
