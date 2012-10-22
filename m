Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187Ab2JVVZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 17:25:29 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61282 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756052Ab2JVVZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 17:25:26 -0400
MIME-Version: 1.0
In-Reply-To: <5085B207.5010907@linux.intel.com>
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
	<5085B207.5010907@linux.intel.com>
Date: Mon, 22 Oct 2012 14:25:25 -0700
X-Google-Sender-Auth: h5_rVrevw2LpEnwevyUWTynM0w0
Message-ID: <CAE9FiQVt5LN6_wDvS2G+UULD4Ba2CF=zLhg4RULSKbfbct0NLg@mail.gmail.com>
Subject: Re: BUG: 1bbbbe7 (x86: Exclude E820_RESERVED regions...) PANIC on boot
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Jacob Shin <jacob.shin@amd.com>, Tom Rini <trini@ti.com>, hpa@zytor.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 1:52 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
> On 10/22/2012 01:50 PM, Yinghai Lu wrote:
>> ok, let's see if we can meet this extreme corner case except user
>> specify not page aligned "memmap="
>
> If it is *only* memmap= there is a very simple solution: if the memmap
> is RAM then we round up the starting address and round down the end
> address; if the memmap is not RAM then we round up instead...

We never know that bios guys will not let bios produce crazy e820 map.
