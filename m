Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141Ab1JOAop (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 20:44:45 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:23888 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395Ab1JOAoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 20:44:44 -0400
Message-ID: <4E98D739.4000705@oracle.com>
Date: Fri, 14 Oct 2011 17:43:37 -0700
From: Maxim Uvarov <maxim.uvarov@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Thunderbird/3.1.13
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com
Subject: Re: [PATCH] XEN_DOMAIN_MEMORY options.
References: <1318631811-21559-1-git-send-email-maxim.uvarov@oracle.com> <4E98BEF5.10801@goop.org> <4E98C6CE.4020508@oracle.com> <4E98C8B1.20304@goop.org>
In-Reply-To: <4E98C8B1.20304@goop.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet24.oracle.com [156.151.31.67]
X-CT-RefId: str=0001.0A090201.4E98D778.012C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2011 04:41 PM, Jeremy Fitzhardinge wrote:
> On 10/14/2011 04:33 PM, Maxim Uvarov wrote:
>> On 10/14/2011 04:00 PM, Jeremy Fitzhardinge wrote:
>>> On 10/14/2011 03:36 PM, Maxim Uvarov wrote:
>>>> Hello,
>>>>
>>>> Please find here patches for XEN_MAX_DOMAIN_MEMORY:
>>>>
>>>> [PATCH 1/2] xen: Fix XEN_MAX_DOMAIN_MEMORY to be selectable
>>>> [PATCH 2/2] xen: Make XEN_MAX_DOMAIN_MEMORY have more sensible
>>>> defaults for 32-bit builds
>>>
>>> What's the rationale?
>>>
>>>       J
>>
>> The first patch is actually bug fix. You can not define just "int"
>> without description in Kconfig. As the result this option will not be
>> visible in menuconfig. Even if you will change it in .config make
>> oldconfig will set it up for default value. So you need to add any
>> description to it as all others int options have.
>
> No, that was deliberate, because I don't really think there's a need to
> change it.
>

 From that point of view it's not clear why this option is still in Kconfig?

Jeremy, can you please share more details about this? I see people are 
having troubles with this option and in different kernels I see 
different work arounds  for it. For example:
http://lists.xensource.com/archives/html/xen-devel/2011-01/msg01841.html

Maxim.
>>
>> Second patch is more optional and it's just suggestion to use for 32
>> bit more corresponding value.
>
> While it would be very silly to put 128GB of actual RAM on a 32-bit
> machine, systems can have non-contiguous RAM placed at high addresses,
> which would no longer be accessible.
>
>      J

