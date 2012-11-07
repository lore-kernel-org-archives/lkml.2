Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab2KGG7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 01:59:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658Ab2KGG67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 01:58:59 -0500
Message-ID: <509A06AB.2020700@redhat.com>
Date: Wed, 07 Nov 2012 07:58:51 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.10) Gecko/20121026 Thunderbird/10.0.10
MIME-Version: 1.0
To: Andy King <acking@vmware.com>
CC: David Miller <davem@davemloft.net>, pv-drivers@vmware.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, gregkh@linuxfoundation.org,
        georgezhang@vmware.com
Subject: Re: [Pv-drivers] [PATCH 0/6] VSOCK for Linux upstreaming
References: <783561822.12637564.1352139592543.JavaMail.root@vmware.com>
In-Reply-To: <783561822.12637564.1352139592543.JavaMail.root@vmware.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/12 19:19, Andy King wrote:
> Hi David,
> 
>> The big and only question is whether anyone can actually use any of
>> this stuff without your proprietary bits?
> 
> Do you mean the VMCI calls?  The VMCI driver is in the process of being
> upstreamed into the drivers/misc tree.  Greg (cc'd on these patches) is
> actively reviewing that code and we are addressing feedback.
> 
> Also, there was some interest from RedHat into using vSockets as a unified
> interface, routed over a hypervisor-specific transport (virtio or
> otherwise, although for now VMCI is the only one implemented).

Can you outline how this can be done?  From a quick look over the code
it seems like vsock has a hard dependency on vmci, is that correct?

When making vsock a generic, reusable kernel service it should be the
other way around:  vsock should provide the core implementation and an
interface where hypervisor-specific transports (vmci, virtio, xenbus,
...) can register themself.

cheers,
  Gerd
