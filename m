Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab2KHGNs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 01:13:48 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:53178 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab2KHGNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 01:13:47 -0500
MIME-Version: 1.0
In-Reply-To: <20121106165144.bdeca850.akpm@linux-foundation.org>
References: <CAPgLHd-q7WCFrO_hW3nGHPj784jMtR9=fEzMqo5uQKapwO2NUA@mail.gmail.com>
	<20121106165144.bdeca850.akpm@linux-foundation.org>
Date: Thu, 8 Nov 2012 14:13:46 +0800
Message-ID: <CAPgLHd_Hx=uDnghRe9mQDNdHB1LmzFzfPDQ0sF2LPKambUvPLA@mail.gmail.com>
Subject: Re: [PATCH] rtc: avoid calling platform_device_put() twice in test_init()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: akpm@linux-foundation.org
Cc: a.zummo@towertech.it, yongjun_wei@trendmicro.com.cn,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2012 08:51 AM, Andrew Morton wrote:
> On Tue, 23 Oct 2012 13:08:41 +0800
> Wei Yongjun <weiyj.lk@gmail.com> wrote:
>
>> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>>
>> In case of error, the function test_init() need to call
>> platform_device_del() instead of platform_device_unregister().
>> Otherwise, we may call platform_device_put() twice.
>>
> Is platform_device_del() the partner to platform_device_add()?  If so
> then yes, this looks right.  But I think the labels can be improved:
>
> _
>
>
> However, take a look at test_exit().  it does
> platform_device_unregister(test0) when test0 is in the same state.  Is
> that code wrong as well?  Presumably it's working OK?

platform_device_unregister() is a warp of platform_device_del()
and platform_device_put(), if platform_device_add() success, we
can use platform_device_unregister() to do this, so that code
is OK.
 


