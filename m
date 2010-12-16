Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab0LPQRU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 11:17:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43965 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752620Ab0LPQRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 11:17:16 -0500
Message-ID: <4D0A3B69.6080700@zytor.com>
Date: Thu, 16 Dec 2010 08:16:41 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Vivek Goyal <vgoyal@redhat.com>,
        Maxim Uvarov <muvarov@gmail.com>, linux-kernel@vger.kernel.org,
        Neil Horman <nhorman@redhat.com>
Subject: Re: kdump broken on 2.6.37-rc4
References: <20101208141942.GA2335@redhat.com> <4D00823A.9050808@kernel.org> <20101209124117.GA6032@redhat.com> <4D01377B.5070809@kernel.org> <20101213100848.GA2237@redhat.com> <4D0663F0.2060103@kernel.org> <4D06783C.6040009@zytor.com> <20101214224135.GB19693@redhat.com> <20101215103954.GA2243@redhat.com> <4D09958D.2040907@kernel.org> <20101216100050.GA2261@redhat.com>
In-Reply-To: <20101216100050.GA2261@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2010 02:00 AM, Stanislaw Gruszka wrote:
> On Wed, Dec 15, 2010 at 08:29:01PM -0800, Yinghai Lu wrote:
>> please check
>>
>> [PATCH] x86, crashkernel, 32bit: only try to get range under 512M
>>
>> Steanishlaw report kdump is 32bit is broken.
> LOL
> 
>> in misc.c for decompresser, it will do sanity checking to make sure heap
>> heap under 512M.
>>
>> So limit it in first kernel under 512M for 32bit system.
>>
>> Reported-by: Stanislaw Gruszka <sgruszka@redhat.com>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> Patch fix problem on my T-60 laptop.
> 
> As expected patch does not help on my other T-500 x86_64 system,
> kdump not work there, but perhaps this is a different problem,
> I'm going to check it.
> 

I think limiting kdump below 512 MiB on 32 bits may make sense; perhaps
even on 64 bits.  It's pretty conservative, after all...

Opinions?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

