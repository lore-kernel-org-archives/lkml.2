Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab2HUAFh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 20:05:37 -0400
Received: from host86-151-170-244.range86-151.btcentralplus.com ([86.151.170.244]:54478
	"EHLO oak.selfip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab2HUAFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 20:05:35 -0400
Message-ID: <5032D0C0.4080908@oak.selfip.net>
Date: Tue, 21 Aug 2012 01:05:20 +0100
From: Dave Haywood <tla@oak.selfip.net>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120815 Thunderbird/15.0
MIME-Version: 1.0
To: Artem Savkov <artem.savkov@gmail.com>
CC: Shaun Ruffell <sruffell@digium.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-net@vger.kernel.org
Subject: Re: BUG: unable to handle kernel paging request at 00010016
References: <502ECC74.9030605@oak.selfip.net> <20120819042543.GA14461@digium.com> <20120819082117.GA4634@thinkpad.lan>
In-Reply-To: <20120819082117.GA4634@thinkpad.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/08/2012 09:21, Artem Savkov wrote:
> On Sat, Aug 18, 2012 at 11:25:43PM -0500, Shaun Ruffell wrote:
>> Adding linux-net to the CC list.
>>
>> On Fri, Aug 17, 2012 at 11:57:56PM +0100, Dave Haywood wrote:
>>> [1.] One line summary of the problem:
>>> BUG: unable to handle kernel paging request at 00010016
>>>
>>> 	System boots then crashes a 5-10 or so seconds after getting to the login prompt
>>> 	Booting without the network cable attached prevents the crash (no evidence beyond 10 minutes after boot)
>>>
>>>    Diagnostics:
>>> 	Captured the boot and managed a login + dmesg before the crash
>>> 	Some of the log looks corrupted. Probably my crappy usb dongle serial flow control but left it in anyway
>> [snip]
>>
>> Just a note that I see this as well. It happens reliably for me after trying to
>> login to the machine via ssh.
>>
>> Here is the back trace I collected on the serial port.
> There is a patch posted on netdev that fixes this for me:
> http://patchwork.ozlabs.org/patch/178525/
>
Bisected to:

5d299f3d3c8a2fbc732b1bf03af36333ccec3130 is the first bad commit

commit 5d299f3d3c8a2fbc732b1bf03af36333ccec3130

Author: Eric Dumazet <edumazet@google.com>

Date:   Mon Aug 6 05:09:33 2012 +0000

     net: ipv6: fix TCP early demux

     IPv6 needs a cookie in dst_check() call.

     We need to add rx_dst_cookie and provide a family independent

     sk_rx_dst_set(sk, skb) method to properly support IPv6 TCP early demux.

     Signed-off-by: Eric Dumazet <edumazet@google.com>

     Signed-off-by: David S. Miller <davem@davemloft.net>

:040000 040000 96ade77f304a89c1886fbaa125b03d1f5699e418 485a021044b8f52ae8562e4e90d8f6536863f5e7 M      include

:040000 040000 1ebd6792af2014ad11979216b9a56504a28d5782 7a53fc9e7fb219c4cacb1bbb3b6867f30790dfd1 M      net




