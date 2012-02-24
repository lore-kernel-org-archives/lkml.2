Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349Ab2BXWZG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 17:25:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34748 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756286Ab2BXWZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 17:25:04 -0500
Message-ID: <4F480DDF.2080000@zytor.com>
Date: Fri, 24 Feb 2012 14:23:27 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: Kconfig and toolchain dependencies
References: <4F2C51A5.1040800@zytor.com> <4F480CDE.8010605@suse.cz>
In-Reply-To: <4F480CDE.8010605@suse.cz>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2012 02:19 PM, Michal Marek wrote:
> Dne 3.2.2012 22:29, H. Peter Anvin napsal(a):
>> Right now, we don't have a good way to encode toolchain dependencies in
>> Kconfig.  This makes it hard to add optional features which depend on
>> newer toolchain features.
>>
>> If we just add them, then it breaks all*config and randconfig on
>> platforms with the older toolchains unless the user manually adds
>> exclusion rules.  This is bad for testing.
>>
>> It seems relatively straightforward to do if we were to manifest some
>> CONFIG_ variables based on the target toolchain, e.g.
>>
>> CONFIG_GCC=0x040601
> 
> (sorry for the late reply)
> 
> It would be a bit tricky, because the toolchain version depends also on
> CONFIG_CROSS_COMPILE. So Kconfig would need to know the semantics of
> CONFIG_CROSS_COMPILE and CONFIG_GCC and the dependency of the latter on
> the former.
> 
> Michal

Either way it would mean having to regenerate the config when the
toolchain changes.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

