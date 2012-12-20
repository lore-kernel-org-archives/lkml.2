Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994Ab2LTJRm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 04:17:42 -0500
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:52023 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751274Ab2LTJRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 04:17:38 -0500
Message-ID: <50D2D7BD.3030801@erwinrol.com>
Date: Thu, 20 Dec 2012 10:17:49 +0100
From: Erwin Rol <mailinglists@erwinrol.com>
Organization: Erwin Rol Software Engineering
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: linux-kernel@vger.kernel.org, Havard Skinnemoen <havard@skinnemoen.net>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        matteo.fortini@sadel.it, netdev <netdev@vger.kernel.org>
Subject: Re: at91sam9260 MACB problem with IP fragmentation
References: <50C08233.9030905@erwinrol.com> <50C09D2E.8050608@atmel.com>
In-Reply-To: <50C09D2E.8050608@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Dec 2012 09:17:36.0105 (UTC) FILETIME=[D99B7D90:01CDDE92]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo Nicolas,

On 6-12-2012 14:27, Nicolas Ferre wrote:
> Erwin,
> 
> On 12/06/2012 12:32 PM, Erwin Rol :
>> Hello Nicolas, Havard, all,
>>
>> I have a very obscure problem with a at91sam9260 board (almost 1 to 1
>> copy of the Atmel EK).
>>
>> The MACB seems to stall when I use large (>2 * MTU) UDP datagrams. The
>> test case is that a udp echo client (PC) sends datagrams with increasing
>> length to the AT91 until the max length of the UDP datagram is reached.
>> When there is no IP fragmentation everything is fine, but when the
>> datagrams are starting to get fragmented the AT91 will not reply
>> anymore. But as soon as some network traffic happens it goes on again,
>> and non of the data is lost.

<snip>

>> I tried several kernels including the test version from Nicolas that he
>> posted on LKML in October. They all show the same effect.
> 
> [..]
> 
> It seems that Matteo has the same behavior: check here:
> http://www.spinics.net/lists/netdev/msg218951.html

I tried Matteo's patch and it seems to work. But I don't know if the
patch is really the right solution. I checked again with wireshark and
it really seems the sending that stalls not the receiving. But as soon
as a ethernet frame is received the sending "un-stalls". So maybe the
patch just causes an MACB IRQ at certain moments that causes the sending
to continue?

> I am working on the macb driver right now, so I will try to reproduce
> and track this issue on my side.

Any luck reproducing it ?


- Erwin

