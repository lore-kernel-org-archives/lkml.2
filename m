Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284Ab2JVVG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 17:06:56 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52981 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144Ab2JVVGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 17:06:54 -0400
MIME-Version: 1.0
In-Reply-To: <5085B3F6.4060906@zytor.com>
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
	<CAE9FiQWZmwa6EwsfZzz_e3A-tz2LUS2+i+zh4zpXpR_Jj_FQ1w@mail.gmail.com>
	<5085ABEF.3060502@linux.intel.com>
	<CAE9FiQW0rQFUgjiYjByA91XCUUqo59zz2kXc9Z5wXk+3vKPKaQ@mail.gmail.com>
	<5085B3F6.4060906@zytor.com>
Date: Mon, 22 Oct 2012 14:06:53 -0700
X-Google-Sender-Auth: qHe_ozboBNRcibc3VuQa8iPuJDU
Message-ID: <CAE9FiQU3yM43JXG4pQNgJobFzy+HH_BjtGZ1WG0sBc7Ud6+9KQ@mail.gmail.com>
Subject: Re: BUG: 1bbbbe7 (x86: Exclude E820_RESERVED regions...) PANIC on boot
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Jacob Shin <jacob.shin@amd.com>,
        Tom Rini <trini@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 2:00 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 10/22/2012 01:50 PM, Yinghai Lu wrote:
>>>
>>> We should not map a partial page at the end of RAM; it is functionally
>>> lost.
>>
>> Now we did not, we have max_low_pfn, and max_pfn to cap out end partial page.
>>
>
> Well, it is not just end of RAM, which is where the entire current
> implementation falls apart, obviously.
>

ok, I will fix that from memblock_x86_fill().

after we put the E820_RAM  and E820_RESERVED_KERN in to memblock, do
one trim in memblock.memory.

Thanks

Yinghai Lu
