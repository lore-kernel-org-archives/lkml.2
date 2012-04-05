Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab2DEMvQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 08:51:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549Ab2DEMvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 08:51:14 -0400
Message-ID: <4F7D9534.90604@redhat.com>
Date: Thu, 05 Apr 2012 15:51:00 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        kvm@vger.kernel.org,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Subject: Re: CPU softlockup due to smp_call_function()
References: <CA+1xoqeqyFT0eHS2k+vskPFQ-5gJ_Uq1HVsq2DA2sS1uN9C0vw@mail.gmail.com> <4F7D8F16.9090904@redhat.com> <CA+1xoqeeagx=OwV2XFQYb=ATOGtW0Zpyx6BOcVbu3hg+eiMqSA@mail.gmail.com>
In-Reply-To: <CA+1xoqeeagx=OwV2XFQYb=ATOGtW0Zpyx6BOcVbu3hg+eiMqSA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2012 03:32 PM, Sasha Levin wrote:
> >
> > It would be good to enhance smp_call_function_*() to do this
> > automatically when it happens - it's spinning there anyway, so it might
> > as well count the iterations and NMI the lagging cpu if it waits for too
> > long.
>
> What do you think about modifying the softlockup detector to NMI all
> CPUs if it's going to panic because it detected a lockup?

Fine by me.  The triggering cpu should be dumped first though.

We lose knowledge of exactly which cpu is hung, but it should usually be
easily seen from the traces (the exceptional case would be a busy server
that is handling a lot of IPIs at the moment we trigger the traces).

-- 
error compiling committee.c: too many arguments to function

