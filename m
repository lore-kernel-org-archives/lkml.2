Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934350Ab0KQJF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 04:05:28 -0500
Received: from claw.goop.org ([74.207.240.146]:34305 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933334Ab0KQJFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 04:05:24 -0500
Message-ID: <4CE39AD2.9080606@goop.org>
Date: Wed, 17 Nov 2010 01:05:22 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Jan Beulich <JBeulich@novell.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Eric Dumazet <dada1@cosmosbay.com>, xiyou.wangcong@gmail.com,
        Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@kernel.dk>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Xen-devel <xen-devel@lists.xensource.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 13/14] x86/ticketlock: add slowpath logic
References: <cover.1289940821.git.jeremy.fitzhardinge@citrix.com><cover.1289940821.git.jeremy.fitzhardinge@citrix.com> <97ed99ae9160bdb6477284b333bd6708fb7a19cb.1289940821.git.jeremy.fitzhardinge@citrix.com> <4CE3A1060200007800022B04@vpn.id2.novell.com> <4CE397C8.9040901@goop.org> <4CE3992E.2070406@redhat.com>
In-Reply-To: <4CE3992E.2070406@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2010 12:58 AM, Avi Kivity wrote:
>> Actually in this case I'm pretty sure there's already a "set bit"
>> function which will do the job.  set_bit(), I guess, though it takes a
>> bit number rather than a mask...
>>
>
>
> set_bit() operates on a long, while the intel manuals recommend
> against operating on operands of different size, especially with
> locked operations.  I think newer processors have more relaxed
> requirements, though.

Despite its prototype, set_bit() is pretty specifically using "orb" for
a the constant case, or bts otherwise (I don't know what size memory
operation bts is considered to generate).

    J

