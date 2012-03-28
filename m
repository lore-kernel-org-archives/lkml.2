Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab2C1QhV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 12:37:21 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43163 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758261Ab2C1QhT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 12:37:19 -0400
MIME-Version: 1.0
In-Reply-To: <4F716E31.3000803@linux.vnet.ibm.com>
References: <20120321102041.473.61069.sendpatchset@codeblue.in.ibm.com>
	<4F707C5F.1000905@redhat.com>
	<4F716E31.3000803@linux.vnet.ibm.com>
Date: Wed, 28 Mar 2012 09:37:19 -0700
Message-ID: <CAMy5W3cv3SC4Cr1_CyyMW3fa+Wwto_sQ0aPj=eqQTmSt98bBJg@mail.gmail.com>
Subject: Re: [PATCH RFC V6 0/11] Paravirtualized ticketlocks
From: Alan Meadows <alan.meadows@gmail.com>
To: KVM <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am happy to see this issue receiving some attention and second the
wish to see these patches be considered for further review and
inclusion in an upcoming release.

Overcommit is not as common in enterprise and single-tenant
virtualized environments as it is in multi-tenant environments, and
frankly we have been suffering.

We have been running an early copy of these patches in our lab and in
a small production node sample set both on 3.2.0-rc4 and 3.3.0-rc6 for
over two weeks now with great success. With the heavy level of
vCPU:pCPU overcommit required for our situation, the patches are
increasing performance by an _order of magnitude_ on our E5645 and
E5620 systems.

Alan Meadows

On Tue, Mar 27, 2012 at 12:37 AM, Raghavendra K T
<raghavendra.kt@linux.vnet.ibm.com> wrote:
>
> On 03/26/2012 07:55 PM, Avi Kivity wrote:
>>
>> On 03/21/2012 12:20 PM, Raghavendra K T wrote:
>>>
>>> From: Jeremy Fitzhardinge<jeremy.fitzhardinge@citrix.com>
>
> [...]
>
>>>
>>> This series provides a Xen implementation, but it should be
>>> straightforward to add a KVM implementation as well.
>>>
>>
>> Looks like a good baseline on which to build the KVM implementation.  We
>> might need some handshake to prevent interference on the host side with
>> the PLE code.
>>
>
> Avi, Thanks for reviewing. True, it is sort of equivalent to PLE on non
> PLE machine.
>
> Ingo, Peter,
> Can you please let us know if this series can be considered for next merge
> window?
> OR do you still have some concerns that needs addressing.
>
> I shall rebase patches to 3.3 and resend. (main difference would be
> UNINLINE_SPIN_UNLOCK and jump label changes to use static_key_true/false()
> usage instead of static_branch.)
>
> Thanks,
> Raghu
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
