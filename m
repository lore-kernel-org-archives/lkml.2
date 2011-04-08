Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842Ab1DHW7o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 18:59:44 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:33043 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab1DHW7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 18:59:43 -0400
Message-ID: <4D9F9359.20708@codemonkey.ws>
Date: Fri, 08 Apr 2011 17:59:37 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
        mtosatti@redhat.com, kvm@vger.kernel.org, joro@8bytes.org,
        penberg@cs.helsinki.fi, asias.hejun@gmail.com, gorcunov@gmail.com
Subject: Re: [ANNOUNCE] Native Linux KVM tool
References: <1301592656.586.15.camel@jaguar> <4D982E89.8070502@redhat.com> <BANLkTinbCAUqaKfmKaj-7GXTh9F2if0x+Q@mail.gmail.com> <4D9847BC.9060906@redhat.com> <4D98716D.9040307@codemonkey.ws> <4D9873CD.3080207@redhat.com> <20110406093333.GB6465@elte.hu> <4D9E6F6E.9050709@codemonkey.ws> <BANLkTimEwAuL4PM9vBfogkrua-Z44AZQvg@mail.gmail.com> <4D9F150B.1030809@codemonkey.ws> <20110408192039.GJ29444@random.random>
In-Reply-To: <20110408192039.GJ29444@random.random>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2011 02:20 PM, Andrea Arcangeli wrote:
> Hi Anthony,
>
> On Fri, Apr 08, 2011 at 09:00:43AM -0500, Anthony Liguori wrote:
>> An example is ioport_ops.  This maps directly to
>> ioport_{read,write}_table in QEMU.  Then you use ioport__register() to
>> register entries in this table similar register_ioport_{read,write}() in
>> QEMU.
>>
>> The use of a struct is a small improvement but the fundamental design is
>> flawed because it models a view of hardware where all devices are
>> directly connected to the CPU.  This is not how hardware works at all.
> Not sure if I've the whole picture on this but I see no answer to your
> email and I found your remark above the most interesting. This is
> because I thought the whole point of a native kvm tool was to go all
> the paravirt way to provide max performance and maybe also depend on
> vhost as much as possible.

Yeah, if that's the goal, skip all the mini-BIOS junk and just rely on a 
PV kernel in the guest.

I think a mini userspace that assumes that we can change the guest 
kernel and avoids having a ton of complexity to do things like CMOS 
emulation would be a really interesting thing to do.

Regards,

Anthony Liguori
