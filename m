Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915Ab2F1RfB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 13:35:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48674 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753951Ab2F1Re6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 13:34:58 -0400
Message-ID: <4FEC95BC.200@redhat.com>
Date: Thu, 28 Jun 2012 20:34:52 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH 00/18] KVM: x86: CPU isolation and direct interrupts
 handling by guests
References: <20120628060719.19298.43879.stgit@localhost.localdomain> <4FEC8D31.3070406@redhat.com> <4FEC93BD.2070809@siemens.com>
In-Reply-To: <4FEC93BD.2070809@siemens.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 08:26 PM, Jan Kiszka wrote:
>> 
>> This is both impressive and scary.  What is the target scenario here?
>> Partitioning?  I don't see this working for generic consolidation.
>> 
> 
> From my POV, partitioning - including hard realtime partitions - would
> provide some use cases. But, as far as I saw, there are still major
> restrictions in this approach, e.g. that you can't return to userspace
> on the slave core. Or even execute the in-kernel device models on that core.
> 
> I think we need something based on the no-hz work on the long run, ie.
> the ability to run a single VCPU thread of the userland hypervisor on a
> single core with zero rescheduling and unrelated interruptions - as far
> as the guest load scenario allows this (we have some here).

What we can do perhaps is switch from direct mode to indirect mode on
exit.  Instead of running with interrupts disabled, enable interrupts
and make sure they are forwarded to the guest on the next entry.

> Well, and we need proper hardware support for direct IRQ injection on x86...

Hardware support always helps, but it always seems to come after the
software support is in place and needs to be supported forever.

-- 
error compiling committee.c: too many arguments to function


