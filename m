Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab2E2Uze (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 16:55:34 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:59798 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667Ab2E2Uzc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 16:55:32 -0400
Date: Tue, 29 May 2012 16:53:56 -0400 (EDT)
Message-Id: <20120529.165356.1274422750750961204.davem@davemloft.net>
To: yinghai@kernel.org
Cc: hpa@zytor.com, tony.luck@intel.com, bhelgaas@google.com,
        torvalds@linux-foundation.org, steve@snewbury.org.uk,
        akpm@linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/11] PCI: Try to allocate mem64 above 4G at first
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAE9FiQUWMAdU5jtKfq1_=1E-574gW-Afo8Pby49mUFQYFrs9Pw@mail.gmail.com>
References: <CAE9FiQUtio=dut3A9+jCcsgUWEeNYcpqLP6RpqGOZUfPPAtHWw@mail.gmail.com>
	<4FC51D79.6010804@zytor.com>
	<CAE9FiQUWMAdU5jtKfq1_=1E-574gW-Afo8Pby49mUFQYFrs9Pw@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 29 May 2012 13:53:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>
Date: Tue, 29 May 2012 13:46:03 -0700

> On Tue, May 29, 2012 at 12:03 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 05/29/2012 11:17 AM, Yinghai Lu wrote:
>>> so during allocating, could have allocated above 64k address to non
>>> 32bit bridge.
>>>
>>> but  x86 is ok, because ioport.end always set to 0xffff.
>>> other arches with IO_SPACE_LIMIT with 0xffffffff or
>>> 0xffffffffffffffffUL may have problem.
>>
>> The latter is nonsense, the PCI-side address space is only 32 bits wide.
>>
> maybe they have unified io include ioport and mem io?

The resource values stored are the actual physical I/O addresses on
some platforms.  Sparc, for example, falls into this category.

Therefore ~0UL is the only feasible limit for them.

We have to distinguish explicitly when we are operating upon actual
PCI bus view addresses vs. the values that end up in the resources.
They are entirely different, and have completely different address
ranges.
