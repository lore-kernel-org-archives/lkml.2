Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906Ab2GaQnw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 12:43:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58645 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755757Ab2GaQnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 12:43:49 -0400
Message-ID: <50180B2A.6070602@zytor.com>
Date: Tue, 31 Jul 2012 09:43:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: NeilBrown <neilb@suse.de>, james.t.kukunas@linux.intel.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86, avx: don't use avx instructions with "noxsave" boot
 param
References: <1343688375.3696.597.camel@sbsiddha-desk.sc.intel.com>  <20120731142049.7d0ab5f9@notabene.brown>  <7b101443-b8d7-4474-ab54-03692d232469@email.android.com> <1343752022.3696.602.camel@sbsiddha-desk.sc.intel.com>
In-Reply-To: <1343752022.3696.602.camel@sbsiddha-desk.sc.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2012 09:27 AM, Suresh Siddha wrote:
> On Mon, 2012-07-30 at 21:33 -0700, H. Peter Anvin wrote:
>> I'm wondering if we shouldn't just kill the affected CPUID bits if osxsave is off...
>
> Yes, I considered clearing AVX bit (and any future xsave feature bits)
> as part of the parsing "noxsave" parameter in x86_xsave_setup().
>
> But thought checking for osxsave was more explicit and there are not
> many places using avx code. Also, this follows the SDM guidelines and
> sets a nice precedent for someone (app's) to follow in future.
>
> I am ok either way!
>

My main reason for thinking that it would be good to clear the bits is 
that it plays a lot nicer with alternatives and with static_cpu_has().

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

