Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab1EYFaP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 01:30:15 -0400
Received: from relay01.digicable.hu ([92.249.128.189]:42905 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab1EYFaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 01:30:14 -0400
Message-ID: <4DDC93D5.9070607@freemail.hu>
Date: Wed, 25 May 2011 07:29:57 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>, Matthew Wilcox <matthew@wil.cx>,
        linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        usbip-devel@lists.sourceforge.net
Subject: Re: USBIP protocol documentation?
References: <4DDBF8BD.3000603@freemail.hu> <20110524183448.GA18511@kroah.com> <4DDC142E.6070003@freemail.hu> <20110525031222.GB14290@haskell.muteddisk.com>
In-Reply-To: <20110525031222.GB14290@haskell.muteddisk.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Original: 85.238.81.55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


matt mooney wrote:
> On 22:25 Tue 24 May     , Németh Márton wrote:
>> Greg KH wrote:
>>> I think the code is the "real" documentation.
>
> I concur!
>
>> If it is, then I need to read it in the right way, through it is not an easy task.
>> I tried to find the points in the USBIP kernel code where opening, sending,
>> receiving and closing of the TCP connection takes place. I took all function names
>> from linux/net.h and I found the following places so far:
>>
>> $ grep -n -E
>>
'sock_wake_async|sock_register|sock_unregister|sock_create|sock_create_kern|sock_create_lite|sock_release|sock_sendmsg|sock_recvmsg|sock_map_fd|sockfd_lookup|sockfd_put|net_ratelimit|kernel_sendmsg|kernel_recvmsg|kernel_bind|kernel_listen|kernel_accept|kernel_connect|kernel_getsockname|kernel_getpeername|kernel_getsockopt|kernel_setsockopt|kernel_sendpage|kernel_sock_ioctl|kernel_sock_shutdown|SHUT_'
>> linux-2.6/drivers/staging/usbip/*
>>
>> linux-2.6/drivers/staging/usbip/stub_dev.c:201:         kernel_sock_shutdown(ud->tcp_socket, SHUT_RDWR);
>> linux-2.6/drivers/staging/usbip/stub_dev.c:216:         sock_release(ud->tcp_socket);
>> linux-2.6/drivers/staging/usbip/stub_tx.c:263:          ret = kernel_sendmsg(sdev->ud.tcp_socket, &msg,
>> linux-2.6/drivers/staging/usbip/stub_tx.c:338:          ret = kernel_sendmsg(sdev->ud.tcp_socket, &msg, iov,
>> linux-2.6/drivers/staging/usbip/usbip_common.c:382:                     result = kernel_sendmsg(sock, &msg, &iov, 1, size);
>> linux-2.6/drivers/staging/usbip/usbip_common.c:384:                     result = kernel_recvmsg(sock, &msg, &iov, 1, size,
>> linux-2.6/drivers/staging/usbip/vhci_hcd.c:845:         kernel_sock_shutdown(ud->tcp_socket, SHUT_RDWR);
>> linux-2.6/drivers/staging/usbip/vhci_hcd.c:858:         sock_release(vdev->ud.tcp_socket);
>> linux-2.6/drivers/staging/usbip/vhci_tx.c:119:          ret = kernel_sendmsg(vdev->ud.tcp_socket, &msg, iov, 3, txsize);
>> linux-2.6/drivers/staging/usbip/vhci_tx.c:189:          ret = kernel_sendmsg(vdev->ud.tcp_socket, &msg, iov, 1, txsize);
>>
>> I guess this is not all, there is also a protocol defined to the user-space world.
>
> Very true, and part of what is taking place is a unification of the userspace
> and kernel protocols. Then there will be some degree of documentation. Mainly in
> the form of packet diagrams to show on-wire communication.

Could you please give some hints witch function names to look for and
where to start "reading" the source code to see how the userspace protocol
looks like?

> On Tue, May 24, 2011 at 10:25:18PM +0200, Németh Márton wrote:
>> The current protocol implementation is based on top of TCP. In the message
>> at http://marc.info/?l=linux-kernel&m=122001883519653&w=2 the SCTP is mentioned.
>> Have anybody worked on finding out what benefits the SCTP could give to USBIP
>> and what would be the drawbacks?

Greg KH wrote:
> It might not work well on Windows, which the current code does today.
>
> I think that the TCP vs. SCTP is the least of the protocol issues at the
> moment, there are lots of other things to work on :)

matt mooney wrote:
> I think sctp would be interesting, but as greg said, and I tend to agree, this
> is the least of usbip's problems.
> 
> (Maybe eliminating the need to interact w/ windows would be a good project ;)
> jk!

OK, I see your point. I tried to check the "source code" for a TODO list,
but I think I failed at that point because I just found:

| $ cat linux-2.6/drivers/staging/usbip/README
| TODO:
|         - more discussion about the protocol
|         - testing
|         - review of the userspace interface
|
| Please send patches for this code to Greg Kroah-Hartman <greg@kroah.com>

These are quite hard tasks to solve. More discussion about the protocol? I
think the first problem is that it is difficult (at least for me) to see clearly
the protocol because of lack of documentation.

Testing: when you test something you compare the running code against something.
If you compare the running code against the source code then you will not test
the USBIP implementation/protocol, but the compiler itself, whether the compiler
generated the same code which is available in source format.

Review of the userspace interface: first I will need to understand how it looks
like befor I can do anything on this point.

Do you have a bit detailed TODO list somewhere written down or in your heads
so beginners can also help? E.g. running "scripts/checkpatch.pl -f" and
solving the errors/warnings helps at this point? Or compiling with "make W=1 C=1 ..."
and solving those warnings helps?

Regards,

	Márton Németh
