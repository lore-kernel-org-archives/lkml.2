Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292Ab2JJOnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 10:43:18 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:48810 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932204Ab2JJOnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 10:43:17 -0400
MIME-Version: 1.0
In-Reply-To: <20121010134139.GA4005@phenom.dumpdata.com>
References: <CAE9FiQV_xVsHN_+6ui_Vgnn6tk8UBOEKL+0XnoEN9VLw3gcOXA@mail.gmail.com>
	<1349509469-11475-1-git-send-email-yinghai@kernel.org>
	<1349509469-11475-3-git-send-email-yinghai@kernel.org>
	<20121009154611.GC7639@phenom.dumpdata.com>
	<CAE9FiQV2r6GsuxkceBrR7Tpv40SwQku0Z+ZtMBbNKZ9BJgvUXg@mail.gmail.com>
	<20121010134139.GA4005@phenom.dumpdata.com>
Date: Wed, 10 Oct 2012 07:43:15 -0700
X-Google-Sender-Auth: 6d1s6czmPy9XFehT0Ic8KEFYJ-E
Message-ID: <CAE9FiQVfn2fv19ZCJtQBfYDj4VFkD5Ud4pkCRfELZTzf6dzykw@mail.gmail.com>
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

On Wed, Oct 10, 2012 at 6:41 AM, Konrad Rzeszutek Wilk
<konrad@kernel.org> wrote:
> On Tue, Oct 09, 2012 at 06:00:12PM -0700, Yinghai Lu wrote:
>> On Tue, Oct 9, 2012 at 8:46 AM, Konrad Rzeszutek Wilk <konrad@kernel.org> wrote:
>> >> +                         !e820_any_mapped(addr & PAGE_MASK, next, 0))
>> >
>> > What is the 0 parameter for?
>>
>> any type
>
> OK, which means that it either should have a #define for it, or at least
> a comment, like:
>
> 0 /* any type */
>
> as this would make it clear at first glance what it is - without having
> to dive in e820_any_mapped function to determine that.

yes, we should add E820_ANY_TYPE. and update e820_any_mapped to use it.

will address that later in another patch.
