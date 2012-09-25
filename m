Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188Ab2IYEVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 00:21:49 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:41906 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab2IYEVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 00:21:47 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61a-b7f726d000000ec7-da-5061315aaf38
Message-id: <50613159.507@samsung.com>
Date: Tue, 25 Sep 2012 13:21:45 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
To: "R, Durgadoss" <durgadoss.r@intel.com>
Cc: "Zhang, Rui" <rui.zhang@intel.com>,
        "jonghwa3.lee@samsung.com" <jonghwa3.lee@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Amit Kachhap <amit.kachhap@linaro.org>
Subject: Re: [PATCH] Thermal: Fix bug on generic thermal framework.
References: <1348452350-1021-1-git-send-email-jonghwa3.lee@samsung.com>
 <4D68720C2E767A4AA6A8796D42C8EB591C98E6@BGSMSX102.gar.corp.intel.com>
 <1348477068.10877.180.camel@rui.sh.intel.com> <50610504.7050706@samsung.com>
 <1348538339.10877.193.camel@rui.sh.intel.com>
 <4D68720C2E767A4AA6A8796D42C8EB591D1396@BGSMSX101.gar.corp.intel.com>
In-reply-to: <4D68720C2E767A4AA6A8796D42C8EB591D1396@BGSMSX101.gar.corp.intel.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDLMWRmVeSWpSXmKPExsVy+t9jAd0ow8QAg8aLvBaXd81hs/jce4TR
	gcnj8ya5AMYoLpuU1JzMstQifbsEroyJU/uZC47xVLTe38XUwLiAq4uRk0NCwESi6/k2Rghb
	TOLCvfVsXYxcHEICixglDj7exwyS4BUQlPgx+R5LFyMHB7OAvMSRS9kgYWYBdYlJ8xYxQ9S/
	ZJTYsG0jO0S9msTV2dtZQGwWAVWJaXv+gdlsAnISb5u+MYLMERWIkPjVzwESFhHQkmjfsZMR
	YuZPJomtD01BSoQFnCXmvI6CGH+NSWLu1L1sIDWcAiESB+asZZrAKDALyXWzEK6bheS6BYzM
	qxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCw/CZ1A7GlQ0WhxgFOBiVeHg5NiQECLEmlhVX
	5h5ilOBgVhLh3S2TGCDEm5JYWZValB9fVJqTWnyIUZqDRUmcV/hTYICQQHpiSWp2ampBahFM
	lomDU6qBUXfjQpNn519vL15wqF4+tHzul+1zmPL2ce+VsGNhT9+WWbRvZ1cOp6nMfZF9TXUm
	h2Kv+R/+Lf6bL48l5wtLU5nG48yum21L6ooaFKoS7F5wMz11WsRo2vCYQfrsYw/7t8ZRYRUZ
	d6I81mhsCEpzfPlM8eHDjz+lt1/jvxqW+ifzQ2Qgq+5hJZbijERDLeai4kQA9xc1rz8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012년 09월 25일 12:04, R, Durgadoss wrote:
> Hi Rui,
>
>>>> Hi, Jonghwa,
>>>>
>>>> I still do not understand what the problem is.
>>>> Say if a cooling device fails to bind, the thermal zone device would
>>>> still work properly, just like the failure cooling device is not
>>>> referenced in this thermal zone.
>>>>
>>>> thanks,
>>>> rui
>>> Hi rui,
>>> No, it doesn't work properly. If it fails to bind some cool dev to
>>> thermal zone device, it frees thermal zone
>>> device without canceling delayed work. After freeing thermal zone
>>> device, system may call work function
>>> pointed NULL as the timer expired. Thus it requires skipping the
>>> initialization of polling work or canceling before
>>> the unregister.
>>
>> hah, I see what the problem is.
>> ideally, if we fail to bind one cooling device, we should just ignore it
>> and continue to bind other, what do you think?
> Yes, this is what we should do.
>
>> does the patch below fix your problem?
>> If yes, I'll try to rebase it on top of my next tree.
> This is already fixed in your -next tree, since you applied the
> fair share patches 10/15. The function bind_tz(tz) does the
> exact same thing, and continues.
>
> Thanks,
> Durga
I checked that it had been applied on -next branch, I don't commit this
patch any more.

Thanks,
Jonghwa

> N�����r��y���b�X��ǧv�^�)޺{.n�+����{��h����ܨ}���Ơz�&j:+v�������zZ+��+zf���h���~����i���z��w���?����&�)ߢfl===

