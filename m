Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab2JVV1x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 17:27:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36841 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950Ab2JVV1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 17:27:52 -0400
Message-ID: <5085BA4A.30800@zytor.com>
Date: Mon, 22 Oct 2012 14:27:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, Jacob Shin <jacob.shin@amd.com>,
        Tom Rini <trini@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: BUG: 1bbbbe7 (x86: Exclude E820_RESERVED regions...) PANIC on
 boot
References: <903a3ead-98b5-4afa-88a4-3dc723895e82@blur> <d556fc0f-da5d-4531-b331-6dc086461f34@blur> <50833F30.4020802@ti.com> <CAE9FiQWpSvKp=Oh+4Y8OpdOjdRnkYVL2HvNNXc29ESpNsMC0AQ@mail.gmail.com> <20121021041858.GA14809@jshin-Toonie> <50843627.4020103@ti.com> <20121021210633.GA14311@jshin-Toonie> <508467EE.4040807@ti.com> <20121022144020.GA14425@jshin-Toonie> <CAE9FiQWvVNCK8Ka6rq+RMf3u4JFn8D18rGMy4Hpz7Rhnrn6VTA@mail.gmail.com> <20121022183858.GA31185@jshin-Toonie> <CAE9FiQWZmwa6EwsfZzz_e3A-tz2LUS2+i+zh4zpXpR_Jj_FQ1w@mail.gmail.com> <5085ABEF.3060502@linux.intel.com> <CAE9FiQW0rQFUgjiYjByA91XCUUqo59zz2kXc9Z5wXk+3vKPKaQ@mail.gmail.com> <5085B207.5010907@linux.intel.com> <CAE9FiQVt5LN6_wDvS2G+UULD4Ba2CF=zLhg4RULSKbfbct0NLg@mail.gmail.com>
In-Reply-To: <CAE9FiQVt5LN6_wDvS2G+UULD4Ba2CF=zLhg4RULSKbfbct0NLg@mail.gmail.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2012 02:25 PM, Yinghai Lu wrote:
> On Mon, Oct 22, 2012 at 1:52 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>> On 10/22/2012 01:50 PM, Yinghai Lu wrote:
>>> ok, let's see if we can meet this extreme corner case except user
>>> specify not page aligned "memmap="
>>
>> If it is *only* memmap= there is a very simple solution: if the memmap
>> is RAM then we round up the starting address and round down the end
>> address; if the memmap is not RAM then we round up instead...
> 
> We never know that bios guys will not let bios produce crazy e820 map.
> 

Yeah, well, that just *will* happen... that's a given.

We can trim those ranges, though.  Who cares if we lose some RAM.

	-hpa


