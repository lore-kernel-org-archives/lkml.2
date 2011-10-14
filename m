Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757097Ab1JNXlo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 19:41:44 -0400
Received: from claw.goop.org ([74.207.240.146]:53606 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836Ab1JNXln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 19:41:43 -0400
Message-ID: <4E98C8B1.20304@goop.org>
Date: Fri, 14 Oct 2011 16:41:37 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Maxim Uvarov <maxim.uvarov@oracle.com>
CC: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com
Subject: Re: [PATCH] XEN_DOMAIN_MEMORY options.
References: <1318631811-21559-1-git-send-email-maxim.uvarov@oracle.com> <4E98BEF5.10801@goop.org> <4E98C6CE.4020508@oracle.com>
In-Reply-To: <4E98C6CE.4020508@oracle.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2011 04:33 PM, Maxim Uvarov wrote:
> On 10/14/2011 04:00 PM, Jeremy Fitzhardinge wrote:
>> On 10/14/2011 03:36 PM, Maxim Uvarov wrote:
>>> Hello,
>>>
>>> Please find here patches for XEN_MAX_DOMAIN_MEMORY:
>>>
>>> [PATCH 1/2] xen: Fix XEN_MAX_DOMAIN_MEMORY to be selectable
>>> [PATCH 2/2] xen: Make XEN_MAX_DOMAIN_MEMORY have more sensible
>>> defaults for 32-bit builds
>>
>> What's the rationale?
>>
>>      J
>
> The first patch is actually bug fix. You can not define just "int"
> without description in Kconfig. As the result this option will not be
> visible in menuconfig. Even if you will change it in .config make
> oldconfig will set it up for default value. So you need to add any
> description to it as all others int options have.

No, that was deliberate, because I don't really think there's a need to
change it.

>
> Second patch is more optional and it's just suggestion to use for 32
> bit more corresponding value.

While it would be very silly to put 128GB of actual RAM on a 32-bit
machine, systems can have non-contiguous RAM placed at high addresses,
which would no longer be accessible.

    J
