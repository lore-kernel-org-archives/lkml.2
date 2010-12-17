Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760Ab0LQBG5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 20:06:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48621 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754320Ab0LQBG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 20:06:56 -0500
Message-ID: <4D0AB78A.2050608@zytor.com>
Date: Thu, 16 Dec 2010 17:06:18 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Maxim Uvarov <muvarov@gmail.com>,
        linux-kernel@vger.kernel.org, Neil Horman <nhorman@redhat.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: kdump broken on 2.6.37-rc4
References: <20101208141942.GA2335@redhat.com> <4D00823A.9050808@kernel.org> <20101209124117.GA6032@redhat.com> <4D01377B.5070809@kernel.org> <20101213100848.GA2237@redhat.com> <4D0663F0.2060103@kernel.org> <4D06783C.6040009@zytor.com> <20101214224135.GB19693@redhat.com> <20101215103954.GA2243@redhat.com> <4D09958D.2040907@kernel.org> <20101216143925.GA13870@redhat.com> <4D0A3E31.4000109@zytor.com> <4D0A4C51.3070008@kernel.org> <4D0A6F66.1010006@zytor.com> <4D0AA116.4050707@kernel.org> <4D0AA592.3060805@kernel.org> <4D0AB14F.9050900@kernel.org>
In-Reply-To: <4D0AB14F.9050900@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2010 04:39 PM, Yinghai Lu wrote:
> 
> and use that to estimate BRK size.
> 
> so we could change the BRK calculating code to handle 896M or just limit crashkernel for 32bit to 512M...
> 
> handle 896M one:
> 


Grmf... this was originally 4 GiB, but someone tried to tighten the
bound.  I think we should set it back to 4 GiB; 896 MiB is still
approximate.

Oh yes, this isn't how to write this, either...

> + * to make crashkernel bzImage to stay high, make it map to 896M
> + *  but it will be claimed back when brk is concluded. So no wasting.
>   */
> -KERNEL_PAGES = (KERNEL_IMAGE_SIZE + MAPPING_BEYOND_END)>>PAGE_SHIFT
> +KERNEL_PAGES = (KERNEL_IMAGE_SIZE + (384<<20) + MAPPING_BEYOND_END)>>PAGE_SHIFT

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

