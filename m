Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab1JMPdM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 11:33:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:45848 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464Ab1JMPdK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 11:33:10 -0400
Subject: Re: [PATCH][v2] uio: Support 36-bit physical addresses on 32-bit systems
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=US-ASCII
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <CAOZdJXWd_u_EWXNhh3-t258+Y8mx=JuJhU93CeZfaocPZvhOFA@mail.gmail.com>
Date: Thu, 13 Oct 2011 10:32:51 -0500
Cc: "hjk@hansjkoch.de" <hjk@hansjkoch.de>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "gregkh@suse.de" <gregkh@suse.de>,
        Jiang Kai-B18973 <B18973@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7BIT
Message-Id: <9BD33578-CD8E-4784-AC6A-ADE4614E0FC1@kernel.crashing.org>
References: <1318453063-17349-1-git-send-email-galak@kernel.crashing.org> <CAOZdJXWd_u_EWXNhh3-t258+Y8mx=JuJhU93CeZfaocPZvhOFA@mail.gmail.com>
To: Tabi Timur-B04825 <B04825@freescale.com>
X-Mailer: Apple Mail (2.1251.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 13, 2011, at 9:37 AM, Tabi Timur-B04825 wrote:

> On Wed, Oct 12, 2011 at 3:57 PM, Kumar Gala <galak@kernel.crashing.org> wrote:
>> From: Kai Jiang <Kai.Jiang@freescale.com>
>> 
>> To support >32-bit physical addresses for UIO_MEM_PHYS type we need to
>> extend the width of 'addr' in struct uio_mem.  Numerous platforms like
>> embedded PPC, ARM, and X86 have support for systems with larger physical
>> address than logical.
>> 
>> Since 'addr' may contain a physical, logical, or virtual address the
>> easiest solution is to just change the type to 'unsigned long long'
>> regardless of which type is utilized.
> 
> You forgot to update this description.

will fix and update commit message

> 
>>  struct uio_mem {
>>        const char              *name;
>> -       unsigned long           addr;
>> +       phys_addr_t             addr;
> 
> Please add a comment here saying:
> 
> 1) That 'addr' can be a virtual or physical address

The code and everything else makes that clear

> 2) That the kernel guarantees that sizeof(phys_addr_t) >= sizeof(void
> *), so it's safe to use phys_addr_t for a virtual pointer.

The commit message will cover that so I don't plan on add it.

- k