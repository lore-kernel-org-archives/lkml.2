Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575Ab0LJAZi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 19:25:38 -0500
Received: from smtp.microsoft.com ([131.107.115.214]:14756 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757246Ab0LJAZh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 19:25:37 -0500
X-Greylist: delayed 307 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Dec 2010 19:25:37 EST
From: Hank Janssen <hjanssen@microsoft.com>
To: Jesper Juhl <jj@chaosbits.net>, Ky Srinivasan <ksrinivasan@novell.com>
CC: "zbr@ioremap.net" <zbr@ioremap.net>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 1/1] Properly check return values of kmalloc and
 vmbus_recvpacket
Thread-Topic: [PATCH 1/1] Properly check return values of kmalloc and
 vmbus_recvpacket
Thread-Index: AQHLl96ti20EqnxIX0iVeprq3GaEp5OZVGKA////UAD//3w0wA==
Date: Fri, 10 Dec 2010 00:20:28 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C5622C0B9ED3@TK5EX14MBXC116.redmond.corp.microsoft.com>
References: <1291926209-17120-1-git-send-email-hjanssen@microsoft.com>
 <4D013908.E57C.0030.1@novell.com>
 <alpine.LNX.2.00.1012100108030.25880@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1012100108030.25880@swampdragon.chaosbits.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.123.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jesper Juhl [mailto:jj@chaosbits.net]
> Sent: Thursday, December 09, 2010 4:11 PM
> On Thu, 9 Dec 2010, Ky Srinivasan wrote:
> > I am wondering if it might be better to allocate a page during module
> > startup for dealing with some of these services. Since the protocol
> > guarantees that there cannot be more than one outstanding request from
> > the host side, having a pre-allocated receive buffer would be a more
> > robust solution - we don't have to allocate memory when we cannot
> > afford to sleep and thereby don't have to deal with a class of failure
> > conditions that are not easy to deal with. For instance not being able
> > to shut the guest down because of low memory situation would be bad.
> >
> 
> IMVHO; nicer to have a module fail at load time with ENOMEM than having
> failures later. If memory requirement is known at load time (and is fairly low),
> just allocate what's needed then and then there's no unexpected failure
> later.

Agreed, That is a way neater implementation. I will correct and resubmit.

Thanks,

Hank.


