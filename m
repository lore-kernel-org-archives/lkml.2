Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585Ab2LWFuV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 00:50:21 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:60783 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab2LWFuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 00:50:20 -0500
Message-ID: <1356241795.5620.47.camel@marge.simpson.net>
Subject: Re: dire state of rtl driver in 3.7
From: Mike Galbraith <bitbucket@online.de>
To: Norbert Preining <preining@logic.at>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 23 Dec 2012 06:49:55 +0100
In-Reply-To: <20121222150909.GA3979@gamma.logic.tuwien.ac.at>
References: <20121222150909.GA3979@gamma.logic.tuwien.ac.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:KG6Jo9YA4mhtQTk3XFqkifWPya53bpKeKS1Jz3thsMg
 TeLDg7iigm3O40S9Pg+uZ6o6CG5HVTCi+iXQZCpThguF59fxDd
 QvFCy7wwtKxDJ316eLBeZPU59FbDGf95yUOkNrnENb7nzVk72H
 jveNutngaoG8/VdhuRiVbTqFS04d23NpWKZSARk6/e+tmWL31T
 jA9AdJtI4qFO26oHw4sUaaMYsxCBFJEDRuouihAcx6zzbmJlgj
 3X3yhMeWDS3vg1GL/OtdJg2JOfr1Jr5lBIiXwvQwOSt3y5L4nv
 ISP0Wz3uvkdE2q2JY/eLya0mNlcjYukifwYeRHUhk0opp64wD0
 6WPVLnOuAIdQJXUqvEnZekRwRICZewAoHTvkjtdYV4WZyxOR76
 uAW2BFmg6Fg/A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-12-23 at 00:09 +0900, Norbert Preining wrote:

> Network card is built in into a Lenovo Thinkpad Edge

Toshiba Satellite.
> # lspci -nnv -s  03:00.0
> 03:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. RTL8191SEvB
> Wireless LAN Controller [10ec:8172] (rev 10)
>         Subsystem: Realtek Semiconductor Co., Ltd. Device [10ec:e020]

[10ec:8181] here.

> Effects:
> - either does not associate at all with the AP
> - or the kernel believes it is associated and packages ping to the router
>   get stuck for up to 50+ seconds!!!
> - the kernel believes everything is fine but actually nothing gets out
>   (Destination unreachable)
> - wild ping time up-down:
> 64 bytes from 192.168.0.1: icmp_req=73 ttl=255 time=3.05 ms
> 64 bytes from 192.168.0.1: icmp_req=74 ttl=255 time=6.42 ms
> 64 bytes from 192.168.0.1: icmp_req=75 ttl=255 time=1.21 ms
> 64 bytes from 192.168.0.1: icmp_req=76 ttl=255 time=6808 ms
> 64 bytes from 192.168.0.1: icmp_req=77 ttl=255 time=5800 ms
> 64 bytes from 192.168.0.1: icmp_req=78 ttl=255 time=4792 ms

...

Looks a lot like my driver experience with older kernels, I had to use
the external driver in the rare event that I needed wireless to work.
The in tree driver works peachy these days (needed it recently, was
pleasantly surprised when it _just worked_, not even a hiccup), so
somebody cared, gave at least the 10ec:8181 bits some serious love.

-Mike

