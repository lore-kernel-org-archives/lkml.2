Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590Ab2HUOmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 10:42:11 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51529 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636Ab2HUOmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 10:42:09 -0400
MIME-Version: 1.0
In-Reply-To: <20120821143115.GJ16230@one.firstfloor.org>
References: <1345540117-14164-1-git-send-email-zheng.z.yan@intel.com>
	<20120821143115.GJ16230@one.firstfloor.org>
Date: Tue, 21 Aug 2012 17:42:08 +0300
X-Google-Sender-Auth: UJlDTst60WE7gYBelCeW431USes
Message-ID: <CAOJsxLE8Cn=GRSdeCoeTPKCOB5-gaodnC3W8g93r8mHigC23LA@mail.gmail.com>
Subject: Re: [PATCH] perf/x86: Disable uncore on virtualized CPU.
From: Pekka Enberg <penberg@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, a.p.zijlstra@chello.nl,
        eranian@google.com, mingo@elte.hu, avi@redhat.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 05:08:37PM +0800, Yan, Zheng wrote:
>> From: "Yan, Zheng" <zheng.z.yan@intel.com>
>>
>> Initializing uncore PMU on virtualized CPU may hang the kernel.
>> This is because kvm does not emulate the entire hardware. Thers
>> are lots of uncore related MSRs, making kvm enumerate them all
>> is a non-trival task. So just disable uncore on virtualized CPU.

On Tue, Aug 21, 2012 at 5:31 PM, Andi Kleen <andi@firstfloor.org> wrote:
> I'm not sure cpu_has_hypervisor is reliable enough for this.
> Better find out why it hangs and fix that.
>
> Early rdmsrls should be rdmsrl_safe()
> Early writes in the driver should check if anything was written,
> and if not then disable itself.

It's unfortunate that the changelog does not include any reference to
the actual thread this was discussed in:

http://www.mail-archive.com/kvm@vger.kernel.org/msg77524.html
