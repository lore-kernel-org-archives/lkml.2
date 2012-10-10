Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235Ab2JJBAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 21:00:18 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39181 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174Ab2JJBAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 21:00:14 -0400
MIME-Version: 1.0
In-Reply-To: <20121009154611.GC7639@phenom.dumpdata.com>
References: <CAE9FiQV_xVsHN_+6ui_Vgnn6tk8UBOEKL+0XnoEN9VLw3gcOXA@mail.gmail.com>
	<1349509469-11475-1-git-send-email-yinghai@kernel.org>
	<1349509469-11475-3-git-send-email-yinghai@kernel.org>
	<20121009154611.GC7639@phenom.dumpdata.com>
Date: Tue, 9 Oct 2012 18:00:12 -0700
X-Google-Sender-Auth: kHkFARDgPou0qcm8jytBZZYlWRU
Message-ID: <CAE9FiQV2r6GsuxkceBrR7Tpv40SwQku0Z+ZtMBbNKZ9BJgvUXg@mail.gmail.com>
Subject: Re: [PATCH 2/3] x86, mm: Don't clear page table if next range is ram
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 9, 2012 at 8:46 AM, Konrad Rzeszutek Wilk <konrad@kernel.org> wrote:
>> +                         !e820_any_mapped(addr & PAGE_MASK, next, 0))
>
> What is the 0 parameter for?

any type

if type != 0, the will only check entries with same type.

int
e820_any_mapped(u64 start, u64 end, unsigned type)
{
        int i;

        for (i = 0; i < e820.nr_map; i++) {
                struct e820entry *ei = &e820.map[i];

                if (type && ei->type != type)
                        continue;
                if (ei->addr >= end || ei->addr + ei->size <= start)
                        continue;
                return 1;
        }
        return 0;
}
