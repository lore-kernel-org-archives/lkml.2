Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932571Ab2LFN1P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 08:27:15 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:32908 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236Ab2LFN1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 08:27:14 -0500
Message-ID: <50C09D2E.8050608@atmel.com>
Date: Thu, 6 Dec 2012 14:27:10 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Erwin Rol <mailinglists@erwinrol.com>
CC: <linux-kernel@vger.kernel.org>, Havard Skinnemoen <havard@skinnemoen.net>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        <matteo.fortini@sadel.it>, netdev <netdev@vger.kernel.org>
Subject: Re: at91sam9260 MACB problem with IP fragmentation
References: <50C08233.9030905@erwinrol.com>
In-Reply-To: <50C08233.9030905@erwinrol.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Erwin,

On 12/06/2012 12:32 PM, Erwin Rol :
> Hello Nicolas, Havard, all,
> 
> I have a very obscure problem with a at91sam9260 board (almost 1 to 1
> copy of the Atmel EK).
> 
> The MACB seems to stall when I use large (>2 * MTU) UDP datagrams. The
> test case is that a udp echo client (PC) sends datagrams with increasing
> length to the AT91 until the max length of the UDP datagram is reached.
> When there is no IP fragmentation everything is fine, but when the
> datagrams are starting to get fragmented the AT91 will not reply
> anymore. But as soon as some network traffic happens it goes on again,
> and non of the data is lost.
> 
> With wireshark the effect can be easily seen (192.168.1.4 is the PC echo
> client, and 192.168.1.133 is the at91 echo server) After the first
> request there comes no reply. After a 5 second timeout the second
> request is send. And then both replies are returned.
> 
> When I enabled debugging output it all started to work. So I tried some
> udelays in the driver instead of printk and with a 1ms delay in the irq
> handler it started working. Of course that is an unacceptable fix, but
> it looks like that is some weird race condition that causes the sending
> to stall. The only difference with normal MTU sized datagrams I can
> think of is that the fragmented packets can be passed very quickly to
> the macb tx function, because the kernel has all 5 skb's ready.
> 
> I would be very interested to hear if someone else could reproduce this
> problem. Or even better, has seen this problem and has a fix for it.
> 
> I tried several kernels including the test version from Nicolas that he
> posted on LKML in October. They all show the same effect.

[..]

It seems that Matteo has the same behavior: check here:
http://www.spinics.net/lists/netdev/msg218951.html

I am working on the macb driver right now, so I will try to reproduce
and track this issue on my side.

Best regards,
-- 
Nicolas Ferre
