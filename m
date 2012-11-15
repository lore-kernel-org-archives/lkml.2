Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751619Ab2KOVcV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 16:32:21 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:43220 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab2KOVcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 16:32:19 -0500
Message-ID: <50A55F57.7080804@us.ibm.com>
Date: Thu, 15 Nov 2012 15:32:07 -0600
From: Anthony Liguori <aliguori@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Gerd Hoffmann <kraxel@redhat.com>
CC: Andy King <acking@vmware.com>, pv-drivers@vmware.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, gregkh@linuxfoundation.org,
        David Miller <davem@davemloft.net>, georgezhang@vmware.com,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [Pv-drivers] [PATCH 0/6] VSOCK for Linux upstreaming
References: <783561822.12637564.1352139592543.JavaMail.root@vmware.com> <509A06AB.2020700@redhat.com>
In-Reply-To: <509A06AB.2020700@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12111521-2000-0000-0000-000009E45107
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2012 12:58 AM, Gerd Hoffmann wrote:
> On 11/05/12 19:19, Andy King wrote:
>> Hi David,
>>
>>> The big and only question is whether anyone can actually use any of
>>> this stuff without your proprietary bits?
>>
>> Do you mean the VMCI calls?  The VMCI driver is in the process of being
>> upstreamed into the drivers/misc tree.  Greg (cc'd on these patches) is
>> actively reviewing that code and we are addressing feedback.
>>
>> Also, there was some interest from RedHat into using vSockets as a unified
>> interface, routed over a hypervisor-specific transport (virtio or
>> otherwise, although for now VMCI is the only one implemented).
>
> Can you outline how this can be done?  From a quick look over the code
> it seems like vsock has a hard dependency on vmci, is that correct?
>
> When making vsock a generic, reusable kernel service it should be the
> other way around:  vsock should provide the core implementation and an
> interface where hypervisor-specific transports (vmci, virtio, xenbus,
> ...) can register themself.

This was already done in a hypervisor neutral way using virtio:

http://lists.openwall.net/netdev/2008/12/14/8

The concept was Nacked and that led to the abomination of virtio-serial.  If an 
address family for virtualization is on the table, we should reconsider 
AF_VMCHANNEL.

I'd be thrilled to get rid of virtio-serial...

Regards,

Anthony Liguori

>
> cheers,
>    Gerd

