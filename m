Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab2LWTKn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 14:10:43 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:59258 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab2LWTKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 14:10:41 -0500
Message-ID: <50D7572E.8060908@lwfinger.net>
Date: Sun, 23 Dec 2012 13:10:38 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mike Galbraith <bitbucket@online.de>
CC: Norbert Preining <preining@logic.at>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: dire state of rtl driver in 3.7
References: <20121222150909.GA3979@gamma.logic.tuwien.ac.at> <1356241795.5620.47.camel@marge.simpson.net>
In-Reply-To: <1356241795.5620.47.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2012 11:49 PM, Mike Galbraith wrote:
> On Sun, 2012-12-23 at 00:09 +0900, Norbert Preining wrote:
>
>> Network card is built in into a Lenovo Thinkpad Edge
>
> Toshiba Satellite.
>> # lspci -nnv -s  03:00.0
>> 03:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. RTL8191SEvB
>> Wireless LAN Controller [10ec:8172] (rev 10)
>>          Subsystem: Realtek Semiconductor Co., Ltd. Device [10ec:e020]
>
> [10ec:8181] here.
>
>> Effects:
>> - either does not associate at all with the AP
>> - or the kernel believes it is associated and packages ping to the router
>>    get stuck for up to 50+ seconds!!!
>> - the kernel believes everything is fine but actually nothing gets out
>>    (Destination unreachable)
>> - wild ping time up-down:
>> 64 bytes from 192.168.0.1: icmp_req=73 ttl=255 time=3.05 ms
>> 64 bytes from 192.168.0.1: icmp_req=74 ttl=255 time=6.42 ms
>> 64 bytes from 192.168.0.1: icmp_req=75 ttl=255 time=1.21 ms
>> 64 bytes from 192.168.0.1: icmp_req=76 ttl=255 time=6808 ms
>> 64 bytes from 192.168.0.1: icmp_req=77 ttl=255 time=5800 ms
>> 64 bytes from 192.168.0.1: icmp_req=78 ttl=255 time=4792 ms
>
> ...
>
> Looks a lot like my driver experience with older kernels, I had to use
> the external driver in the rare event that I needed wireless to work.
> The in tree driver works peachy these days (needed it recently, was
> pleasantly surprised when it _just worked_, not even a hiccup), so
> somebody cared, gave at least the 10ec:8181 bits some serious love.

Note, the RTL8188CE uses rtl8192ce, while the RTL8191SE uses rtl8192se. They 
share the underlying plumbing in driver rtlwifi, but the rest is completely 
different.

The reason that rtl8192ce now works with your device is that the so-called B-Cut 
chip was not supported until recently. The fix required 2 patches. The first was 
simple enough to be backported to stable; however the second was too invasive 
for that. Accordingly the second part had to wait for kernel 3.7.

Larry


