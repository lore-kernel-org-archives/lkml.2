Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762874Ab2KBOBQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 10:01:16 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:57240 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752209Ab2KBOBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 10:01:14 -0400
Date: Fri, 2 Nov 2012 14:01:13 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Jesse Gross <jesse@nicira.com>
cc: Shan Wei <shanwei88@gmail.com>, dev@openvswitch.org,
        NetDev <netdev@vger.kernel.org>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH 4/9] net: openvswitch: use this_cpu_ptr per-cpu helper
In-Reply-To: <CAEP_g=-GSpSJkeZbwDpBwo-in0FYD=LjWdCFsdo7-a=ssL41nA@mail.gmail.com>
Message-ID: <0000013ac16cefd9-5db44ae3-c74f-4bac-a88e-caf1ff5ccdd6-000000@email.amazonses.com>
References: <50910A04.5000003@gmail.com> <0000013ab7e86f8a-4adb8b81-19be-4264-96f1-924aaf3819f2-000000@email.amazonses.com> <509249C7.3080000@gmail.com> <0000013abc646055-30441bd6-241f-436a-a356-9cd462da66ce-000000@email.amazonses.com>
 <CAEP_g=-GSpSJkeZbwDpBwo-in0FYD=LjWdCFsdo7-a=ssL41nA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Nov 2012, Jesse Gross wrote:

> On Thu, Nov 1, 2012 at 7:33 AM, Christoph Lameter <cl@linux.com> wrote:
> > On Thu, 1 Nov 2012, Shan Wei wrote:
> >
> >> But for different field in same per-cpu variable, how to guarantee n_missed
> >> and n_hit are from same cpu?
> >> this_cpu_read(dp->stats_percpu->n_missed);
> >> [processor changed]
> >> this_cpu_read(dp->stats_percpu->n_hit);
> >
> > What does current guarantee that? If it is guaranteed then you can use the
> > __this_cpu_xxx ops.
>
> Preemption is disabled in all of the places where writes are done and
> all of the reads are from foreign CPUs.

Since preemption is disabled no processor change can occur. So its safe to
use __this_cpu ops throughout and they will operate on the current per cpu
area.

