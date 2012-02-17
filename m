Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab2BQP1W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 10:27:22 -0500
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:56831 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752874Ab2BQP1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 10:27:21 -0500
Message-ID: <4F3E71D2.5080306@ti.com>
Date: Fri, 17 Feb 2012 20:57:14 +0530
From: Aneesh V <aneesh@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.21) Gecko/20110831 Thunderbird/3.1.13
MIME-Version: 1.0
To: "Cousson, Benoit" <b-cousson@ti.com>
CC: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [RFC PATCH 4/8] misc: emif: add basic infrastructure for EMIF
 driver
References: <1328357771-31644-1-git-send-email-aneesh@ti.com> <1328357771-31644-5-git-send-email-aneesh@ti.com> <4F3D2F2F.8050406@ti.com> <4F3E558A.3060605@ti.com> <4F3E59CD.6050108@ti.com>
In-Reply-To: <4F3E59CD.6050108@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 February 2012 07:14 PM, Cousson, Benoit wrote:
> Hi Aneesh,

[...]

>>>> + emif = kzalloc(sizeof(struct emif_data), GFP_KERNEL);
>>>
>>> You should use the devm_* version of this API to get the simplify the
>>> error handling / removal.
>>
>> Please note that most of my allocations are happening through
>> kmemdup(). kmemdup() doesn't have a devm_* equivalent. So, I have a
>> cleanup() function and in the interest of uniformity decided to avoid
>> devm_* variants altogether.
>
> I think it still worth using devm_kzalloc + memcopy here instead of
> kmemdup to avoid the cleanup() and simplify as well the error handling.

I will do that.

>
> You might even propose a new devm_kmemdup API if you want.

Ok. I will attempt that, maybe both devm_kmalloc() and devm_kmemdup().
But I would like to de-couple that from this series. That is, I will do
the patch separately and if that gets up-streamed I will update EMIF
driver to use them. Until then I will go with what you suggested above.

br,
Aneesh
