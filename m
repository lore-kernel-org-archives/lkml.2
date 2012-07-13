Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933511Ab2GMSNA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 14:13:00 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:57451 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932677Ab2GMSM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 14:12:59 -0400
MIME-Version: 1.0
In-Reply-To: <5000259D.9020303@canonical.com>
References: <5000259D.9020303@canonical.com>
Date: Fri, 13 Jul 2012 11:12:58 -0700
X-Google-Sender-Auth: LImyXLkzQrwKp_vxPPhmjND01Ak
Message-ID: <CAE9FiQUxRyVLu-sgrQ-GtRye=CqGHcf9=WA-omz1s5GrxofrJg@mail.gmail.com>
Subject: Re: x86/mm: Limit 2/4M size calculation to x86_32
From: Yinghai Lu <yinghai@kernel.org>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, WANG Cong <xiyou.wangcong@gmail.com>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 6:41 AM, Stefan Bader
<stefan.bader@canonical.com> wrote:
> I was bisecting a problem on 64bit where any attempt to cause a crash kernel to
> boot would hang. The bisect ended up on commit 722bc6b (x86/mm: Fix the size
> calculation of mapping tables) and somehow, looking at the calling function and
> the ranges printed on boot, I think the calculations should only be done in the
> 32bit case.
>
> On 64bit:
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x77e87fff]
> [    0.000000]  [mem 0x00000000-0x77dfffff] page 2M
> [    0.000000]  [mem 0x77e00000-0x77e87fff] page 4k
>
> Attached patch would fix this if you agree with it. Thanks.

it does not look like for the hang for your system. maybe just because
it change a bit memblock allocation layout.

can you please post whole boot log that is working and not?

Thanks

Yinghai
