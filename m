Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933465Ab0GOPCM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 11:02:12 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:58921 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933380Ab0GOPCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 11:02:08 -0400
Subject: Re: kmemleak, cpu usage jump out of nowhere
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Zeno Davatz <zdavatz@gmail.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4C3D89AC.4040303@cs.helsinki.fi>
References: <AANLkTil6opQmTVVxuP1ngz72_ijpLzdlSFWDSyi4whOt@mail.gmail.com>
	 <AANLkTinGoUml9PQ8w7flukqwF9V1ae-YafiDVQy6Q8gC@mail.gmail.com>
	 <AANLkTimgn1Xa0YIwjC6xOfNDjlqJSQYy65ZvqCtlMWHD@mail.gmail.com>
	 <1279100846.8592.53.camel@e102109-lin.cambridge.arm.com>
	 <4C3D89AC.4040303@cs.helsinki.fi>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Thu, 15 Jul 2010 15:58:11 +0100
Message-ID: <1279205891.6664.46.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jul 2010 14:58:12.0039 (UTC) FILETIME=[2523CD70:01CB242E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-14 at 10:55 +0100, Pekka Enberg wrote:
> Catalin Marinas wrote:
> > On Wed, 2010-07-14 at 09:27 +0100, Zeno Davatz wrote:
> >> On Wed, Jul 14, 2010 at 10:05 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> >>> On Wed, Jul 14, 2010 at 9:12 AM, Zeno Davatz <zdavatz@gmail.com> wrote:
> >
> >>>> I am attaching you the file from /sys/kernel/debug/kmemleak
> >>> Zeno, can you post your dmesg and .config, please?
> >> Sure, see attached files.
> >
> > It looks like NO_BOOTMEM is enabled. You can try the attached patch (I
> > need to post it again on the list).
> >
> >
> > kmemleak: Add support for NO_BOOTMEM configurations
> >
> > From: Catalin Marinas <catalin.marinas@arm.com>
> >
> > With commits 08677214 and 59be5a8e, alloc_bootmem()/free_bootmem() and
> > friends use the early_res functions for memory management when
> > NO_BOOTMEM is enabled. This patch adds the kmemleak calls in the
> > corresponding code paths for bootmem allocations.
> >
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Yinghai Lu <yinghai@kernel.org>
> > Cc: H. Peter Anvin <hpa@zytor.com>
> 
> Makes sense.
> 
> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

I'll post an updated patch since I missed a callback. I've been testing
it since yesterday and seems ok.

Thanks.

-- 
Catalin

