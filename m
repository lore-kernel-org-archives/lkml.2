Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512Ab1EXUZg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 16:25:36 -0400
Received: from relay03.digicable.hu ([92.249.128.185]:45746 "EHLO
	relay03.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab1EXUZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 16:25:35 -0400
Message-ID: <4DDC142E.6070003@freemail.hu>
Date: Tue, 24 May 2011 22:25:18 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Matthew Wilcox <matthew@wil.cx>, Matt Mooney <mfm@muteddisk.com>,
        linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        usbip-devel@lists.sourceforge.net
Subject: Re: USBIP protocol documentation?
References: <4DDBF8BD.3000603@freemail.hu> <20110524183448.GA18511@kroah.com>
In-Reply-To: <20110524183448.GA18511@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Original: 94.21.98.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Tue, May 24, 2011 at 08:28:13PM +0200, Németh Márton wrote:
>> Hi,
>>
>> I'm looking for the USBIP protocol documentation. I found that
>> there was already a discussion about the USBIP protocol and
>> there is some draft about it:
>>
>>   * http://marc.info/?l=linux-kernel&m=122001863119269&w=2
>>   * http://www.kernel.org/pub/linux/kernel/people/willy/usbip/usbip-protocol-draft-1
>>
>> Unfortunately I couldn't found any detailed protocol documentation
>> on the project homepage:
>>
>>   * http://usbip.sourceforge.net/#documentation
>>
>> Do you know any follow-up on the USBIP protocol documentation?
> 
> I think the code is the "real" documentation.

If it is, then I need to read it in the right way, through it is not an easy task.
I tried to find the points in the USBIP kernel code where opening, sending,
receiving and closing of the TCP connection takes place. I took all function names
from linux/net.h and I found the following places so far:

$ grep -n -E
'sock_wake_async|sock_register|sock_unregister|sock_create|sock_create_kern|sock_create_lite|sock_release|sock_sendmsg|sock_recvmsg|sock_map_fd|sockfd_lookup|sockfd_put|net_ratelimit|kernel_sendmsg|kernel_recvmsg|kernel_bind|kernel_listen|kernel_accept|kernel_connect|kernel_getsockname|kernel_getpeername|kernel_getsockopt|kernel_setsockopt|kernel_sendpage|kernel_sock_ioctl|kernel_sock_shutdown|SHUT_'
linux-2.6/drivers/staging/usbip/*

linux-2.6/drivers/staging/usbip/stub_dev.c:201:         kernel_sock_shutdown(ud->tcp_socket, SHUT_RDWR);
linux-2.6/drivers/staging/usbip/stub_dev.c:216:         sock_release(ud->tcp_socket);
linux-2.6/drivers/staging/usbip/stub_tx.c:263:          ret = kernel_sendmsg(sdev->ud.tcp_socket, &msg,
linux-2.6/drivers/staging/usbip/stub_tx.c:338:          ret = kernel_sendmsg(sdev->ud.tcp_socket, &msg, iov,
linux-2.6/drivers/staging/usbip/usbip_common.c:382:                     result = kernel_sendmsg(sock, &msg, &iov, 1, size);
linux-2.6/drivers/staging/usbip/usbip_common.c:384:                     result = kernel_recvmsg(sock, &msg, &iov, 1, size,
linux-2.6/drivers/staging/usbip/vhci_hcd.c:845:         kernel_sock_shutdown(ud->tcp_socket, SHUT_RDWR);
linux-2.6/drivers/staging/usbip/vhci_hcd.c:858:         sock_release(vdev->ud.tcp_socket);
linux-2.6/drivers/staging/usbip/vhci_tx.c:119:          ret = kernel_sendmsg(vdev->ud.tcp_socket, &msg, iov, 3, txsize);
linux-2.6/drivers/staging/usbip/vhci_tx.c:189:          ret = kernel_sendmsg(vdev->ud.tcp_socket, &msg, iov, 1, txsize);

I guess this is not all, there is also a protocol defined to the user-space world.

> Note a number of developers are actively working on changing the protocol
> and fixing it up based on Matthew's previous comments.  Look at the
> thread on the usbip project's mailing list for a few details.  More will
> be in the patches produced by the developers.

I had a look at the usbip-devel mailing list archive at
http://sourceforge.net/mailarchive/forum.php?forum_name=usbip-devel and found
a thread where I could find some protocol description also:

 * http://sourceforge.net/mailarchive/message.php?msg_id=27240940

The current protocol implementation is based on top of TCP. In the message
at http://marc.info/?l=linux-kernel&m=122001883519653&w=2 the SCTP is mentioned.
Have anybody worked on finding out what benefits the SCTP could give to USBIP
and what would be the drawbacks?

Regards,

	Márton Németh
