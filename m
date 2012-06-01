Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759701Ab2FAM4u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 08:56:50 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:49433 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759671Ab2FAM4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 08:56:49 -0400
Message-ID: <4FC8BBBF.6090701@linux.vnet.ibm.com>
Date: Fri, 01 Jun 2012 18:25:27 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Richard Kuo <rkuo@codeaurora.org>, David Howells <dhowells@redhat.com>,
        Bob Liu <lliubbo@gmail.com>, "David S. Miller" <davem@davemloft.net>,
        Richard Weinberger <richard@nod.at>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Matt Turner <mattst88@gmail.com>, nikunj@linux.vnet.ibm.com
Subject: Re: [PATCH 03/27] smpboot: Define and use cpu_state per-cpu	variable
 in generic code
References: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com> <20120601091038.31979.67878.stgit@srivatsabhat.in.ibm.com> <4FC8B342.9070309@linux.vnet.ibm.com> <20120601122554.GA25595@n2100.arm.linux.org.uk>
In-Reply-To: <20120601122554.GA25595@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12060112-4790-0000-0000-0000030A579A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2012 05:55 PM, Russell King - ARM Linux wrote:

> On Fri, Jun 01, 2012 at 05:49:14PM +0530, Srivatsa S. Bhat wrote:
>> Adding arch maintainers to Cc, which I had missed earlier. No changes to the 
>> patch.
> 
> Could someone explain what this variable does - afaics this patch adds
> this per-cpu variable to all SMP architectures where its required or
> not, and (so far) the generic code just writes one value to it.
>


Several architectures use this per-cpu variable to track the state of the cpu
(like CPU_DEAD), particularly to deal with cpu offline.

(At this point, we have just tried to generalize code without any major
functional changes.)
 

> Are there plans to make use of this in other generic code?
>


The idea of this patchset is to make smp booting and cpu hotplug code as
generic as possible and eventually have _one_ implementation in the generic
code which can be reused by all architectures that want it.

And this patchset generalizes only the booting of secondary cpus. But in
future, we can use this as a base and implement cpu hotplug handling in
generic code, where this variable will become more useful.


Regards,
Srivatsa S. Bhat

