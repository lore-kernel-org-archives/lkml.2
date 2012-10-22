Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab2JVQdL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 12:33:11 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59963 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab2JVQdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 12:33:08 -0400
MIME-Version: 1.0
In-Reply-To: <20121022142143.GC14193@konrad-lan.dumpdata.com>
References: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
	<1350593430-24470-5-git-send-email-yinghai@kernel.org>
	<20121022142143.GC14193@konrad-lan.dumpdata.com>
Date: Mon, 22 Oct 2012 09:33:07 -0700
X-Google-Sender-Auth: xT2vXQtFljija2Y8Kxb50l69rtU
Message-ID: <CAE9FiQW6+sjwBH9Rx634d6FpyG7DV9RYVg3AJKK5tW5Aa-D+Qg@mail.gmail.com>
Subject: Re: [PATCH 02/19] x86, mm: Use big page size for small memory range
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

On Mon, Oct 22, 2012 at 7:21 AM, Konrad Rzeszutek Wilk
<konrad@kernel.org> wrote:
> On Thu, Oct 18, 2012 at 01:50:12PM -0700, Yinghai Lu wrote:
>> We could map small range in the middle of big range at first, so should use
>> big page size at first to avoid using small page size to break down page table.
>>
>> Only can set big page bit when that range has ram area around it.
>
> The code looks good.
>
> I would alter the description to say:
>
> (Describe the problem)
>
> "We are wasting entries in the page-table b/c are not taking advantage
> of the fact that adjoining ranges could be of the same type and
> coalescing them together. Instead we end up using the small size type."
>
> (Explain your patch).
>
> "We fix this by iterating over the ranges, detecting whether the
> ranges that are next to each other are of the same type - and if so
> set them to our type."

I think my commit change log is clear enough, and will not update it.
