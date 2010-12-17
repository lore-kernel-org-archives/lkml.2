Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548Ab0LQFp4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 00:45:56 -0500
Received: from relay01.digicable.hu ([92.249.128.189]:45050 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab0LQFpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 00:45:55 -0500
Message-ID: <4D0AF910.8070202@freemail.hu>
Date: Fri, 17 Dec 2010 06:45:52 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Max Vozeler <max@vozeler.com>
CC: gregkh <gregkh@suse.de>, devel@driverdev.osuosl.org,
        LKML <linux-kernel@vger.kernel.org>, usbip-devel@lists.sourceforge.net
Subject: Re: usbip: sometimes stalls at kernel_recvmsg()
References: <4D06A004.8070502@freemail.hu> <4D09C056.5020305@freemail.hu> <4D0A97B3.2090701@vozeler.com>
In-Reply-To: <4D0A97B3.2090701@vozeler.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Original: 92.249.229.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Max,

Max Vozeler wrote:
> Hi Németh,
> 
> On 16.12.2010 08:31, Németh Márton wrote:
>> Németh Márton wrote:
>>> I'm working with usbip and I sometimes see a stall when I run
>>> the "lsusb" command from the userspace. 
> 
> Does it eventually recover?

No, it doesn't. After 120 seconds messages are printed in dmesg
that the "lsusb" process is blocked more than 120 seconds.

>>> I added some debug messages
>>> and it seems that the kernel_recvmsg() in
>>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=drivers/staging/usbip/usbip_common.c;h=210ef16bab8d271a52e5d36cd1994aad57ad99e1;hb=HEAD
>>>
>>> This is the only place I could find where the TCP messages are arriving in
>>> the usbip code.
>>>
>>> What happens if a message does not arrive? Does it stall forever? 
> 
> Yes, it will block until detached or until a TCP
> timeout or error closes the connection.
> 
> The TCP timeout can take several minutes.

What I don't really understand is that how is it possible that
a packet from TCP communication is lost? TCP resends the lost
packets automatically. In my case I run both the usbip server
and client on the same machine using the host name "localhost".
So I assume that there might be a protocol handshake problem
here.

There are, however cases when the timeout is needed, e.g. when
the usbip server and client are physically disconnected so the
TCP packet resend is no more possible.

	Márton Németh

