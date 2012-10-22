Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab2JVTqj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 15:46:39 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57411 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394Ab2JVTqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 15:46:38 -0400
MIME-Version: 1.0
In-Reply-To: <20121022183858.GA31185@jshin-Toonie>
References: <903a3ead-98b5-4afa-88a4-3dc723895e82@blur>
	<d556fc0f-da5d-4531-b331-6dc086461f34@blur>
	<50833F30.4020802@ti.com>
	<CAE9FiQWpSvKp=Oh+4Y8OpdOjdRnkYVL2HvNNXc29ESpNsMC0AQ@mail.gmail.com>
	<20121021041858.GA14809@jshin-Toonie>
	<50843627.4020103@ti.com>
	<20121021210633.GA14311@jshin-Toonie>
	<508467EE.4040807@ti.com>
	<20121022144020.GA14425@jshin-Toonie>
	<CAE9FiQWvVNCK8Ka6rq+RMf3u4JFn8D18rGMy4Hpz7Rhnrn6VTA@mail.gmail.com>
	<20121022183858.GA31185@jshin-Toonie>
Date: Mon, 22 Oct 2012 12:46:36 -0700
X-Google-Sender-Auth: zpGL0rWynBBQL_rrpOvtHLnHna0
Message-ID: <CAE9FiQWZmwa6EwsfZzz_e3A-tz2LUS2+i+zh4zpXpR_Jj_FQ1w@mail.gmail.com>
Subject: Re: BUG: 1bbbbe7 (x86: Exclude E820_RESERVED regions...) PANIC on boot
From: Yinghai Lu <yinghai@kernel.org>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Tom Rini <trini@ti.com>, hpa@zytor.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "stable@kernel.org" <stable@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 11:38 AM, Jacob Shin <jacob.shin@amd.com> wrote:
>
> Does EFI do this on above 4G memory? All the EFI BIOSes we have in house looked
> to be only touching under 4G.

I have no idea about it.

>
>>
>> 2. partial page:
>>    E820 or user could pass memmap that  is not page aligned.
>>    old cold will guarded by max_low_pfn and max_pfn. so the end partial
>>    page will be trimmed down, and memblock can one use it.
>>    middle partial page will still get covered by directly mapping, and
>> memblock still can use them.
>>    Now we will not map middle partial page and memblock still try to use it
>> we could get panic when accessing those pages.
>>
>> So I would suggest to just revert that temporary patch at this time,
>> and later come out one complete patch for stable kernels.
>
> Hm okay, I was hoping not, but if it has to be ..

It's hpa's call.
