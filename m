Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762606Ab2KBBi7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 21:38:59 -0400
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:41728 "HELO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762479Ab2KBBi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 21:38:56 -0400
MIME-Version: 1.0
In-Reply-To: <0000013abc646055-30441bd6-241f-436a-a356-9cd462da66ce-000000@email.amazonses.com>
References: <50910A04.5000003@gmail.com> <0000013ab7e86f8a-4adb8b81-19be-4264-96f1-924aaf3819f2-000000@email.amazonses.com>
 <509249C7.3080000@gmail.com> <0000013abc646055-30441bd6-241f-436a-a356-9cd462da66ce-000000@email.amazonses.com>
From: Jesse Gross <jesse@nicira.com>
Date: Thu, 1 Nov 2012 18:38:34 -0700
Message-ID: <CAEP_g=-GSpSJkeZbwDpBwo-in0FYD=LjWdCFsdo7-a=ssL41nA@mail.gmail.com>
Subject: Re: [PATCH 4/9] net: openvswitch: use this_cpu_ptr per-cpu helper
To: Christoph Lameter <cl@linux.com>
Cc: Shan Wei <shanwei88@gmail.com>, dev@openvswitch.org,
        NetDev <netdev@vger.kernel.org>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 1, 2012 at 7:33 AM, Christoph Lameter <cl@linux.com> wrote:
> On Thu, 1 Nov 2012, Shan Wei wrote:
>
>> But for different field in same per-cpu variable, how to guarantee n_missed
>> and n_hit are from same cpu?
>> this_cpu_read(dp->stats_percpu->n_missed);
>> [processor changed]
>> this_cpu_read(dp->stats_percpu->n_hit);
>
> What does current guarantee that? If it is guaranteed then you can use the
> __this_cpu_xxx ops.

Preemption is disabled in all of the places where writes are done and
all of the reads are from foreign CPUs.
